import 'package:flutter/material.dart';

class CodeLoginInfo {
  final String userCode;
  final String deviceCode;

  CodeLoginInfo({@required this.userCode, @required this.deviceCode});

  factory CodeLoginInfo.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return CodeLoginInfo(
        userCode: json["user_code"], deviceCode: json["device_code"]);
  }
}

class CodeLoginResult {
  final String accessToken;
  final String refreshToken;
  final String idToken;
  final int expiresIn;

  CodeLoginResult({@required this.accessToken, @required this.refreshToken, @required this.idToken, @required this.expiresIn});

  factory CodeLoginResult.fromJson(Map<String, dynamic> json) {
    return CodeLoginResult(accessToken: json["access_token"], refreshToken: json["refresh_token"], idToken: json["id_token"], expiresIn: json["expires_in"]);
  }
}


