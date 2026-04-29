import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:graphify/src/controller/interface.dart';
import 'package:graphify/src/view/console_message.dart';

typedef OnGraphEvent = void Function(Map<String, dynamic> event);

abstract class GraphifyView extends StatefulWidget {
  const GraphifyView({
    super.key,
    this.controller,
    this.initialOptions,
    this.onConsoleMessage,
    this.onCreated,
    this.onGraphEvent,
  });

  final GraphifyController? controller;

  final Map<String, dynamic>? initialOptions;

  final OnConsoleMessage? onConsoleMessage;

  final VoidCallback? onCreated;

  final OnGraphEvent? onGraphEvent;

  @override
  State<StatefulWidget> createState();

}

abstract class GraphifyViewState<T extends GraphifyView> extends State<T> {
  late Widget view;

  @nonVirtual
  @override
  void initState() {
    super.initState();
    initView();
    buildView();
  }

  @nonVirtual
  @override
  Widget build(BuildContext context) => view;

  Widget buildView();

  void initView();

}
