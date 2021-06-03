import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_food_ordering/constants/values.dart';

import 'package:flutter_food_ordering/credentials.dart';
import 'package:flutter_food_ordering/model/user_model.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;

class AuthService {
  final storage = new FlutterSecureStorage();

  //Sign in with Google
  Future<UserDataProfile> loginWithGoogle(String token) async {
    var dio = Dio();

    String device = "";
    if (Platform.isAndroid) {
      device = "android";
    } else if (Platform.isIOS) {
      device = "ios";
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Running on ${iosInfo.utsname.machine}');
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(token);
    debugPrint(prettyprint);
    print("^^^^^^^^^^^^");
    print(iosInfo.identifierForVendor);
    print(GOOGLE_LOGIN_URL);

    final response = await dio.post(GOOGLE_LOGIN_URL, data: {
      "id_token": token,
      "device_type": "ios",
      "device_id": iosInfo.identifierForVendor,
      "push_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3MTllYjk1N2Y2OTU2YjU4MThjMTk2OGZmMTZkZmY3NzRlNzA4ZGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiMTA4NjA5MjUxODIwOS1mdG52ZTZ2OXUydjVmcHVuZGMxdDlvYzU2cjBndGhobC5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjEwODYwOTI1MTgyMDktZnRudmU2djl1MnY1ZnB1bmRjMXQ5b2M1NnIwZ3RoaGwuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDY1ODQ3NTA4Njc4OTI3MjA1MzEiLCJlbWFpbCI6Im5xY3VvbmcuZGV2QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoib0xwRGZwemg2SG9xcGl1ZG1DUWp2dyIsIm5hbWUiOiJDxrDhu51uZyBOZ3V54buFbiBRdeG7kWMiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2prRU1fbDBheTE0dVR3Z2VGc08tMmJ4R0JaSy1rOFpOWVFHYndiPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkPGsOG7nW5nIiwiZmFtaWx5X25hbWUiOiJOZ3V54buFbiBRdeG7kWMiLCJsb2NhbGUiOiJ2aSIsImlhdCI6MTYyMjcwOTIyNiwiZXhwIjoxNjIyNzEyODI2LCJqdGkiOiIyODA4NDVhM2U3YjE5MTk1MjUzODhhZDI1Zjc1ZmI0N2JhNTFiNzViIn0.dRvdWKGhtvDpHzYJyFpamVE716ovaxAZWnu2_DT3AusFmvb7pm-tIskEUQUE_am4Rj2DhnB3JyHzp5Onnb5zjJMfbarYzkH_k2tUI5Nlj1-7fjv9aepMTdByFMo1P__BecL_XokhA2lb5lB4DPK6hWJ7nOL3uFxjvfZlocUTCnfgBbdEV6MsPj1F3Q6griymroTQQUzR13YG5Jn_wIxwLoULW2Y38DrohGglNYuyeZKNSV8OybcczL2XdSS1WPUKETbm0wXH7ZK9jEzamRVj2zz_t07q8thOZfaZQEdXFcAD34d0L1SrvPfzCjpz0zXavGbk3suOj8H1MnOXl6kGkQ"
    });

    print(response.data.toString());

    this.storeToken(response.data["token"]);
    return UserDataProfile.fromMap(response.data["user"]);
  }

  //Get UID
  Future<String> getCurrentUID() async {
    // return (_firebaseAuth.currentUser).uid;
    UserDataProfile user = await this.getUser().then((value) => value);
    return user.email;
  }

  //Get Current user
  Future<UserDataProfile> getCurrentUser() async {
    UserDataProfile user = await this.getUser().then((value) => value);
    return user;
  }

  //Get Email
  Future<String> getCurrentEmail() async {
    UserDataProfile user = await this.getUser().then((value) => value);
    return user.email;
  }

  Future<bool> storeToken(String token) async {
    // if (kIsWeb) {
    //   Storage _localStorage = window.localStorage;
    //   _localStorage['jwt'] = token;
    //   return true;
    // }
    await storage.write(key: 'jwt', value: token);
    return true;
  }

  Future<String> getToken() async {
    // if (kIsWeb) {
    //   Storage _localStorage = window.localStorage;
    //   return _localStorage['jwt'];
    // }
    return await storage.read(key: 'jwt');
  }

  Future<UserDataProfile> getUser() async {
    // if (kIsWeb) {
    //   Storage _localStorage = window.localStorage;
    //   String value = _localStorage['user'];

    //   return UserDataProfile.fromMap(jsonDecode(value));
    // }
    String value = await storage.read(key: 'user');
    return UserDataProfile.fromMap(jsonDecode(value));
  }

  Future<bool> storeUser(UserDataProfile user) async {
    // if (kIsWeb) {
    //   Storage _localStorage = window.localStorage;
    //   _localStorage['user'] = jsonEncode(user.toMap());
    //   return true;
    // }
    await storage.write(key: 'user', value: user.toMap().toString());
    return true;
  }

  Future<bool> unsetToken() async {
    // if (kIsWeb) {
    //   Storage _localStorage = window.localStorage;
    //   _localStorage.remove('jwt');
    //   await storage.delete(key: 'user');
    //   return true;
    // }
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'user');

    return true;
  }
}
