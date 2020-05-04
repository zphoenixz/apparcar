import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:cloud_firestore/cloud_firestore.dart';

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

class Street {
  Street({this.spaceNumbers, this.name, this.direction, this.id});
  // int leftSpaces;
  List spaceNumbers;
  final String name;
  final String direction;
  final int id;
}

class _StretMapsState extends State<StreetMaps> {
  final double screenWidth;
  final double screenHeight;
  // ScrollController _pageController;

  _StretMapsState(this.screenHeight, this.screenWidth);

  final FocusNode _addressInputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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

  Widget _buildHorizontalChild(BuildContext context, int index, Street street) {
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
                    height: 20.0,
                  ),
                  GestureDetector(
                    child: Icon(Icons.local_activity),
                    onTap: () {
                      print('tap icono 2');
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.09,
              ),
              child: Row(
                children: <Widget>[
                  // Icon(Icons.arrow_back_ios),
                  // SizedBox(
                  //   width: 70.0,
                  // ),
                  // Icon(Icons.arrow_forward_ios),
                  CircleAvatar(
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
                ],
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
        // EnsureVisibleWhenFocused(
        //   focusNode: _addressInputFocusNode,
        //   child: TextFormField(
        //     focusNode: _addressInputFocusNode,
        //   ),
        // ),
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
                    Street calleNro = Street(
                      spaceNumbers: snapshot.data.documents[index]
                          ['spaceNumbers'],
                      name: snapshot.data.documents[index]['name'],
                      direction: snapshot.data.documents[index]['direction'],
                      id: snapshot.data.documents[index]['id'],
                    );
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
