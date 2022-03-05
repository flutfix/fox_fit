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
import 'package:swipe/swipe.dart';

class SelectClientPage extends StatefulWidget {
  const SelectClientPage({Key? key}) : super(key: key);

  @override
  _SelectClientPageState createState() => _SelectClientPageState();
}

class _SelectClientPageState extends State<SelectClientPage> {
  late GeneralController _controller;
  late ScheduleController _scheduleController;
  late bool _isLoading;
  late TextEditingController _phoneController;
  late FocusNode _phoneFocus;
  late String _phonePrefix;
  late MaskTextInputFormatter _maskFormatter;
  CustomerModel? _foundClient;
  late String _textErrorResultSearch;
  late String _search;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<GeneralController>();
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

    _textErrorResultSearch = '';
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
        return _controller.getRegularCustomers();
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
          userUid: _controller.getUid(role: UserRole.trainer),
          phone: search,
        );
      },
      handler: (data) async {
        setState(() {
          /// Если клиент не найден
          if (data != 200 && data is! CustomerModel) {
            _textErrorResultSearch = S.of(context).client_not_found;
          } else if (data is CustomerModel) {
            _foundClient = data;
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
    return Swipe(
      onSwipeRight: () {
        Get.back();
      },
      child: Scaffold(
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
                        _textErrorResultSearch =
                            S.of(context).enter_full_number;
                        _foundClient = null;
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
                  child: _foundClient != null

                      /// Для найденного клиента
                      ? CustomerContainer(
                          customer: _foundClient!,
                          clientType: ClientType.assigned,
                          onTap: () {
                            /// Проверка, выбран ли уже клиент
                            bool check =
                                _scheduleController.state.value.clients.any(
                              (client) => client.model.uid == _foundClient!.uid,
                            );

                            if (!check) {
                              Get.back();

                              _scheduleController.clear(
                                data: false,
                                time: false,
                              );

                              _scheduleController.state.update((model) {
                                model?.clients = [
                                  CustomerModelState(
                                    model: _foundClient!,
                                    arrivalStatus: false,
                                  ),
                                ];
                                model?.duration = _foundClient!.duration;
                                model?.split = _foundClient!.split ?? false;
                                if (_foundClient!.serviceUid != null &&
                                    _foundClient!.serviceName != null) {
                                  model?.service = Service(
                                    uid: _foundClient!.serviceUid!,
                                    name: _foundClient!.serviceName!,
                                  );
                                }
                              });
                            } else {
                              CustomSnackbar.getSnackbar(
                                title: S.of(context).error,
                                message: S.of(context).this_client_supplied,
                              );
                            }
                          },
                        )
                      :

                      /// Список постоянных клиентов
                      _search.isEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                              itemCount: _controller.appState.value
                                  .sortedCustomers[Client.permanent]!.length,
                              itemBuilder: (context, index) {
                                /// Преобразование номера телефона в нужный формат
                                List<String> phoneList = _controller
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

                                CustomerModel currentClient = _controller
                                    .appState
                                    .value
                                    .sortedCustomers[Client.permanent]![index];

                                /// Проверка, выбран ли уже клиент
                                bool check =
                                    _scheduleController.state.value.clients.any(
                                  (client) =>
                                      client.model.uid == currentClient.uid,
                                );

                                if (!check) {
                                  return CustomerContainer(
                                    customer: currentClient,
                                    clientType: ClientType.permanent,
                                    onTap: () async {
                                      /// Для персональной тренировки
                                      if (_scheduleController.state.value
                                              .appointmentRecordType !=
                                          AppointmentRecordType.group) {
                                        await getCustomerByPhone(
                                          search: phone,
                                        );
                                        Get.back();

                                        _scheduleController.clear(
                                          data: false,
                                          time: false,
                                        );

                                        _scheduleController.state
                                            .update((model) {
                                          model?.clients = [
                                            CustomerModelState(
                                              model: _foundClient!,
                                              arrivalStatus: false,
                                            ),
                                          ];
                                          model?.duration =
                                              _foundClient!.duration;
                                          model?.split =
                                              _foundClient!.split ?? false;
                                          if (_foundClient!.serviceUid !=
                                                  null &&
                                              _foundClient!.serviceName !=
                                                  null) {
                                            model?.service = Service(
                                              uid: _foundClient!.serviceUid!,
                                              name: _foundClient!.serviceName!,
                                            );
                                          }
                                        });

                                        /// Для групповой тренировоки
                                      } else {
                                        Get.back();
                                        List<CustomerModelState> clients =
                                            _scheduleController
                                                .state.value.clients;

                                        clients.add(
                                          CustomerModelState(
                                            model: currentClient,
                                            arrivalStatus: false,
                                          ),
                                        );

                                        _scheduleController.state
                                            .update((model) {
                                          model?.clients = clients;
                                        });
                                      }
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
                                    _textErrorResultSearch,
                                    style: theme.textTheme.headline3,
                                    textAlign: TextAlign.center,
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
      ),
    );
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
