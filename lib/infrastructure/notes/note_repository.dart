import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/notes/i_note_repository.dart';
import '../../domain/notes/note.dart';
import '../../domain/notes/note_failure.dart';
import '../core/firebase_helpers.dart';
import 'note_dtos.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;
  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection.orderBy('serverTimeStamp', descending: true).snapshots().map(
          (snapshot) => right<NoteFailure, KtList<Note>>(
            snapshot.docs.map((doc) => NoteDto.fromFirestore(doc).toDomain()).toImmutableList(),
          ),
        );
    //     .onErrorReturnWith(
    //   (error, stackTrace) {
    //     print("Error: $error");
    //     if (error is FirebaseException && error.code.contains('permission-denied')) {
    //       return left(const NoteFailure.insufficientPermissions());
    //     } else {
    //       return left(const NoteFailure.unexpected());
    //     }
    //   },
    // ).doOnResume(() {

    // });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => NoteDto.fromFirestore(doc).toDomain()),
        )
        .map((notes) => right<NoteFailure, KtList<Note>>(
              notes.where((note) => note.todos.getOrCrash().any((todoItem) => !todoItem.done)).toImmutableList(),
            ))
        .onErrorReturnWith(
      (error, stackTrace) {
        if (error is FirebaseException && error.code.contains('permission-denied')) {
          return left(const NoteFailure.insufficientPermissions());
        } else {
          return left(const NoteFailure.unexpected());
        }
      },
    );
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      await userDoc.noteCollection.doc(noteDto.id).set(noteDto.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code.contains('permission')) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      await userDoc.noteCollection.doc(noteDto.id).update(noteDto.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code.contains('permission')) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (e.code.contains('not-found')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      await userDoc.noteCollection.doc(noteDto.id).delete();

      return right(unit);
    } on FirebaseException catch (e) {
      if (e.code.contains('permission')) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (e.code.contains('not-found')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
