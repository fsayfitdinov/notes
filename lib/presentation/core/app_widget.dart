import 'package:flutter/material.dart';

import '../sign_in/sign_in_page.dart';
import 'app_theme_data.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: AppThemeData.themeData(),
      home: const SignInPage(),
    );
  }
}
