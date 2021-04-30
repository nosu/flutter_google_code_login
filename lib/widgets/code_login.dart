import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/login_model.dart';

class CodeLogin extends StatefulWidget {
  CodeLogin({Key key}) : super(key: key);

  @override
  _CodeLoginState createState() => _CodeLoginState();
}

class _CodeLoginState extends State<CodeLogin> {
  Future<void> _initiateCodeLoginResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<LoginModel>(context, listen: false).startCodeLoginResultPolling().then((result) {
      Navigator.of(context).pushReplacementNamed('/loginCompleted');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<void>(
        future: Provider.of<LoginModel>(context, listen: false).initiateCodeLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.error != null) {
            return Text('エラーがおきました: ${snapshot.error.toString()}');
          }

          return Consumer<LoginModel>(builder: (context, loginModel, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "PCかスマホで\nhttps://www.google.com/device\nを開き、下のコードを入力してログインしてください。\n",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.none)),
                  Text(loginModel.userCode,
                      style: TextStyle(
                          color: Colors.white, decoration: TextDecoration.none))
                ]);
          });
        },
      ),
    );
  }
}

