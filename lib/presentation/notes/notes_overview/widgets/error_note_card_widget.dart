import 'package:flutter/material.dart';

import '../../../../domain/notes/note.dart';
import '../../../core/widgets/custom_text.dart';

class ErrorNoteCard extends StatelessWidget {
  final Note note;

  const ErrorNoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Theme.of(context).errorColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const CustomText('Invalid note, contact support'),
            const SizedBox(height: 4),
            CustomText(
              "Details: ${note.failureOption.fold(() => '', (f) => f.toString())}",
              size: 12,
            )
          ],
        ),
      ),
    );
  }
}
