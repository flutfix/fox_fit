import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';

class Search extends StatefulWidget {
  const Search({
    Key? key,
    required this.onSearch,
    this.hintText,
    this.textInputType,
    this.maskFormatter,
    this.phoneFocus,
  }) : super(key: key);

  final Function(String) onSearch;
  final String? hintText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? maskFormatter;
  final FocusNode? phoneFocus;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Input(
      textController: controller,
      hintText: widget.hintText ?? S.of(context).fast_search,
      hintStyle: theme.textTheme.overline,
      textStyle: theme.textTheme.overline,
      cursorColor: theme.colorScheme.secondary,
      textInputAction: TextInputAction.search,
      textInputType: widget.textInputType ?? TextInputType.text,
      textFormatters: widget.maskFormatter,
      focusNode: widget.phoneFocus,
      borderRadius: BorderRadius.circular(10),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      textCapitalization: TextCapitalization.sentences,
      onChanged: widget.onSearch,
      iconPng: Images.search,
      iconPngWidth: 15,
    );
  }
}
