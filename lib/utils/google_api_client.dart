import 'dart:convert';

import 'package:flutter_google_code_login/json_types/google_api_types.dart';
import "package:http/http.dart" as http;

class GoogleApiClient {
  static const GOOGLE_PROFILE_URL = "https://www.googleapis.com/oauth2/v1/userinfo";

  static Future<GoogleProfile> fetchUserName({String accessToken}) async {
    var response = await http.get(
        Uri.parse("${GOOGLE_PROFILE_URL}?access_token=${accessToken}"));
    var googleProfile = GoogleProfile.fromJson(json.decode(response.body));
    return googleProfile;
  }
}
