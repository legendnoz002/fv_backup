import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RegisterRoute extends StatefulWidget {
  _RegisterRouteState createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  SharedPreferences sharedPreferences;
  String username;
  String password;
  String firstname;
  String lastname;
  String URL;
  String URLprefix = "register";
  dynamic responseData;
  String message;

  Map<String, String> getBody() {
    return {
      "username": username,
      "password": password,
      "firstname": firstname,
      "lastname": lastname
    };
  }

  Future<http.Response> getResponse(
      String url, Map<String, String> body) async {
    print("##################################");
    print("this is body");
    print(body);
    print(URL);
    print("##################################");
    var response = await http.post(url,
        body: convert.jsonEncode(body),
        headers: {"Content-Type": "application/json"});
    return response;
  }

  void onSubmit() async {
    final form = _form.currentState;
    if (form.validate()) {
      form.save();
      await loadURL();
      print(URL);
      process();
    }
  }

  void loadURL() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      URL = sharedPreferences.getString("URL") + URLprefix;
    });
  }

  void process() async {
    var body = getBody();
    var response;
    var connected = true;
    try {
      response = await getResponse(URL, body);
    } catch (e) {
      connected = false;
      print(e);
    }
    if (connected) {
      if (response.statusCode == 200) {
        message = "Register success";
        showAlertDialog();
        onSuccess();
      }
      if (response.statusCode == 404) {
        message = "User already exist";
        showAlertDialog();
      }
      if (response.statusCode == 201) {
        message = "Something is wrong";
        showAlertDialog();
      }
    } else {
      message = "Connection error";
      showAlertDialog();
    }
  }

  void onSuccess() async {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      child: new AlertDialog(
        content: Text(message),
        actions: [
          new FlatButton(child: const Text("Ok"), onPressed: onDialogPressed),
        ],
      ),
    );
  }

  void onDialogPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _form,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.greenAccent),
            title: Text(
              "This is your information :)",
              style: TextStyle(color: Colors.greenAccent, fontSize: 20.0),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.white12,
          body: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: new TextFormField(
                          validator: (value) {
                            if (value.isEmpty) return "Empty Username";
                          },
                          onSaved: (val) => username = val,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_pin),
                            hintText: "Username",
                            hintStyle: TextStyle(
                                color: Colors.greenAccent, fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: new TextFormField(
                                validator: (value) {
                                  return value.isNotEmpty
                                      ? null
                                      : "Empty First Name";
                                },
                                onSaved: (val) => firstname = val,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "First name",
                                  hintStyle: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 15.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: new TextFormField(
                                validator: (value) {
                                  return value.isNotEmpty
                                      ? null
                                      : "Empty Last Name";
                                },
                                onSaved: (val) => lastname = val,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline),
                                  hintText: "Last name",
                                  hintStyle: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 15.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: new TextFormField(
                          controller: _pass,
                          validator: (value) {
                            if (value.isEmpty) return "Empty password";
                            if (value != _confirmPass.text)
                              return "Password is not matched";
                          },
                          onSaved: (val) => password = val,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color: Colors.greenAccent, fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: new TextFormField(
                          controller: _confirmPass,
                          validator: (value) {
                            if (value.isEmpty) return "Empty password";
                            if (value != _pass.text)
                              return "Re-Password is not matched";
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_open),
                            hintText: "Re-Password",
                            hintStyle: TextStyle(
                                color: Colors.greenAccent, fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius:
                                    12.0, // has the effect of softening the shadow
                                spreadRadius:
                                    0.0, // has the effect of extending the shadow
                                offset: Offset(
                                  0.0, // horizontal, move right 10
                                  0.0, // vertical, move down 10
                                ),
                              )
                            ],
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  "https://i.imgur.com/BoN9kdC.png"),
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onSubmit();
                    },
                    child: Container(
                      width: 200.0,
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.greenAccent,
                      ),
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
