import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import './streets_page.dart';

class ConductorStreetHistoryPage extends StatefulWidget {
  final Street street;
  final String date;

  ConductorStreetHistoryPage(this.street, this.date);
  @override
  State<StatefulWidget> createState() {
    return _ConductorStreetHistoryPageState(street, date);
  }
}

class _ConductorStreetHistoryPageState extends State<ConductorStreetHistoryPage> {
  Street street;
  String date;

  _ConductorStreetHistoryPageState(this.street, this.date);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var isotypeBox = new Image.asset(
      'assets/logotipo.png',
      width: screenWidth * 0.45,
    );

    var isotypeHero = new Hero(
      tag: 'hero-tag-apparcar',
      child: isotypeBox,
    );

    var conductorBox = new Image.asset(
      'assets/conductor/conductor_title.png',
      width: screenWidth * 0.50,
    );

    var conductorHero = new Hero(
      tag: 'tag-conductor-title',
      child: conductorBox,
    );

    var arrowBox = new Image.asset(
      'assets/conductor/arrow_down.png',
      width: screenWidth * 0.25,
    );

    var streetBox = new Image.asset(
      'assets/conductor/street.png',
      width: screenWidth * 0.6,
      height: screenHeight * 0.7,
    );


    String _titleDay =
        "Historial,\n" + date;


    Widget _showInactiveDialog(BuildContext context, int index) {
      //MEnsaje de aviso, funcion
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              street.name + ', espacio # ' + index.toString(),
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 25.0,
              ),
            ),
            content: Text(
              'No puedes reservar un espacio del historial...',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'ENTENDIDO',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }


    String calcSpaceState(int index) {
      if (street.spaceNumbers[index].split("/")[0] != 'L') {
        return street.spaceNumbers[index].split("/")[0] ;
      }
      return (index + 1).toString();
    }

    Widget _buildItem({int index /* , Color color */, double parentSize}) {
      double edgeSize = 8.0;
      double itemSize = screenWidth * 0.3;
      return Container(
        padding: EdgeInsets.all(edgeSize),
        child: GestureDetector(
          onTap: () {
            // print('Yo soy el box nro: ' + index.toString());
            _showInactiveDialog(context, index);
          },
          child: SizedBox(
            width: 50.0,
            height: itemSize,
            child: Container(
              alignment: AlignmentDirectional.center,
              color: street.spaceNumbers[index - 1].split("/")[0]  == 'R'
                  ? Colors.yellow
                  : street.spaceNumbers[index - 1].split("/")[0]  == 'O'
                      ? Colors.red[600]
                      : Colors.green,
              child: Text(
                calcSpaceState(index - 1),
                style: TextStyle(fontSize: 72.0, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildHorizontalList({int parentIndex}) {
      double height = screenHeight * 0.64;
      return SizedBox(
        height: height,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: street.spaceNumbers.length,
            itemBuilder: (BuildContext content, int index) {
              return _buildItem(
                index: index + 1,
                // color: colors[(parentIndex + index) % colors.length],
                parentSize: height / 4,
              );
            }),
      );
    }

    Widget _buildContent() {
      return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext content, int index) {
          return _buildHorizontalList(parentIndex: index);
        },
      );
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.22,
                left: screenWidth * 0.0,
                right: screenWidth * 0.7,
                // bottom: screenHeight*0.2,
              ),
              color: Colors.blueGrey[50],
              child: _buildContent(),
            ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.23,
                left: screenWidth * 0.4,
                // right: screenWidth * 0.0,
                // bottom: screenHeight * 0.1,
              ),
              child: streetBox,
            ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.35,
                left: screenWidth * 0.25,
                // right: screenWidth * 0.0,
                // bottom: screenHeight * 0.1,
              ),
              child: arrowBox,
            ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.165,
                left: screenWidth * 0.02,
                // right: screenWidth * 0.0,
                // bottom: screenHeight * 0.1,
              ),
              child: Text(
                street.direction + ':\nAv. 24 de Septiembre',
                style: TextStyle(
                  // fontFamily: 'Oswald',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              padding: new EdgeInsets.only(
                top: screenHeight * 0.15,
                left: screenWidth * 0.65,
                // right: screenWidth * 0.0,
                bottom: screenHeight * 0.1,
              ),
              child: Text(
                _titleDay,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.lightGreen[900]),
              ),
            ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.95,
                left: screenWidth * 0.02,
                // right: screenWidth * 0.0,
                // bottom: screenHeight * 0.5,
              ),
              child: Text(
                'Av. Hernando Siles',
                style: TextStyle(
                  // fontFamily: 'Oswald',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.04,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      conductorHero,
                      DecoratedBox(
                        decoration: BoxDecoration(),
                        child: SizedBox(
                          height: 10.0,
                          width: 0.05 * screenWidth,
                        ),
                      ),
                      isotypeHero,
                    ],
                  ),
                ],
              ),
            ),
            // _buildPageView(),
          ],
        ),
      ),
      // floatingActionButton: _buildNavIconButton,
    );
  }
}
