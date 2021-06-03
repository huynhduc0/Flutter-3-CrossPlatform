import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_food_ordering/model/services/auth_serivce.dart';
import 'package:flutter_food_ordering/model/user_model.dart';
import 'package:flutter_food_ordering/pages/home_page.dart';
import 'package:flutter_food_ordering/widgets/bottom_nav_bar.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

import '../credentials.dart';
import '../main.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  AuthService auth = AuthService();
  GoogleSignInAccount _currentUser;
  String _accessToken;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId: GOOGLE_LOGIN_KEY,
    scopes: <String>[
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((result) => {
        result.authentication.then((googleKey) {
          _accessToken = googleKey.idToken;
          auth.loginWithGoogle(_accessToken).then((user) => {
            auth.storeUser(user).then((value) => {
              if(value == true) {
                Toast.show('Login with google success', context),
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                ),
              } else {
                Toast.show('Login with google failed', context),
              }
            })
          });
        })
      }).catchError((err) {
        print('error: ' + err.toString());
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              child: Lottie.asset('assets/start.json'),
            ),
            Container(
                padding: new EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome to FoodApp",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 25)),
                    Text("Welcome to FoodApp",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 18)),
                    SizedBox(height: 150),
                    SignInButton(
                      Buttons.Google,
                      text: "Sign up with Google",
                      onPressed: () => _handleSignIn(),

                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
