import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './conductor_street.dart';
import '../../globals.dart';

class Street {
  Street({this.spaceNumbers, this.name, this.direction, this.id});
  // int leftSpaces;
  List spaceNumbers;
  final String name;
  final String direction;
  final int id;
}

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  // var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // var prevMonth = new DateTime(date.year, date.month - 1, date.day);
    // var date = new DateTime(2018, 1, 13);
    // 2017-12-13
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('sur_obrajes')
              .orderBy('id', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ));
            if (snapshot.hasError)
              print("el error es::::: " + snapshot.error.toString());
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext content, int index) {
                Street calleNro = Street(
                  spaceNumbers: snapshot.data.documents[index]['spaceNumbers'],
                  name: snapshot.data.documents[index]['name'],
                  direction: snapshot.data.documents[index]['direction'],
                  id: snapshot.data.documents[index]['id'],
                );
                return Column(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        color: Colors.white70,
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                        border: Border.all(),
                      ),
                      child: CalleListTile(calleNro, content),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                );
              },
            );
          }),
    );
  }
}

class CalleListTile extends ListTile {
  static int leftSpaces;
  static String _calcLeftSpaces(List espacios) {
    int c = 0;
    for (int i = 0; i < espacios.length; i++) {
      if (espacios[i].split("/")[0] == 'L') c++;
    }
    leftSpaces = c;
    return c.toString();
  }

  CalleListTile(Street street, BuildContext context)
      : super(
          title: Text(
            street.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(street.direction),
          leading: CircleAvatar(
            child: Text(
              _calcLeftSpaces(street.spaceNumbers),
              style: TextStyle(
                  color: leftSpaces < 3
                      ? Colors.white
                      : leftSpaces < 5 ? Colors.black87 : Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: leftSpaces < 3
                ? Colors.red[600]
                : leftSpaces < 5 ? Colors.yellow : Colors.green,
          ),
          onTap: () {
            print(street.id);
            print(street.spaceNumbers);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConductorStreetPage(street)),
            );
          },
        );
}
