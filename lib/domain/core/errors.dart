import 'package:notes/domain/core/value_failures.dart';

class NotAuthenticatedError extends Error {}

class UnexpectedValueError extends Error {
  final ValueFailure failure;

  UnexpectedValueError(this.failure);

  @override
  String toString() => Error.safeToString(
        'UnexpectedError(failure: $failure)',
      );
}
