import 'package:flutter/material.dart';

class InitiativeCount extends StatelessWidget {
  final int count;
  const InitiativeCount({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$count active', style: Theme.of(context).textTheme.bodyMedium);
  }
}
