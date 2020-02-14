import 'package:flutter/material.dart';
import 'ProfilePage.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
          child: Container(
            color: Color(0xff1d1a1e),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ProfilePage(),
        ),
      ),
    );
  }
}