import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import '../widgets/helper/ensure-visible.dart';
import 'package:parallax_image/parallax_image.dart';

class StreetMaps extends StatefulWidget {
  StreetMaps(this.screenHeight, this.screenWidth);
  final double screenWidth;
  final double screenHeight;

  @override
  State<StatefulWidget> createState() {
    return _StretMapsState(screenHeight, screenWidth);
  }
}

class StreetSuperUser {
  StreetSuperUser(
      {this.spaceNumbers,
      this.name,
      this.direction,
      this.id,
      this.streetOperator,
      this.idOperator});

  List spaceNumbers;
  final String name;
  final String direction;
  final String streetOperator;
  final String idOperator;
  final int id;
}

class StreetOperator {
  StreetOperator({
    this.firstname,
    this.lastname,
    this.idCard,
    this.asignedStreet,
    this.phone,
  });

  final String firstname;
  final String lastname;
  final String idCard;
  final String asignedStreet;
  final String phone;
}

class _StretMapsState extends State<StreetMaps> {
  final double screenWidth;
  final double screenHeight;
  // ScrollController _pageController;

  _StretMapsState(this.screenHeight, this.screenWidth);

  @override
  void initState() {
    super.initState();
  }

  Widget _showOperatorDataDialog(
      BuildContext context, StreetOperator operatorX) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Operador ' + operatorX.asignedStreet + '!',
            style: TextStyle(
              color: Colors.indigo[900],
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'ID: ' +
                operatorX.idCard +
                '\n' +
                'Nombre: ' +
                operatorX.firstname +
                '\n' +
                'Apellido: ' +
                operatorX.lastname +
                '\n' +
                'Celular: ' +
                operatorX.phone,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.indigoAccent[100],
              // fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'GRACIAS',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).pushNamed('/superuser_home');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showParkedCarsCounterDataDialog(
      BuildContext context, StreetOperator operatorX, int contador) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            operatorX.asignedStreet + '!',
            style: TextStyle(
              color: Colors.indigo[900],
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Se han parqueado un total de:\n' +
                contador.toString() +
                ' vehiculos el dia de hoy',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.indigoAccent[100],
              // fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'GRACIAS',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).pushNamed('/superuser_home');
              },
            ),
          ],
        );
      },
    );
  }

  static const double kMinRadius = 32.0;
  static const double kMaxRadius = 500.0;
  static const opacityCurve =
      const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  static RectTween _createRectTween(Rect begin, Rect end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  static Widget _buildPage(
      BuildContext context, String imageName, String description) {
    return Container(
      color: Theme.of(context).canvasColor,
      alignment: FractionalOffset.center,
      child: SizedBox(
        width: kMaxRadius * 2.0,
        height: kMaxRadius * 2.0,
        child: Hero(
          createRectTween: _createRectTween,
          tag: imageName,
          child: RadialExpansion(
            //<<<<<<<<<<<<<<<<<< 3.-
            maxRadius: kMaxRadius,
            child: Photo(
              photo: imageName,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(
      BuildContext context, String imageName, String description) {
    return Container(
      width: kMinRadius * 3.0,
      height: kMinRadius * 3.0,
      child: Hero(
        createRectTween: _createRectTween,
        tag: imageName,
        child: RadialExpansion(
          maxRadius: kMaxRadius,
          child: Photo(
            photo: imageName,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder<Null>(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return AnimatedBuilder(
                        animation: animation,
                        builder: (BuildContext context, Widget child) {
                          return Opacity(
                            opacity: opacityCurve.transform(animation.value),
                            child: _buildPage(context, imageName, description),
                          );
                        });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalChild(
      BuildContext context, int index, StreetSuperUser street) {
    // index++;
    // if (index > 9) return null;
    return new Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: new ParallaxImage(
        extent: 150.0,
        image: new ExactAssetImage(
          'assets/calles/c${(index + 1)}a.jpg',
        ),
        // controller: _pageController,
        child: Column(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(
                bottom: screenHeight * 0.3,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildHero(
                      context, 'assets/calles/c${(index + 1)}.jpg', 'Chair'),
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.lightBlue[900],
                    ),
                    onTap: () {
                      print('Se han parqueado X autos el dia de hoys');
                      var operatorData = Firestore.instance
                          .collection('operadores')
                          .document(street.idOperator);
                      operatorData.get().then((dataUser) {
                        if (dataUser.exists) {
                          print('Employee detected!');
                          StreetOperator operatorX = StreetOperator(
                            asignedStreet: dataUser.data['asigned_street'],
                            firstname: dataUser.data['firstname'],
                            lastname: dataUser.data['lastname'],
                            idCard: dataUser.data['id_card'],
                            phone: dataUser.data['phone'],
                          );
                          //? Aca debo consultar el historial del dia de la BD
                          _showParkedCarsCounterDataDialog(context, operatorX, 0);
                        } else {
                          print('operador ${street.idOperator} no existe');
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.0,
              ),
              child: CircleAvatar(
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
            ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.03,
              ),
              child: GestureDetector(
                child: SizedBox(
                  width: screenHeight * 0.18,
                  height: 42.0,
                  child: DecoratedBox(
                    child: Center(
                      child: Text(
                        street.streetOperator,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onTap: () {
                  print(street.idOperator);
                  var operatorData = Firestore.instance
                      .collection('operadores')
                      .document(street.idOperator);
                  operatorData.get().then((dataUser) {
                    if (dataUser.exists) {
                      print('Employee detected!');
                      StreetOperator operatorX = StreetOperator(
                        asignedStreet: dataUser.data['asigned_street'],
                        firstname: dataUser.data['firstname'],
                        lastname: dataUser.data['lastname'],
                        idCard: dataUser.data['id_card'],
                        phone: dataUser.data['phone'],
                      );
                      _showOperatorDataDialog(context, operatorX);
                    } else {
                      print('operador ${street.idOperator} no existe');
                    }
                  }).whenComplete(() {
                    // _showOperatorDataDialog(context, operatorX);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int leftSpaces;
  static String _calcLeftSpaces(List espacios) {
    int c = 0;
    for (int i = 0; i < espacios.length; i++) {
      // print(espacios[i]);
      // print(espacios[i].split("/")[0]);
      if (espacios[i].split("/")[0] == 'L') c++;
    }
    leftSpaces = c;
    return c.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: screenHeight * 0.25,
        ),
        Container(
          // margin: const EdgeInsets.symmetric(horizontal: 0.0),
          height: screenHeight * 0.71,
          width: screenWidth * 0.9,
          child: StreamBuilder(
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
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.documents.length,
                  // itemBuilder: _buildHorizontalChild,
                  itemBuilder: (BuildContext content, int index) {
                    StreetSuperUser calleNro = StreetSuperUser(
                        spaceNumbers: snapshot.data.documents[index]
                            ['spaceNumbers'],
                        name: snapshot.data.documents[index]['name'],
                        direction: snapshot.data.documents[index]['direction'],
                        id: snapshot.data.documents[index]['id'],
                        streetOperator: snapshot
                            .data.documents[index]['operador']
                            .split('/')[0],
                        idOperator: snapshot.data.documents[index]['operador']
                            .split('/')[1]);
                    // print(snapshot.data.documents[index]['spaceNumbers']);
                    return _buildHorizontalChild(content, index, calleNro);
                  },
                );
              }),

          // new ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   itemBuilder: _buildHorizontalChild,
          // ),
        ),
      ],
    );
  }
}

class Photo extends StatelessWidget {
  Photo({Key key, this.photo, this.color, this.onTap}) : super(key: key);

  final String photo;
  final Color color;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return Material(
      // Slightly opaque color appears where the image has transparency.
      // Makes it possible to see the radial transformation's boundary.
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: InkWell(
        onTap: onTap,
        child: Image.asset(
          photo,
          fit: BoxFit.contain,
          // height: 400.0,//
          // width: 400.0,///
        ),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key key,
    this.maxRadius,
    this.child,
  })  : clipRectExtent = 2.0 * (maxRadius / math.sqrt2), //*2
        super(key: key);

  final double maxRadius;
  final clipRectExtent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // The ClipOval matches the RadialExpansion widget's bounds,
    // which change per the Hero's bounds as the Hero flies to
    // the new route, while the ClipRect's bounds are always fixed.
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectExtent,
          height: clipRectExtent,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}
