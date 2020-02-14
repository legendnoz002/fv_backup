import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class API extends StatefulWidget {
  @override
  APIState createState() => APIState();
}

class APIState extends State<API> {
  final formKey = GlobalKey<FormState>();
  SharedPreferences sharedPreferences;

  var success = false;

  Map<String, Map<String, String>> messages;

  String username;
  String password;

  String URL = "";
  String URLSuffix = "";

  dynamic responseData;
  String dialogHead = "";
  String dialogMessage = "";

  bool apiCall = false;

  void loadURL() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      URL = sharedPreferences.getString("URL") + URLSuffix;
    });
  }

  void onDialogPressed() {}

  onSuccess() {}

  Map<String, String> getBody() {}

  Future<http.Response> getResponse(
      String url, Map<String, String> body) async {
    print("##################################");
    print("this is body");
    print(body);
    print(URL);
    print("##################################");
    var response = await http.post(url, body: convert.jsonEncode(body), headers: {"Content-Type" : "application/json"});
    return response;
  }

  void submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      await loadURL();
      form.save();
      process();
    }
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
        var jsonResponse = convert.jsonDecode(response.body);
        var status = jsonResponse['status']['type'];
        if (status == 'failure') {
          dialogHead = messages["failure"]["dialogHead"];
          dialogMessage = jsonResponse['status']['message'];
          success = false;
          showAlertDialog();
        } else {
          responseData = jsonResponse;
          print(responseData);
          onSuccess();
        }
      }
    } else {
      setState(() {
        dialogHead = "Connection Error";
        dialogMessage = "Check connection and try again";
      });
      showAlertDialog();
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(dialogHead),
        content: Text(dialogMessage),
        actions: [
          new FlatButton(child: const Text("Ok"), onPressed: onDialogPressed),
        ],
      ),
    );
  }

  void showIndicator() {
    if (apiCall) {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: new Dialog(
          child: Container(
              height: 100.0,
              child: new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new CircularProgressIndicator(),
                    new Text("Loading"),
                  ],
                ),
              )),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
