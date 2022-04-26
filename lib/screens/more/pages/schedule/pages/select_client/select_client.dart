import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/config.dart';
import 'package:fox_fit/config/routes.dart';
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
import 'package:fox_fit/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:swipe/swipe.dart';

class SelectClientPage extends StatefulWidget {
  const SelectClientPage({
    Key? key,
    this.isFromSale = false,
  }) : super(key: key);

  final bool isFromSale;

  @override
  _SelectClientPageState createState() => _SelectClientPageState();
}

class _SelectClientPageState extends State<SelectClientPage> {
  late GeneralController _controller;
  late ScheduleController _scheduleController;
  late SalesController _salesController;
  late bool _isLoading;
  late TextEditingController _searchController;
  List<CustomerModel>? _foundClients;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<GeneralController>();
    _scheduleController = Get.find<ScheduleController>();
    if (widget.isFromSale) {
      _salesController = Get.find<SalesController>();
    }
    _searchController = TextEditingController();
    _isLoading = false;

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

  _goBack() {
    Get.back();
    _controller.appState.update((state) {
      state?.sortedPermanentCustomers = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Swipe(
      onSwipeRight: () {
        _goBack();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: CustomAppBar(
            title: S.of(context).choice_client,
            isBackArrow: true,
            isNotification: false,
            onBack: () {
              _goBack();
            },
            action: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.searchClient);
              },
              behavior: HitTestBehavior.translucent,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  SvgPicture.asset(
                    Images.add,
                    width: 24,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 36)
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Search(
                  controller: _searchController,
                  textInputType: TextInputType.name,
                  onSearch: (search) {
                    setState(() {
                      _controller.sortPermanentCustomers(search: search.trim());
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (!_isLoading)
                Expanded(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      /// Список постоянных клиентов
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        itemCount:
                            _controller.appState.value
                                        .sortedPermanentCustomers !=
                                    null
                                ? _controller.appState.value
                                    .sortedPermanentCustomers!.length
                                : _controller.appState.value
                                    .sortedCustomers[Client.permanent]!.length,
                        itemBuilder: (context, index) {
                          /// Текущий клиент
                          late CustomerModel currentClient;
                          if (_controller
                                  .appState.value.sortedPermanentCustomers !=
                              null) {
                            currentClient = _controller.appState.value
                                .sortedPermanentCustomers![index];
                          } else {
                            currentClient = _controller.appState.value
                                .sortedCustomers[Client.permanent]![index];
                          }

                          /// Преобразование номера телефона в нужный формат
                          List<String> phoneList =
                              currentClient.phone.split(' ');
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

                          /// Проверка, выбран ли уже клиент
                          bool check =
                              _checkExisttenceOfClient(currentClient.uid);

                          if (!check) {
                            return CustomerContainer(
                              customer: currentClient,
                              widgetType: CustomerContainerType.balance,
                              clientType: ClientType.permanent,
                              onTap: () async {
                                if (widget.isFromSale) {
                                  Get.back();
                                  _salesController.state.update((model) {
                                    model?.chosenCustomer = currentClient;
                                  });
                                } else {
                                  /// Для персональной тренировки
                                  if (_scheduleController
                                          .state.value.appointmentRecordType !=
                                      AppointmentRecordType.group) {
                                    await getCustomerByPhone(
                                      search: phone,
                                    );
                                    Get.back();
                                    _controller.appState.update((state) {
                                      state?.sortedPermanentCustomers = null;
                                    });
                                    _scheduleController.clear(
                                      data: false,
                                      time: false,
                                    );

                                    if (_foundClients!.length == 1) {
                                      _scheduleController.state.update((model) {
                                        model?.clients = [
                                          CustomerModelState(
                                            model: _foundClients![0],
                                            arrivalStatus: false,
                                            isCanceled: false,
                                          ),
                                        ];
                                        model?.duration =
                                            _foundClients![0].duration;
                                        model?.split =
                                            _foundClients![0].split ?? false;
                                        if (_foundClients![0].serviceUid !=
                                                null &&
                                            _foundClients![0].serviceName !=
                                                null) {
                                          model?.service = ServicesModel(
                                            uid: _foundClients![0].serviceUid!,
                                            name:
                                                _foundClients![0].serviceName!,
                                          );
                                        }
                                      });
                                    } else {
                                      /// Поиск выбранного среди списка клиентов из запроса
                                      CustomerModel? chosenClient;
                                      try {
                                        chosenClient = _foundClients!
                                            .firstWhere((element) =>
                                                element.uid ==
                                                currentClient.uid);
                                      } catch (e) {
                                        ///Если не удалось найти в списке такого клиента
                                        CustomSnackbar.getSnackbar(
                                          title: 'Хьюстон, у нас проблемы...😕',
                                          message:
                                              'Не удалось найти клиента в базе',
                                        );
                                      }

                                      if (chosenClient != null) {
                                        _scheduleController.state
                                            .update((model) {
                                          model?.clients = [
                                            CustomerModelState(
                                              model: chosenClient!,
                                              arrivalStatus: false,
                                              isCanceled: false,
                                            ),
                                          ];
                                          model?.duration =
                                              chosenClient!.duration;
                                          model?.split =
                                              chosenClient!.split ?? false;
                                          if (chosenClient!.serviceUid !=
                                                  null &&
                                              chosenClient.serviceName !=
                                                  null) {
                                            model?.service = ServicesModel(
                                              uid: chosenClient.serviceUid!,
                                              name: chosenClient.serviceName!,
                                            );
                                          }
                                        });
                                      }
                                    }

                                    /// Для групповой тренировоки
                                  } else {
                                    Get.back();
                                    List<CustomerModelState> clients =
                                        _scheduleController.state.value.clients;

                                    clients.add(
                                      CustomerModelState(
                                        model: currentClient,
                                        arrivalStatus: false,
                                        isCanceled: false,
                                      ),
                                    );

                                    _scheduleController.state.update((model) {
                                      model?.clients = clients;
                                    });
                                  }
                                }
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      )),
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
          if (data is List<CustomerModel>) {
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
}
