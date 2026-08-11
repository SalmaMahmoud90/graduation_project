import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:a_tareqaak/core/resources/app_fonts.dart';



class CustomRichText extends StatelessWidget {
  final List<CustomRichTextModel> texts;

  const CustomRichText({
    super.key,
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts
            .map(
              (e) => TextSpan(
                text: e.text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: e.color,
                  fontSize: e.fontSize ?? AppFontSize.s16,
                  fontWeight: e.fontWeight,
                ),
                recognizer: TapGestureRecognizer()..onTap = e.onTap,
              ),
            )
            .toList(),
      ),
    );
  }
}
class CustomRichTextModel {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function()? onTap;

  CustomRichTextModel({
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.onTap,
  });
}