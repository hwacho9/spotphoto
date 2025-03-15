import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// TabController를 생성하는 Hook
TabController useTabController({
  int initialLength = 0,
  int initialIndex = 0,
  bool keepIndexOnLengthChange = false,
  List<Object?>? keys,
}) {
  return use(_TabControllerHook(
    initialLength: initialLength,
    initialIndex: initialIndex,
    keepIndexOnLengthChange: keepIndexOnLengthChange,
    keys: keys,
  ));
}

class _TabControllerHook extends Hook<TabController> {
  final int initialLength;
  final int initialIndex;
  final bool keepIndexOnLengthChange;

  const _TabControllerHook({
    required this.initialLength,
    this.initialIndex = 0,
    this.keepIndexOnLengthChange = false,
    List<Object?>? keys,
  }) : super(keys: keys);

  @override
  _TabControllerHookState createState() => _TabControllerHookState();
}

class _TabControllerHookState
    extends HookState<TabController, _TabControllerHook> {
  late TabController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = TabController(
      length: hook.initialLength,
      initialIndex: hook.initialIndex,
      vsync: useSingleTickerProvider(),
    );
  }

  @override
  TabController build(BuildContext context) {
    if (_controller.length != hook.initialLength &&
        !hook.keepIndexOnLengthChange) {
      _controller.dispose();
      _controller = TabController(
        length: hook.initialLength,
        initialIndex: hook.initialIndex,
        vsync: useSingleTickerProvider(),
      );
    }
    return _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
