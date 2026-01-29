import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiative_action_submission.dart';
import 'package:flutter/material.dart';

class InitiativeSubmissionButton extends StatelessWidget {
  final InitiativeSchema initiative;
  const InitiativeSubmissionButton({super.key, required this.initiative});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      padding: EdgeInsets.zero,
      // constraints: BoxConstraints(),
      tooltip: 'Add Submission',
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) =>
              Dialog(child: InitiativeActionSubmission(initiative: initiative)),
        );
      },
    );
  }
}
