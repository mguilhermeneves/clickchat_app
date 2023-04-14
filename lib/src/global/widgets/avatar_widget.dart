import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/helpers/string_extension.dart';

class Avatar extends StatelessWidget {
  final String letter;
  final String? imageUrl;
  final double size;
  final double? letterSize;
  final Color? letterColor;
  final Color? backgroundColor;

  const Avatar({
    Key? key,
    required this.letter,
    this.imageUrl,
    this.size = 25,
    this.letterSize,
    this.letterColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (imageUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),
        radius: size,
        backgroundColor: backgroundColor ?? colorScheme.onSurface,
      );
    }

    return CircleAvatar(
      radius: size,
      backgroundColor: backgroundColor ?? colorScheme.onSurface,
      child: Text(
        letter.firstLetter,
        style: TextStyle(
          color: letterColor ?? colorScheme.onPrimary,
          fontSize: letterSize ?? size,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
