import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/model/cart_model.dart';
import 'package:flutter_food_ordering/model/services/auth_serivce.dart';
import 'package:flutter_food_ordering/pages/home_page.dart';
import 'package:flutter_food_ordering/pages/start_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     AuthService auth = AuthService();
//     var changeNotifierProvider = ChangeNotifierProvider(
//       create: (context) => MyCart(),
//       child: MaterialApp(
//         title: 'Flutter Food Ordering',
//         showSemanticsDebugger: false,
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: MyHomePage(),
//         // home: StartPage(),
//       ),
//     );
//     return changeNotifierProvider;
//   }
// }

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: routePage(),
    );
  }
}

class routePage extends StatefulWidget{
  @override
  routePageState createState() => routePageState();
}

class routePageState extends State<routePage>{
  final AuthService _auth = AuthService();
  bool isLoggedin = false;
  @override
  void initState() {
    _auth.unsetToken();
    // TODO: implement initState
    super.initState();
    print("Init state");
    _auth.getToken().then((value){
      if(value == 'null'){
        print(isLoggedin);
        setState(() {
          isLoggedin = false;
        });
      }else if (value !=null){
        setState(() {
          isLoggedin = true;
        });
      }else{
        setState(() {
          isLoggedin = false;
        });
      }
    });
  }
  @override
  // Widget build(BuildContext context) {
  //   return isLoggedin==true ? MyHomePage() : StartPage();
  // }
  Widget build(BuildContext context) {
    var changeNotifierProvider = ChangeNotifierProvider(
      create: (context) => MyCart(),
      child: MaterialApp(
        title: 'Flutter Food Ordering',
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isLoggedin ==true ? MyHomePage() : StartPage(),
        // home: StartPage(),
      ),
    );
    return changeNotifierProvider;
  }
}

// @override
//   Widget build(BuildContext context) {
//     return isLoggedin==true ? homePage() : loginPage();
//   }