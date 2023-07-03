import 'package:flutter/material.dart';

class KeepPageAlive extends StatefulWidget {
  final Widget child;

  const KeepPageAlive({
    super.key,
    required this.child,
  });

  @override
  State<KeepPageAlive> createState() => _KeepPageAliveState();
}

class _KeepPageAliveState extends State<KeepPageAlive>
    with AutomaticKeepAliveClientMixin<KeepPageAlive> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
