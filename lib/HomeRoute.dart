import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'EventTab.dart';
import 'ProfileTab.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  SharedPreferences sharedPreferences;
  String URL;
  String URLprefix = "compare";
  int _currentIndex = 0;
  String barcode = "";
  File galleryFile;

  final tabs = [
    Center(child: EventTab()),
    Center(child: ProfileTab()),
  ];

  void _joinEvent() async {
    print("open camera");
    await scan();
  }

  void selectFileFromCamera() async {
    final _file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (_file != null) {
      setState(() {
        galleryFile = _file;
      });
    }
  }

  void loadURL() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      URL = sharedPreferences.getString("URL") + URLprefix;
    });
  }

  Future<http.Response> _compare(File image) async {
    String url = URL;
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest = http.MultipartRequest('Post', Uri.parse(url));
    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['username'] = sharedPreferences.getString("loggedUser");
    imageUploadRequest.fields['ext'] = mimeTypeData[1];

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);
    return response;
  }

  void process() async {
    await loadURL();
    var response;
    var connected = true;
    await selectFileFromCamera();
    try {
      response = await _compare(galleryFile);
    } catch (e) {
      connected = false;
      print(e);
    }
    if (connected) {
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "success",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: new BottomAppBar(
        color: Color(0xff3d343b),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: new IconButton(
                color: Colors.yellow,
                icon: Icon(Icons.list),
                tooltip: "LIST",
                iconSize: 50.0,
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
            ),
            new IconButton(
              color: Colors.yellow,
              icon: Icon(Icons.person),
              tooltip: "PROFILE",
              iconSize: 50.0,
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: new IconButton(
                color: Colors.yellow,
                icon: Icon(Icons.camera_alt),
                tooltip: "JOIN",
                iconSize: 50.0,
                onPressed: () {
                  _joinEvent();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
      return showDialog(
          context: context,
          child: new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.yellow[600],
            content: Container(
              height: 290,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "https://i.kym-cdn.com/entries/icons/original/000/025/294/hrd.png"))),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        barcode,
                        style:
                            TextStyle(color: Colors.brown[400], fontSize: 20.0),
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              // FlatButton(
              //   child: Text("ok"),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // )
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50.0,
                      width: 120.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.red[300]),
                      child: Text(
                        'BACK',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      process();
                    },
                    child: Container(
                      height: 50.0,
                      width: 120.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.green[300]),
                      child: Text(
                        'JOIN',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  )
                ],
              )
            ],
          ));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // The user did not grant the camera permission.
      } else {
        // Unknown error.
      }
    } on FormatException {
      // User returned using the "back"-button before scanning anything.
      Fluttertoast.showToast(
          msg: "backed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      // Unknown error.
    }
  }
}
