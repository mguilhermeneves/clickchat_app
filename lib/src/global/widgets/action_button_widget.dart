import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData iconData;
  final String labelText;
  final BorderRadius borderRadius;
  final void Function()? onTap;
  final Color? color;

  const ActionButton({
    super.key,
    required this.iconData,
    required this.labelText,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Row(
              children: [
                Icon(iconData, color: color),
                const SizedBox(width: 15),
                Text(
                  labelText,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
