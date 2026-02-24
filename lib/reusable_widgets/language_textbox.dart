import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constant_variables.dart';
import '../constants/language_global.dart';
import '../provider/global_provider.dart';
import 'global_widgets.dart';

class LangText extends ConsumerStatefulWidget {
  final String string;
  final TextStyle? style;
  final TextAlign? textAlign;
  final WidgetRef? ref;
  final TextOverflow? overflow;
  final bool isNumber;
  final bool? isNum;
  final int? maxLine;

  LangText(
    this.string, {
    Key? key,
    this.textAlign,
    this.style,
    this.ref,
    this.overflow,
    this.isNumber = false,
    this.isNum,
    this.maxLine,
  }) : super(key: key);

  @override
  ConsumerState<LangText> createState() => _LangTextState();
}

class _LangTextState extends ConsumerState<LangText> {
  TextStyle banglaStyle = TextStyle(fontFamily: banglaFont);

  TextStyle englishStyle = TextStyle(fontFamily: englishFont);
  bool exist = false;

  @override
  void initState() {
    super.initState();
    exist = language.containsKey(widget.string);
    // log(jsonEncode(language));
  }

  @override
  Widget build(BuildContext context) {
    String s = ref.watch(languageProvider);
    // bool exist = language.containsKey(widget.string);

    if (widget.style != null && widget.style!.fontFamily != null) {
      if (s == "en") {
        englishStyle = widget.style!;
      } else {
        print(widget.style!.merge(banglaStyle).fontFamily);
      }
    }
    return Text(
      widget.isNumber
          ? GlobalWidgets().numberEnglishToBangla(num: widget.string, lang: s, isNumber: widget.isNum ?? true)
          : exist
              ? (language[widget.string]?[s] ?? '')
              : widget.string,
      style: widget.isNumber
          ? s == 'en'
              ? widget.style == null
                  ? englishStyle
                  : widget.style!.merge(englishStyle)
              : widget.style == null
                  ? banglaStyle
                  : widget.style!.merge(banglaStyle)
          : exist
              ? s == 'en'
                  ? widget.style == null
                      ? englishStyle
                      : widget.style!.merge(englishStyle)
                  : widget.style == null
                      ? banglaStyle
                      : widget.style!.merge(banglaStyle)
              : widget.style == null
                  ? englishStyle
                  : widget.style!.merge(englishStyle),
      textAlign: widget.textAlign,
      overflow: widget.overflow,
      maxLines: widget.maxLine,
    );
  }

  String getString() {
    if (widget.ref != null) {
      String s = widget.ref!.read(languageProvider);
      return language.containsKey(widget.string) ? language[widget.string][s] : widget.string;
    } else {
      return widget.string;
    }
  }
}
