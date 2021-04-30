import 'package:flutter/material.dart';
import 'package:flutter_google_code_login/json_types/google_api_types.dart';
import 'package:flutter_google_code_login/utils/google_api_client.dart';
import 'package:provider/provider.dart';
import '../models/login_model.dart';

class LoginCompleted extends StatefulWidget {
  LoginCompleted({Key key}) : super(key: key);

  @override
  _LoginCompletedState createState() => _LoginCompletedState();
}

class _LoginCompletedState extends State<LoginCompleted> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // After login, you can use AccessToken to access to Google APIs!
    var loginModel = Provider.of<LoginModel>(context);
    var codeLoginResult = loginModel.codeLoginResult;

    return Center(
        child: FutureBuilder<GoogleProfile>(
            future: GoogleApiClient.fetchUserName(
                accessToken: codeLoginResult.accessToken),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.error != null) {
                return Text('エラーがおきました: ${snapshot.error.toString()}');
              }

              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${snapshot.data.name} さんとしてログインしました。",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            decoration: TextDecoration.none)),
                  ]);
            }));
  }
}
