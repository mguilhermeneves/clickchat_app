import 'package:flutter/material.dart';

import '../app_theme.dart';

const TextStyle _linkStyle = TextStyle(
  color: AppTheme.primaryColor,
  fontWeight: FontWeight.w500,
  fontSize: 14,
  fontFamily: AppTheme.fontFamily,
);

extension TextExtension on Text {
  Text link() => _buildText(_linkStyle);

  Text _buildText(TextStyle customStyle) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textAlign: textAlign,
      textDirection: textDirection,
      textWidthBasis: textWidthBasis,
      key: key,
      style: (customStyle).merge(style ?? customStyle),
    );
  }
}

extension TextSpanExtension on TextSpan {
  TextSpan link() => _buildTextSpan(_linkStyle);

  TextSpan _buildTextSpan(TextStyle customStyle) {
    return TextSpan(
      children: children,
      onEnter: onEnter,
      onExit: onExit,
      text: text,
      recognizer: recognizer,
      style: (customStyle).merge(style ?? customStyle),
    );
  }
}
