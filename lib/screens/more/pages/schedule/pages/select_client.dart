import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/controllers/schedule_controller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/models/appointment.dart';
import 'package:fox_fit/models/customer.dart';
import 'package:fox_fit/screens/customers/widgets/customer_coontainer.dart';
import 'package:fox_fit/screens/trainer_choosing/widgets/search.dart';
import 'package:fox_fit/utils/enums.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SelectClientPage extends StatefulWidget {
  const SelectClientPage({Key? key}) : super(key: key);

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
  }

  Future<void> getCustomerByPhone({required String search}) async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.singleRequest(
      context: context,
      request: () {
        return _scheduleController.getCustomerByPhone(
          licenseKey: _generalController.appState.value.auth!.data!.licenseKey,
          phone: search,
        );
      },
      handler: (data) {
        setState(() {
          /// Если клиент не найден
          if (data == 404) {
            _textErrorResultSearch = S.of(context).client_not_found;
          } else if (data is CustomerModel) {
            _client = data;
          } else {
            _textErrorResultSearch = null;
          }
        });
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
                log('message');
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
                  searchSplit = [searchSplit[0], ...searchSplit[1].split('-')];
                  search = '';
                  for (var i = 0; i < searchSplit.length; i++) {
                    if (i == 1) {
                      search += ' (${searchSplit[i]})';
                    } else if (i == 2) {
                      search += ' ${searchSplit[i]}';
                    } else {
                      search += searchSplit[i];
                    }
                  }

                  /// Обработка полностью ли введён номер
                  if (search.length != 16) {
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
                    ? CustomerContainer(
                        customer: _client!,
                        clientType: ClientType.assigned,
                        onTap: () {
                          if (_client! !=
                              _scheduleController.scheduleState.value.client) {
                            _scheduleController.scheduleState.update((model) {
                              model?.client = null;
                              model?.duration = null;
                              model?.type = TrainingType.personal;
                              model?.service = null;
                              model?.date = null;
                              model?.time = null;
                            });
                          }

                          _scheduleController.scheduleState.update((model) {
                            model?.client = _client!;
                          });

                          // _checkExists(_client!);

                          Get.back();
                        },
                      )
                    : _search.isEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _generalController.appState.value
                                .sortedCustomers[Client.permanent]!.length,
                            itemBuilder: (context, index) {
                              CustomerModel currentCustomer = _generalController
                                  .appState
                                  .value
                                  .sortedCustomers[Client.permanent]![index];
                              return CustomerContainer(
                                customer: currentCustomer,
                                clientType: ClientType.permanent,
                                onTap: () {
                                  if (currentCustomer !=
                                      _scheduleController
                                          .scheduleState.value.client) {
                                    _scheduleController.scheduleState
                                        .update((model) {
                                      model?.client = null;
                                      model?.duration = null;
                                      model?.type = TrainingType.personal;
                                      model?.service = null;
                                      model?.date = null;
                                      model?.time = null;
                                    });
                                  }

                                  _scheduleController.scheduleState
                                      .update((model) {
                                    model?.client = currentCustomer;
                                  });

                                  // _checkExists(currentCustomer);

                                  Get.back();
                                },
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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

  /// Проверяет есть ли выбранный клиент в списке
  /// всех занятий для автозаполнения форм
  // void _checkExists(CustomerModel currentCustomer) {
  // log('${_scheduleController.scheduleState.value.appointments.length}');
  // if (_scheduleController.scheduleState.value.appointments.every(
  //   (element) {
  //     log('1 ${element.customers![0].uid == currentCustomer.uid}');
  //     return element.customers![0].uid == currentCustomer.uid;
  //   },
  // )) {
  // AppointmentModel appointment =
  //     _scheduleController.scheduleState.value.appointments.firstWhere(
  //   (element) {
  //     log('2 ${element.customers![0].uid == currentCustomer.uid}');
  //     return element.customers![0].uid == currentCustomer.uid;
  //   },
  // );
  // _scheduleController.scheduleState.update((model) {
  //   model?.duration = int.parse(
  //     appointment.service!.duration,
  //   );
  //   model?.type = Enums.getTrainingType(
  //     trainingType: appointment.appointmentType,
  //   );
  //   model?.service = appointment.service;
  // });
  // }
  // }

  /// Подставление [+7] в начало строки, если поле в фокусе
  void _onFocusChange() {
    debugPrint("Focus: ${_phoneFocus.hasFocus.toString()}");
    if (_phoneFocus.hasFocus) {
      if (_phoneController.text.isEmpty) {
        _phoneController.text = _phonePrefix;
        log('${_phoneController.text}');
      }
    } else {
      if (_phoneController.text == _phonePrefix) {
        _phoneController.clear();
      }
    }
  }
}
