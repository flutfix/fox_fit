import 'package:flutter/material.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/models/customer_model_state.dart';
import 'package:fox_fit/models/service.dart';
import 'package:fox_fit/screens/customers/widgets/customer_coontainer.dart';
import 'package:fox_fit/screens/trainer_choosing/widgets/search.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SelectClientPage extends StatefulWidget {
  const SelectClientPage({
    Key? key,
    required this.trainingRecordType,
  }) : super(key: key);

  final TrainingRecordType trainingRecordType;

  @override
  _SelectClientPageState createState() => _SelectClientPageState();
}

class _SelectClientPageState extends State<SelectClientPage> {
  late GeneralController _generalController;
  late ScheduleController _scheduleController;
  late bool _isLoading;
  late TextEditingController _phoneController;
  late FocusNode _phoneFocus;
  late String _phonePrefix;
  late MaskTextInputFormatter _maskFormatter;
  CustomerModel? _client;
  String? _textErrorResultSearch;
  late String _search;

  @override
  void initState() {
    super.initState();
    _generalController = Get.find<GeneralController>();
    _scheduleController = Get.find<ScheduleController>();

    _isLoading = false;
    _phoneFocus = FocusNode();
    _phonePrefix = '+7 ';
    _phoneController = TextEditingController();
    _maskFormatter = MaskTextInputFormatter(
      mask: '+7 ###-###-##-##',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
    );

    _search = '';

    _phoneFocus.addListener(_onFocusChange);

    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: () {
        return _generalController.getRegularCustomers();
      },
      handler: (data) async {
        if (data != 200) {
          CustomSnackbar.getSnackbar(
            title: S.of(context).server_error,
            message: S.of(context).data_download_failed,
          );
          return false;
        }
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getCustomerByPhone({required String search}) async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.request(
      context: context,
      request: () {
        return _scheduleController.getCustomerByPhone(
          userUid: _generalController.appState.value.auth!.users![0].uid,
          phone: search,
        );
      },
      handler: (data) async {
        setState(() {
          /// Если клиент не найден
          if (data == 404 || data == 500) {
            _textErrorResultSearch = S.of(context).client_not_found;
          } else if (data is CustomerModel) {
            _client = data;
          } else {
            _textErrorResultSearch = null;
          }
        });
        return false;
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: CustomAppBar(
        title: S.of(context).choice_client,
        isBackArrow: true,
        isNotification: false,
        onBack: () {
          Get.back();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Search(
              controller: _phoneController,
              textInputType: TextInputType.phone,
              hintText: '+7 ___ ___ __ __',
              maskFormatter: [_maskFormatter],
              phoneFocus: _phoneFocus,
              onSearch: (search) {
                if (_maskFormatter.getUnmaskedText().isEmpty) {
                  _phoneController.value = TextEditingValue(
                    text: _phonePrefix,
                    selection:
                        TextSelection.collapsed(offset: _phonePrefix.length),
                  );
                }

                setState(() {
                  _search = search;
                });

                if (search != '') {
                  /// Форматирование номера для запроса
                  List<String> searchSplit = search.split(' ');
                  searchSplit = [
                    searchSplit[0][1],
                    ...searchSplit[1].split('-')
                  ];
                  search = '';
                  for (var i = 0; i < searchSplit.length; i++) {
                    search += searchSplit[i];
                  }

                  /// Обработка полностью ли введён номер
                  if (search.length != 11) {
                    setState(() {
                      _textErrorResultSearch = S.of(context).enter_full_number;
                      _client = null;
                    });
                  } else {
                    getCustomerByPhone(search: search);
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          if (!_isLoading)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _client != null

                    /// Для найденного клиента
                    ? CustomerContainer(
                        customer: _client!,
                        clientType: ClientType.assigned,
                        onTap: () {
                          List<CustomerModelState>? clientList =
                              _scheduleController.state.value.clients;

                          bool check = checkPresenceInList(
                            clientList: clientList,
                            currentCustomer: _client!,
                          );

                          if (check) {
                            if (_client! !=
                                _scheduleController
                                    .state.value.clients?[0].model) {
                              _scheduleController.clear();
                            }

                            _scheduleController.state.update((model) {
                              model?.clients = [
                                CustomerModelState(
                                  model: _client!,
                                  arrivalStatus: false,
                                ),
                              ];
                              model?.duration = _client!.duration;
                              model?.service?.split = _client!.split ?? false;
                              if (_client!.serviceUid != null &&
                                  _client!.serviceName != null) {
                                model?.service = Service(
                                  uid: _client!.serviceUid!,
                                  name: _client!.serviceName!,
                                );
                              }
                            });

                            Get.back();
                          } else {
                            CustomSnackbar.getSnackbar(
                              title: S.of(context).error,
                              message: S.of(context).this_client_supplied,
                            );
                          }
                        },
                      )
                    : _search.isEmpty

                        /// Список постоянных клиентов
                        ? !_isLoading
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                itemCount: _generalController.appState.value
                                    .sortedCustomers[Client.permanent]!.length,
                                itemBuilder: (context, index) {
                                  List<String> phoneList = _generalController
                                      .appState
                                      .value
                                      .sortedCustomers[Client.permanent]![index]
                                      .phone
                                      .split(' ');

                                  String phone = '';
                                  if (phoneList.length == 3) {
                                    phoneList = [
                                      phoneList[0][1],
                                      phoneList[1].substring(1, 4),
                                      phoneList[2]
                                    ];
                                    for (var i = 0; i < phoneList.length; i++) {
                                      phone += phoneList[i];
                                    }
                                  } else {
                                    phone = phoneList[0];
                                  }

                                  CustomerModel currentCustomer =
                                      _generalController
                                              .appState.value.sortedCustomers[
                                          Client.permanent]![index];
                                  List<CustomerModelState>? clientList =
                                      _scheduleController.state.value.clients;

                                  bool check = checkPresenceInList(
                                    clientList: clientList,
                                    currentCustomer: currentCustomer,
                                  );

                                  if (check) {
                                    return CustomerContainer(
                                      customer: currentCustomer,
                                      clientType: ClientType.permanent,
                                      onTap: () async {
                                        if (widget.trainingRecordType !=
                                            TrainingRecordType.group) {
                                          await getCustomerByPhone(
                                            search: phone,
                                          );
                                          if (_scheduleController
                                                  .state.value.clients !=
                                              null) {
                                            if (currentCustomer !=
                                                _scheduleController.state.value
                                                    .clients![0].model) {
                                              _scheduleController.clear();
                                            }
                                          }

                                          _scheduleController.state
                                              .update((model) {
                                            model?.clients = [
                                              CustomerModelState(
                                                model: currentCustomer,
                                                arrivalStatus: false,
                                              ),
                                            ];
                                            model?.duration = _client?.duration;
                                            model?.service?.split =
                                                _client?.split ?? false;
                                            if (_client?.serviceUid != null &&
                                                _client?.serviceName != null) {
                                              model?.service = Service(
                                                uid: _client!.serviceUid!,
                                                name: _client!.serviceName!,
                                              );
                                            }
                                          });
                                        } else {
                                          List<CustomerModelState>? clientList =
                                              _scheduleController
                                                  .state.value.clients;

                                          if (clientList != null) {
                                            clientList.add(
                                              CustomerModelState(
                                                model: currentCustomer,
                                                arrivalStatus: false,
                                              ),
                                            );
                                          } else {
                                            clientList = [
                                              CustomerModelState(
                                                model: currentCustomer,
                                                arrivalStatus: false,
                                              ),
                                            ];
                                          }

                                          _scheduleController.state
                                              .update((model) {
                                            model?.clients = clientList;
                                          });
                                        }

                                        Get.back();
                                      },
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: DefaultContainer(
                                  child: Center(
                                    child: Text(
                                      _textErrorResultSearch ??
                                          S.of(context).enter_full_number,
                                      style: theme.textTheme.headline3,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                        : const Padding(
                            padding: EdgeInsets.only(top: 18.0),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Служит для проверки, добавлен ли уже клиент в список
  bool checkPresenceInList({
    required List<CustomerModelState>? clientList,
    required CustomerModel currentCustomer,
  }) {
    bool check = true;

    if (clientList != null) {
      for (var client in clientList) {
        if (client.model.uid == currentCustomer.uid) {
          check = false;
          break;
        } else {
          check = true;
        }
      }
    }
    return check;
  }

  /// Подставление [+7] в начало строки, если поле в фокусе
  void _onFocusChange() {
    debugPrint("Focus: ${_phoneFocus.hasFocus.toString()}");
    if (_phoneFocus.hasFocus) {
      if (_phoneController.text.isEmpty) {
        _phoneController.text = _phonePrefix;
      }
    } else {
      if (_phoneController.text == _phonePrefix) {
        _phoneController.clear();
      }
    }
  }
}
