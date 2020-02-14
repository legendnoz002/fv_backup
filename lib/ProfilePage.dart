import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences prefs;

  void logOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "");
    prefs.setBool("isLogged", false);
    print("logout success");
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: logOut,
          child: Text("Log Out"),
          ),
      )
    );
  }
}