import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../globals.dart' as globals;

class StartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _StartPageState();
  }
}

class _StartPageState extends State<StartPage> {
  bool _active = false;

  void _handleTap() {
    // print("Te saludo desde start " + globals.carPlate);
    setState(() {
      _active = !_active;
    });

    // Firestore.instance.runTransaction((Transaction transaction) async {
    //   CollectionReference reference =
    //       Firestore.instance.collection('obrajes');
    //   // print(reference);
    //   await reference.add({"title": "", "editing": false, "score": 0});
    // });

    Navigator.of(context).pushNamed('/choose');
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var isotypeBox = new Image.asset(
      'assets/logotipo.png',
      width: screenWidth,
    );

    var hero = new Hero(
      tag: 'hero-tag-apparcar',
      child: isotypeBox,
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Container(
        child: Column(
          children: <Widget>[
            hero,
            SizedBox(height: 15.0),
            GestureDetector(
              onTap: _handleTap,
              child: Image.asset(
                // _active ? 'assets/isotipo.gif' : 'assets/isotipo.png',
                'assets/isotipo.gif',
                width: screenWidth * 0.9,
                // color: !_active ? null : Colors.black.withOpacity(0.8),
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  '  La Paz',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    // fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
