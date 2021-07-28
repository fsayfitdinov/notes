import 'package:auto_route/auto_route.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/auth/auth_bloc.dart';
import '../../../application/notes/note_actor/note_actor_bloc.dart';
import '../../../application/notes/note_watcher/note_watcher_bloc.dart';
import '../../../injection.dart';
import '../../routes/router.gr.dart';
import 'widgets/notes_overview_body.dart';
import 'widgets/uncompleted_switch.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<NoteWatcherBloc>()..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                unAuthenticated: (_) => context.router.replace(const SignInRoute()),
                orElse: () => null,
              );
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (context, state) {
              state.maybeMap(
                  deletFailure: (state) => context.showErrorBar(
                          content: Text(state.noteFailure.map(
                        unexpected: (_) => "Unexpected error",
                        insufficientPermissions: (_) => "Insufficient Permissions",
                        unableToUpdate: (_) => "Unable To Update",
                      ))),
                  orElse: () {});
            },
            child: Container(),
          )
        ],
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.read<AuthBloc>().add(const AuthEvent.signedOut()),
              icon: const Icon(Icons.logout_outlined),
            ),
            title: const Text('Notes'),
            actions: const [
              UncompletedSwitch(),
            ],
          ),
          body: const NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.router.push(NoteFormRoute(editedNote: null));
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
