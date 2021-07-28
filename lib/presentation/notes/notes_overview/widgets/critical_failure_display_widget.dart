import 'package:flutter/material.dart';

import '../../../../domain/notes/note_failure.dart';
import '../../../core/widgets/custom_text.dart';

class CriticalDisplayFailure extends StatelessWidget {
  final NoteFailure failure;
  const CriticalDisplayFailure({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CustomText(
            "😱",
            size: 100,
          ),
          CustomText(
            failure.maybeMap(
              insufficientPermissions: (_) => 'Insufficient permissions',
              orElse: () => 'Unexpected Error',
            ),
          ),
        ],
      ),
    );
  }
}
