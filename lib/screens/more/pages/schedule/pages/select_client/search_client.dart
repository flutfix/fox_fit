import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/sales_controller.dart';
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

class SearchClient extends StatefulWidget {
  const SearchClient({
    Key? key,
    this.isFromSale = false,
  }) : super(key: key);
  final bool isFromSale;

  @override
  State<SearchClient> createState() => _SearchClientState();
}

class _SearchClientState extends State<SearchClient> {
  late GeneralController _controller;
  late ScheduleController _scheduleController;
  late SalesController _salesController;

  late bool _isLoading;

  late TextEditingController _phoneController;
  late String _search;
  late FocusNode _phoneFocus;
  late String _phonePrefix;
  late MaskTextInputFormatter _maskFormatter;
  late String _textErrorResultSearch;
  List<CustomerModel>? _foundClients;

  @override
  void initState() {
    _controller = Get.find<GeneralController>();
    _scheduleController = Get.find<ScheduleController>();
    if (widget.isFromSale) {
      _salesController = Get.find<SalesController>();
    }
    _isLoading = false;

    _phoneController = TextEditingController();
    _search = '';

    _phoneFocus = FocusNode();
    _phonePrefix = '+7 ';

    _maskFormatter = MaskTextInputFormatter(
      mask: '+7 ###-###-##-##',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
    );
    _textErrorResultSearch = '';
    _phoneFocus.addListener(_onFocusChange);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_textErrorResultSearch == '') {
      setState(() {
        _textErrorResultSearch = S.of(context).start_typing;
      });
    }
    ThemeData theme = Theme.of(context);
    return Swipe(
      onSwipeRight: () => Get.back(),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: CustomAppBar(
            title: S.of(context).search_client,
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
                        selection: TextSelection.collapsed(
                            offset: _phonePrefix.length),
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
                          _foundClients = null;
                        });
                      } else {
                        getCustomerByPhone(search: search);
                      }
                    } else {
                      setState(() {
                        _textErrorResultSearch = S.of(context).start_typing;
                        _foundClients = null;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (!_isLoading)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _foundClients != null

                        /// Для найденного клиента
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                            itemCount: _foundClients!.length,
                            itemBuilder: (context, index) {
                              CustomerModel foundClient = _foundClients![index];
                              return CustomerContainer(
                                customer: foundClient,
                                clientType: ClientType.assigned,
                                onTap: () {
                                  /// Проверка, выбран ли уже клиент
                                  bool check =
                                      _checkExisttenceOfClient(foundClient.uid);

                                  if (!check) {
                                    Get.back();
                                    Get.back();

                                    if (widget.isFromSale) {
                                      _salesController.state.update((model) {
                                        model?.chosenCustomer = foundClient;
                                      });
                                    } else {
                                      /// Добавление из поиска для персональной
                                      if (_scheduleController.state.value
                                              .appointmentRecordType !=
                                          AppointmentRecordType.group) {
                                        _scheduleController.clear(
                                          data: false,
                                          time: false,
                                        );
                                        _scheduleController.state
                                            .update((model) {
                                          model?.clients = [
                                            CustomerModelState(
                                              model: foundClient,
                                              arrivalStatus: false,
                                              isCanceled: false,
                                            ),
                                          ];
                                          model?.duration =
                                              foundClient.duration;
                                          model?.split =
                                              foundClient.split ?? false;
                                          if (foundClient.serviceUid != null &&
                                              foundClient.serviceName != null) {
                                            model?.service = ServicesModel(
                                              uid: foundClient.serviceUid!,
                                              name: foundClient.serviceName!,
                                            );
                                          }
                                        });

                                        /// Для групповой
                                      } else {
                                        List<CustomerModelState> clients =
                                            _scheduleController
                                                .state.value.clients;

                                        clients.add(
                                          CustomerModelState(
                                            model: foundClient,
                                            arrivalStatus: false,
                                            isCanceled: false,
                                          ),
                                        );

                                        _scheduleController.state
                                            .update((model) {
                                          model?.clients = clients;
                                        });
                                      }
                                    }
                                  } else {
                                    CustomSnackbar.getSnackbar(
                                      title: S.of(context).error,
                                      message:
                                          S.of(context).this_client_supplied,
                                    );
                                  }
                                },
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
            ],
          ),
        ),
      ),
    );
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
          if (data != 200 && data is! List<CustomerModel>) {
            _textErrorResultSearch = S.of(context).client_not_found;
          } else if (data is List<CustomerModel>) {
            _foundClients = data;
          }
        });
        return false;
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  /// Проверка есть ли клиент в списке
  bool _checkExisttenceOfClient(String customer) {
    return _scheduleController.state.value.clients.any(
      (client) => client.model.uid == customer,
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
