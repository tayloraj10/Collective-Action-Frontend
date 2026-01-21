import 'package:flutter/material.dart';

class SummaryCount extends StatelessWidget {
  final int count;
  const SummaryCount({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$count active', style: Theme.of(context).textTheme.bodySmall);
  }
}
