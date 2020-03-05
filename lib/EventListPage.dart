import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Models/EventModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class EventListPage extends StatefulWidget {
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventListPage> {
  SharedPreferences sharedPreferences;
  String URL;
  String URLprefix = "get_event";
  var _jsonData;
  List<EventModel> events = [];
  Future _future;

  @override
  void initState() {
    _future = _getData();
    super.initState();
  }

  void loadURL() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      URL = sharedPreferences.getString("URL") + URLprefix;
    });
  }

  @override
  Future<List<EventModel>> _getData() async {
    await loadURL();
    var payload = {"username": sharedPreferences.getString("user")};
    http.Response _res = await http.post(URL,
        body: convert.jsonEncode(payload),
        headers: {"Content-Type": "application/json"});
    events.clear();
    _jsonData = json.decode(_res.body);
    print(_jsonData);
    for (var u in _jsonData) {
      EventModel _event = EventModel(u["event_id"],u["event_name"], u["type"]);
      events.add(_event);
    }
    print(events.length);
    return events;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Color(0xff3d343b),
                child: ListTile(
                  leading: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.yellow[500]),
                    child: snapshot.data[index].type == "vacation"
                        ? Icon(Icons.directions_bike, color: Colors.black)
                        : snapshot.data[index].type == "work"
                            ? Icon(Icons.work, color: Colors.black)
                            : Icon(Icons.change_history, color: Colors.black),
                  ),
                  title: Text(
                    snapshot.data[index].event_name,
                    style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: 20,
                        color: Colors.yellow),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) =>
                                _DetailPage(snapshot.data[index])));
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

class _DetailPage extends StatelessWidget {
  final EventModel event;

  _DetailPage(this.event);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3d343b),
        title: Text(event.event_id),
      ),
    );
  }
}
