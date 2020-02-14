import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Models/EventModel.dart';

class EventListPage extends StatefulWidget {
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventListPage> {
  var _jsonData;
  List<EventModel> events = [];

  @override
  Future<List<EventModel>> _getData() async {
    http.Response _res = await http
        .get("http://www.json-generator.com/api/json/get/bUJJCmMnpK?indent=2");
    events.clear();
    _jsonData = json.decode(_res.body);
    for (var u in _jsonData) {
      EventModel _event = EventModel(u["id"], u["title"], u["img"]);
      events.add(_event);
    }
    print(events.length);
    return events;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            child: Center(
              child: Text("Loading"),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Color(0xff3d343b),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data[index].image),
                  ),
                  title: Text(
                    snapshot.data[index].title,
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
  final EventModel user;

  _DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3d343b),
        title: Text(user.title),
      ),
    );
  }
}
