import 'package:auto_route/auto_route.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';

import '../../../../application/notes/note_actor/note_actor_bloc.dart';
import '../../../../domain/notes/note.dart';
import '../../../../domain/notes/todo_item.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../routes/router.gr.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: kSecondaryColor,
      child: InkWell(
        onTap: () {
          context.router.push(NoteFormRoute(editedNote: note));
        },
        onLongPress: () {
          final noteActorBloc = context.read<NoteActorBloc>();
          _showDeleteDialog(context, noteActorBloc);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    CustomPaint(
                      size: const Size(16, 16),
                      foregroundPainter: TrianglePainter(color: note.color.getOrCrash()),
                    ),
                    const SizedBox(width: 10),
                    CustomText(
                      note.body.getOrCrash(),
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: <Widget>[
                    ...note.todos.getOrCrash().map((todo) => TodoDisplay(todo: todo)).iter,
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, NoteActorBloc bloc) {
    context.showFlashDialog(
      backgroundColor: kSecondaryColor,
      transitionDuration: const Duration(milliseconds: 200),
      title: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Icon(Icons.warning_rounded, color: Colors.white70),
          SizedBox(width: 4),
          CustomText(
            'Delete',
            size: 17,
            weight: FontWeight.w500,
          ),
        ],
      ),
      content: Text(note.body.getOrCrash()),
      positiveActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            bloc.add(NoteActorEvent.deleted(note));
            controller.dismiss();
          },
          child: const CustomText('Delete', color: Colors.red),
        );
      },
      negativeActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () => controller.dismiss(),
          child: const Text('Cancel'),
        );
      },
    );
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todo;
  const TodoDisplay({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (todo.done)
          Icon(
            Icons.check_box,
            color: Theme.of(context).accentColor,
          )
        else
          const Icon(
            Icons.check_box_outline_blank,
            color: Colors.white70,
          ),
        CustomText(
          todo.name.getOrCrash(),
        )
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, size.height * 1 / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
