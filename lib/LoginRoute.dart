import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Logo.dart';
import 'API.dart';
import 'RegisterRoute.dart';

class LoginRoute extends API {
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends APIState {
  String URL;
  String URLSuffix = "login";

  var messages = {
    "success": {"dialogHead": "", "dialogMessage": ""},
    "failure": {"dialogHead": ""}
  };

  @override
  Map<String, String> getBody() {
    return {"username" : username,"password" : password};
  }

  @override
  void onDialogPressed() {
    if (success == false) Navigator.pop(context);
  }

  @override
  onSuccess() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", true);
    sharedPreferences.setString("token", responseData["token"]);
    print("login success");
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
        key: formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white12,
            body: Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: new Logo(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 40.0),
                    child: new TextFormField(
                      style: new TextStyle(color: Colors.green),
                      decoration: new InputDecoration(
                          hintText: 'Usernames',
                          hintStyle: TextStyle(color: Colors.greenAccent),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.greenAccent))),
                      validator: (value) {
                        return value.isNotEmpty ? null : "Empty Username";
                      },
                      onSaved: (val) => username = val,
                    ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: new TextFormField(
                      obscureText: true,
                      style: new TextStyle(color: Colors.green),
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.greenAccent),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.greenAccent))),
                      validator: (value) {
                        return value.isNotEmpty ? null : "Empty Password";
                      },
                      onSaved: (val) => password = val,
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            super.submit();
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, top: 20.0),
                            child: new Container(
                                width: 60.0,
                                height: 60.0,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    color: Colors.greenAccent),
                                child: new Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, right: 10.0),
                            child: new Container(
                                width: 60.0,
                                height: 60.0,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: new Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.greenAccent),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterRoute()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: new Text(
                            "Create a new Account ",
                            style: TextStyle(
                                fontSize: 17.0, color: Colors.greenAccent,decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            )));
  }
}
