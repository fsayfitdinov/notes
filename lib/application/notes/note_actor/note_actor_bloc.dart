import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/notes/i_note_repository.dart';
import '../../../domain/notes/note.dart';
import '../../../domain/notes/note_failure.dart';

part 'note_actor_bloc.freezed.dart';
part 'note_actor_event.dart';
part 'note_actor_state.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const NoteActorState.initial());

  @override
  Stream<NoteActorState> mapEventToState(
    NoteActorEvent event,
  ) async* {
    yield* event.map(
      deleted: (e) async* {
        yield const NoteActorState.actionInProgress();
        final possibleFailure = await _noteRepository.delete(e.note);

        yield possibleFailure.fold(
          (f) => NoteActorState.deletFailure(f),
          (_) => const NoteActorState.deleteSuccess(),
        );
      },
    );
  }
}
