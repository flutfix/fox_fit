import 'package:flutter/material.dart';
import 'package:fox_fit/controllers/general_cotroller.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/trainer_choosing/widgets/search.dart';
import 'package:fox_fit/utils/error_handler.dart';
import 'package:fox_fit/widgets/custom_app_bar.dart';
import 'package:fox_fit/widgets/default_container.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SelectClientPage extends StatefulWidget {
  const SelectClientPage({Key? key, required this.callBack}) : super(key: key);

  final Function(String? client) callBack;

  @override
  _SelectClientPageState createState() => _SelectClientPageState();
}

class _SelectClientPageState extends State<SelectClientPage> {
  late GeneralController _controller;
  late bool _isLoading;
  late TextEditingController _phoneController;
  late FocusNode _phoneFocus;
  late String _phonePrefix;
  late MaskTextInputFormatter _maskFormatter;
  String? _textErrorResultSearch;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<GeneralController>();
    _isLoading = false;
    _phoneController = TextEditingController();
    _phoneFocus = FocusNode();
    _phonePrefix = '+7 ';
    _maskFormatter = MaskTextInputFormatter(
      mask: '+7 ###-###-##-##',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
    );

    _phoneFocus.addListener(_onFocusChange);
  }

  Future<void> getCustomerByPhone({required String search}) async {
    setState(() {
      _isLoading = true;
    });

    await ErrorHandler.singleRequest(
      context: context,
      request: () {
        return _controller.getCustomerByPhone(phone: search);
      },
      handler: (data) {
        setState(() {
          /// Если клиент не найден
          if (data == 404) {
            _textErrorResultSearch = S.of(context).client_not_found;
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Search(
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

                  /// Обработка полностью введён ли номер
                  if (search.length != 16) {
                    setState(() {
                      _textErrorResultSearch = S.of(context).enter_full_number;
                    });
                    _controller.appState.update((model) {
                      model?.currentCustomer = null;
                    });
                  } else {
                    getCustomerByPhone(search: search);
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            if (!_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: DefaultContainer(
                    padding: const EdgeInsets.fromLTRB(28, 17.45, 19, 22.55),
                    child: _controller.appState.value.currentCustomer != null
                        ? GestureDetector(
                            onTap: () {
                              widget.callBack(_controller
                                  .appState.value.currentCustomer?.fullName);
                              _controller.appState.update((model) {
                                model?.currentCustomer = null;
                              });
                              Get.back();
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _controller
                                      .appState.value.currentCustomer!.fullName,
                                  style: theme.textTheme.subtitle2!
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text(
                              _textErrorResultSearch ??
                                  S.of(context).enter_full_number,
                              style: theme.textTheme.headline3,
                            ),
                          ),
                  ),
                ),
              )
            else
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
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
