import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, dynamic event) {
    debugPrint("event: ${event.toString()}");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    debugPrint("transition: ${transition.currentState} => ${transition.nextState}");
    super.onTransition(bloc, transition);
  }

  @override
  Future<void> onError(BlocBase cubit, Object err, StackTrace stack) async {
    debugPrint("error: ${err.toString()}");
    super.onError(cubit, err, stack);
  }
}
