import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:provider/provider.dart';

import '../../../application/notes/note_form/note_form_bloc.dart';
import '../../../domain/notes/note.dart';
import '../../../injection.dart';
import '../../routes/router.gr.dart';
import 'widgets/add_todo_tile_widget.dart';
import 'widgets/body_field_widget.dart';
import 'widgets/color_field_widget.dart';
import 'widgets/todo_list_widget.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;
  const NoteFormPage({
    Key? key,
    required this.editedNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (p, c) => p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                (f) => context.showErrorBar(
                        content: Text(f.map(
                      unexpected: (_) => "Unexpected Error",
                      insufficientPermissions: (_) => "Insufficient Permission",
                      unableToUpdate: (_) => "Unable to update",
                    ))),
                (_) => context.router.removeUntil((route) => route.name == NotesOverviewRoute.name)
                // .pushAndPopUntil(const NotesOverviewRoute(), predicate: (route) => false)
                ),
          );
        },
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) => Stack(
          children: [
            const NoteFormPageScaffold(),
            SavingInProgressOverlay(isSaving: state.isSaving),
          ],
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (p, c) => p.isEditing != c.isEditing,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isEditing ? 'Edit a note' : 'Create a note'),
            actions: [
              IconButton(
                onPressed: () => context.read<NoteFormBloc>().add(const NoteFormEvent.saved()),
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          body: BlocBuilder<NoteFormBloc, NoteFormState>(
            buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
            builder: (context, state) => ChangeNotifierProvider(
              create: (_) => FormTodos(),
              child: Form(
                autovalidateMode: state.showErrorMessages ? AutovalidateMode.always : AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  child: Column(
                    children: const <Widget>[
                      BodyFieldWidget(),
                      ColorFieldWidget(),
                      TodoList(),
                      AddTodoTile(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;
  const SavingInProgressOverlay({Key? key, required this.isSaving}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        duration: const Duration(milliseconds: 200),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                color: Theme.of(context).accentColor,
              ),
              const SizedBox(height: 5),
              Text(
                'Saving',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
