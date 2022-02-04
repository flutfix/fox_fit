import 'package:flutter/material.dart';
import 'package:fox_fit/config/images.dart';
import 'package:fox_fit/generated/l10n.dart';
import 'package:fox_fit/screens/auth/widgets/input.dart';

class Search extends StatefulWidget {
  const Search({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  final Function(String) onSearch;

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
      hintText: S.of(context).fast_search,
      hintStyle: theme.textTheme.overline,
      textStyle: theme.textTheme.bodyText2,
      cursorColor: theme.colorScheme.secondary,
      borderRadius: BorderRadius.circular(10),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      textCapitalization: TextCapitalization.sentences,
      onChanged: widget.onSearch,
      iconPng: Images.search,
      iconPngWidth: 15,
    );
  }
}
