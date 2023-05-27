import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  RestartWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  static void restartApp(BuildContext ctx) {
    ctx.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
