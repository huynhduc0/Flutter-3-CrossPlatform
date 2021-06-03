import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/order_model.dart';
import 'package:flutter_food_ordering/model/services/auth_serivce.dart';
import 'package:flutter_food_ordering/pages/start_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import '../credentials.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Future<Response> user;
  Future<OrderModel> orders;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthService auth = AuthService();

  Future<Response> fetchUserData() async {
    try {
      String token = await auth.getToken();
      Dio dio = new Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get('$BASE_URL/api/user/me');
      if (response.data['status'] == 1) {
        return response;
      } else {
        throw Exception(response.data['message']);
      }
    } on DioError catch (ex) {
      print('Dio error: ' + ex.message);
      throw Exception(ex.toString());
    }
  }

  @override
  void initState() {
    user = fetchUserData();
    // orders = fetchUserOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'PROFILE',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure you want to log out?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: () async => {
                            auth.unsetToken(),
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => StartPage()),
                                (Route<dynamic> route) => false),
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'LOGOUT',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder<Response>(
              future: user,
              builder:
                  (BuildContext context, AsyncSnapshot<Response> snapshot) {
                if (snapshot.hasData) {
                  return buildProfile(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text('Error getting data');
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            // Text('Order History', style: titleStyle),
            // buildUserOrderHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget buildProfile(Response response) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(response.data['user']['profile_image']),
                    fit: BoxFit.fill),
              ),
            ),
            SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: Icon(Icons.person, color: mainColor),
                title: Text('Fullname'),
                // subtitle: Text(response.data['user']['name']),
                subtitle: TextFormField(
                    controller: _fullNameController,
                    obscureText: false,
                    decoration: InputDecoration(
                        hintText: response.data['user']['name'],
                        border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fullname must be not null';
                      }
                      return null;
                    }),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.email, color: mainColor),
                title: Text('Email'),
                subtitle: Text(response.data['user']['email']),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.call, color: mainColor),
                title: Text('Phone Number'),
                subtitle: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: _phoneController,
                    obscureText: false,
                    decoration: InputDecoration(
                        hintText: response.data['user']['phone'] != null
                            ? response.data['user']['phone']
                            : "Please enter your phone number",
                        border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone Number must be not null';
                      }
                      return null;
                    }),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.location_city_rounded, color: mainColor),
                title: Text('Address'),
                subtitle: TextFormField(
                    controller: _addressController,
                    obscureText: false,
                    decoration: InputDecoration(
                        hintText: response.data['user']['address'] != null
                            ? response.data['user']['address']
                            : "Please enter your phone address",
                        border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address must be not null';
                      }
                      return null;
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var profileData = {
                        "profile_image": response.data['user']['profile_image'],
                        "name": _fullNameController.text,
                        "phone": _phoneController.text,
                        "address": _addressController.text
                      };
                      AuthService auth = AuthService();
                      String token = await auth.getToken();
                      Dio dio = new Dio();
                      dio.options.headers['Content-Type'] = 'application/json';
                      dio.options.headers["Authorization"] = "Bearer ${token}";

                      var profileResponse = await dio.post(
                          '$BASE_URL/api/user/profile',
                          data: profileData);

                      if (profileResponse.data['status'] == 1) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(profileResponse.data['message']);
                      } else {
                        throw Exception(response.data['message']);
                      }
                    }
                  },
                  color: mainColor,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "UPDATE",
                    style: TextStyle(
                        fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
