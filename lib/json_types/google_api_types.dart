// import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

class GoogleProfile {
  final String id;
  final String email;
  final String name;
  final String givenName;
  final String familyName;
  final String picture;

  GoogleProfile(
      {@required this.id, @required this.email, @required this.name, @required this.givenName, @required this.familyName, @required this.picture});

  factory GoogleProfile.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return GoogleProfile(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        givenName: json["given_name"],
        familyName: json["family_name"],
        picture: json["picture"]);
  }
}
