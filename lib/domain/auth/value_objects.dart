import 'package:dartz/dartz.dart';

import '../core/value_failures.dart';
import '../core/value_objects.dart';
import '../core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) =>
      EmailAddress._(validateEmailAddress(input));

  EmailAddress._(this.value);
}

class Password extends ValueObject<String> {
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) => Password._(validatePassword(input));

  Password._(this.value);
}
