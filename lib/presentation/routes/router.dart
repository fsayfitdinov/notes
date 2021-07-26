import 'package:auto_route/auto_route.dart';
import 'package:notes/presentation/notes/notes_overview/notes_overview_page.dart';

import '../sign_in/sign_in_page.dart';
import '../splash/splash_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: SignInPage),
    AutoRoute(page: NotesOverviewPage),
  ],
  replaceInRouteName: 'Page,Route',
)
class $AppRouter {}
