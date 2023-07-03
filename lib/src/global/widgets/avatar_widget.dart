import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:clickchat_app/src/global/helpers/string_extension.dart';

class Avatar extends StatefulWidget {
  final String letter;
  final String? imageUrl;
  final double size;
  final double? letterSize;
  final Color? letterColor;
  final Color? backgroundColor;
  final bool isLoading;

  const Avatar({
    Key? key,
    required this.letter,
    this.imageUrl,
    this.size = 25,
    this.letterSize,
    this.letterColor,
    this.backgroundColor,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return CircleAvatar(
        radius: widget.size,
        backgroundColor:
            widget.backgroundColor ?? Theme.of(context).colorScheme.onSurface,
        child: ClipOval(
          child: SizedBox(
            height: widget.size * 0.70,
            width: widget.size * 0.70,
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (widget.imageUrl == null) {
      return CircleAvatar(
        radius: widget.size,
        backgroundColor:
            widget.backgroundColor ?? Theme.of(context).colorScheme.onSurface,
        child: Text(
          widget.letter.firstLetter,
          style: TextStyle(
            color:
                widget.letterColor ?? Theme.of(context).colorScheme.onPrimary,
            fontSize: widget.letterSize ?? widget.size,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: widget.imageUrl!,
      placeholder: (context, url) => CircleAvatar(
        backgroundColor:
            widget.backgroundColor ?? Theme.of(context).colorScheme.onSurface,
        radius: widget.size,
      ),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: widget.size,
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: widget.size,
        child: const Icon(Icons.person_outline),
      ),
    );
  }
}
