import 'package:flutter/material.dart';
import 'RegisterRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeRoute.dart';
import 'LoginRoute.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = (prefs.getBool('isLogged') ?? false);

  prefs.setString("URL", "https://4468fd68.ngrok.io/mobile/");

  var home;
  if (isLogged) {
    home = HomeRoute();
    print("this is token");
    print(prefs.getString('token'));
  } else {
    home = LoginRoute();
  }
  runApp(
    MaterialApp(
      home: home, 
      routes: {
    '/login': (context) => LoginRoute(),
    '/register': (context) => RegisterRoute(),
    '/home': (context) => HomeRoute(),
  }));
}