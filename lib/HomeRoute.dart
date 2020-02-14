import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'EventTab.dart';
import 'ProfileTab.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int _currentIndex = 0;
  String barcode = "";

  final tabs = [
    Center(child: EventTab()),
    Center(child: ProfileTab()),
  ];

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
                  //scan();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future scan() async {
  //   try {
  //     String barcode = await BarcodeScanner.scan();
  //     setState(() {
  //       this.barcode = barcode;
  //     });
  //     Fluttertoast.showToast(
  //         msg: barcode,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIos: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } on PlatformException catch (e) {
  //     if (e.code == BarcodeScanner.CameraAccessDenied) {
  //       // The user did not grant the camera permission.
  //     } else {
  //       // Unknown error.
  //     }
  //   } on FormatException {
  //     // User returned using the "back"-button before scanning anything.
  //   } catch (e) {
  //     // Unknown error.
  //   }
  // }
}
