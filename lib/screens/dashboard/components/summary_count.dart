import 'package:flutter/material.dart';

class SummaryCount extends StatelessWidget {
  final int count;
  final String title;
  const SummaryCount({super.key, required this.count, this.title = 'active'});

  @override
  Widget build(BuildContext context) {
    return Text('$count $title', style: Theme.of(context).textTheme.bodySmall);
  }
}
