import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_food_ordering/credentials.dart';
import 'package:flutter_food_ordering/model/user_model.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final storage = new FlutterSecureStorage();

  // Get detail of device
  Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return [deviceName, deviceVersion, identifier];
  }

  //Sign in with Google
  Future<UserDataProfile> loginWithGoogle(String token) async {
    var dio = Dio();

    String device = "";
    if (Platform.isAndroid) {
      device = "android";
    } else if (Platform.isIOS) {
      device = "ios";
    }

    String deviceId;
    await getDeviceDetails().then((deviceDetails) => {
          deviceId = deviceDetails[2],
        });

    String pushToken = await FirebaseMessaging.instance.getToken();

    try {
      final response = await dio.post(GOOGLE_LOGIN_URL, data: {
        "id_token": token,
        "device_type": device,
        "device_id": deviceId,
        "push_token": pushToken
      });

      // print('response: ${response.data.toString()}');

      this.storeToken(response.data["token"]);
      return UserDataProfile.fromMap(response.data["user"]);
    } catch (e) {
      print(e);
      if (e is DioError) {
        return e.response.data['message'];
      }
    }
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
