import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import '../json_types/code_login_types.dart';

enum LoginModelState {
  loginNotInitiated,
  waitingForUserToLogin,
  loginCompleted,
}

class LoginModel extends ChangeNotifier {
  static const String GOOGLE_CODE_LOGIN_URL = "https://oauth2.googleapis.com/device/code";
  static const String GOOGLE_TOKEN_ISSUE_URL = "https://oauth2.googleapis.com/token";
  static const String SCOPE = "email%20profile%20https://www.googleapis.com/auth/drive.file";
  // final String scope = "email%20profile%20https://www.googleapis.com/auth/drive.file%20https://www.googleapis.com/auth/drive.appdata";
  static const Map<String, String> API_REQUEST_COMMON_HEADER = {
    "Content-Type": "application/x-www-form-urlencoded"
  };

  String clientId;
  String clientSecret;

  LoginModelState currentState = LoginModelState.loginNotInitiated;
  Map<String, dynamic> rawJson;
  CodeLoginResult codeLoginResult;
  String userCode;
  String deviceCode;

  LoginModel() {
    String clientId = DotEnv.env["CLIENT_ID"];
    if(clientId == null || clientId.isEmpty) {
      throw new ArgumentError("CLIENT_ID is not set in .env file.");
    }
    this.clientId = clientId;

    String clientSecret = DotEnv.env["CLIENT_SECRET"];
    if(clientSecret == null || clientSecret.isEmpty) {
      throw new ArgumentError("CLIENT_SECRET is not set in .env file.");
    }
    this.clientSecret = clientSecret;
  }

  Future<void> initiateCodeLogin() async {
    var body = "client_id=${clientId}&scope=${SCOPE}";
    var response = await http.post(Uri.parse(GOOGLE_CODE_LOGIN_URL),
        headers: API_REQUEST_COMMON_HEADER, body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to load post: ${response.body.toString()}');
    }
    var deviceLoginCodes = CodeLoginInfo.fromJson(json.decode(response.body));
    this.userCode = deviceLoginCodes.userCode;
    this.deviceCode = deviceLoginCodes.deviceCode;
    this.currentState = LoginModelState.waitingForUserToLogin;
    print("Device Code successfully fetched.");
  }

  Future<void> startCodeLoginResultPolling() async {
    if(this.currentState == LoginModelState.loginNotInitiated) {
      print("Waiting for login to be initiated.");
      await new Future.delayed(new Duration(seconds: 10));
      return await startCodeLoginResultPolling();
    }

    if(this.currentState != LoginModelState.loginCompleted) {
      await _fetchCodeLoginResult();
    }

    // If accessToken has been expired, refresh it
    // if(DateTime.now().isAfter(accessTokenExpireDateTime)) {
    //   await refreshAccessToken();
    //   return await fetchAccessToken();
    // }
  }

  Future<void> _fetchCodeLoginResult() async {
    print("fetchDeviceLoginResult()");
    if(this.currentState == LoginModelState.loginNotInitiated) {
      await new Future.delayed(new Duration(seconds: 5));
    }

    var body = "client_id=${clientId}&client_secret=${clientSecret}&code=${deviceCode}&grant_type=http://oauth.net/grant_type/device/1.0";
    var response = await http.post(Uri.parse(GOOGLE_TOKEN_ISSUE_URL), headers: API_REQUEST_COMMON_HEADER, body: body);

    print("fetchDeviceLoginResult() response: ${response.body.toString()}");

    if (response.statusCode == 428) {
      print("Still waiting for the user to login. Wait 5 seconds and retry.");
      // Still waiting for the user to login
      // Wait 5 seconds and retry
      await new Future.delayed(new Duration(seconds: 5));
      return await _fetchCodeLoginResult();
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load post');
    }

    var codeLoginResult = CodeLoginResult.fromJson(json.decode(response.body));
    this.codeLoginResult = codeLoginResult;

    return;
  }
}

