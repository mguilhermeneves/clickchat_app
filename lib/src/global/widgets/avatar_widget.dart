import 'package:flutter/material.dart';

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
  bool isLoadingImage = false;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.size,
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).colorScheme.onSurface,
      child: widget.isLoading
          ? const ClipOval(child: CircularProgressIndicator())
          : widget.imageUrl == null
              ? _buildLetter()
              : _buildImage(),
    );
  }

  Widget _buildImage() {
    return ClipOval(
      child: Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, event) {
          if (event != null) return const CircularProgressIndicator();

          return child;
        },
      ),
    );
  }

  Widget _buildLetter() {
    return Text(
      widget.letter.firstLetter,
      style: TextStyle(
        color: widget.letterColor ?? Theme.of(context).colorScheme.onPrimary,
        fontSize: widget.letterSize ?? widget.size,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
