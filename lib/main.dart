import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/model/cart_model.dart';
import 'package:flutter_food_ordering/model/services/auth_serivce.dart';
import 'package:flutter_food_ordering/pages/home_page.dart';
import 'package:flutter_food_ordering/pages/start_screen.dart';
import 'package:flutter_food_ordering/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_food_ordering/pages/bill_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  // for push notifications
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Create an Android Notification Channel.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  // Update the iOS foreground notification presentation options to allow heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

// for push notifications ====================
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      )
  );
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
// =================================================

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

class routePage extends StatefulWidget {
  @override
  routePageState createState() => routePageState();
}

class routePageState extends State<routePage> {
  final AuthService _auth = AuthService();
  bool isLoggedin = false;
  @override
  void initState() {
    _auth.unsetToken();

    // TODO: implement initState
    super.initState();
    print("Init state");
    _auth.getToken().then((value) {
      if (value == 'null') {
        print(isLoggedin);
        setState(() {
          isLoggedin = false;
        });
      } else if (value != null) {
        setState(() {
          isLoggedin = true;
        });
      } else {
        setState(() {
          isLoggedin = false;
        });
      }
    });

    // for push notifications
    String token;

    @override
    void initState() {
      super.initState();
      var initialzationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings =
      InitializationSettings(android: initialzationSettingsAndroid);

      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: (android.smallIcon != null) ? android?.smallIcon : '@mipmap/ic_launcher',
                  playSound: true,
                  // color: kPrimaryColor,
                ),
              )
          );
        }
      });

      // Open Notification Page when click to notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => NotificationScreen()),
        // );
      });
    }
    //============
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
        home: isLoggedin ? NavBar() : StartPage(),
        // home: StartPage(),
        // home: BillPage(),
      ),
    );
    return changeNotifierProvider;
  }
}

// @override
//   Widget build(BuildContext context) {
//     return isLoggedin==true ? homePage() : loginPage();
//   }
