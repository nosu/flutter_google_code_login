import 'package:flutter/material.dart';
import 'package:flutter_google_code_login/widgets/login_completed.dart';
import 'package:provider/provider.dart';

import '../models/login_model.dart';
import 'code_login.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (context) => LoginModel(),
      child: MaterialApp(
          initialRoute: '/codeLogin',
          routes: {
            '/codeLogin': (context) => CodeLogin(),
            '/loginCompleted': (context) => LoginCompleted(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          )),
    );
  }
}
