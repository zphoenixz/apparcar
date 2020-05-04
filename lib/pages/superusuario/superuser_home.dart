import 'package:flutter/material.dart';

import '../info_page.dart';
import './street_maps.dart';
import './settings_page.dart';
import './command_control.dart';
import '../../globals.dart' as globals;

class SuperuserHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SuperuserHomePageState();
  }
}

class _SuperuserHomePageState extends State<SuperuserHomePage> {
  int _activePage = 1;

  ScrollController _pageController;

  void initState() {
    super.initState();

    
    
    _pageController = new PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // PageController _pageController;

    void _handleAppTap() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return InfoPage(3, 'Hola soy la pagina de informaciones de la App');
          },
        ),
      );
    }

    var isotypeBox = new Image.asset(
      'assets/logotipo.png',
      width: screenWidth * 0.45,
    );

    var isotypeHero = new Hero(
      tag: 'hero-tag-apparcar',
      child: isotypeBox,
    );

    var operadorBox = new Image.asset(
      'assets/operador/operador_title.png',
      width: screenWidth * 0.50,
    );

    var operadorHero = new Hero(
      tag: 'tag-operador-title',
      child: operadorBox,
    );

    var _buildNavIconButton = Container(
      // width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: screenWidth * 0.1,
          ),
          Container(
            padding: new EdgeInsets.only(
              top: screenHeight * 0.19,
            ),
            width: screenWidth * 0.25,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              heroTag: 'submenu_left',
              elevation: 30.0,
              mini: _activePage == 0 ? false : true,
              onPressed: () {
                // _pageController.jumpToPage(_pageController.initialPage);
                setState(() {
                  // _activePage = 0;
                });
                _pageController.animateTo(
                  MediaQuery.of(context).size.width * 0,
                  duration: new Duration(seconds: 1),
                  curve: Curves.easeIn,
                );
              },
              backgroundColor:
                  _activePage == 0 ? Colors.red[600] : Colors.lightBlue[50],
              child: Icon(
                Icons.settings,
                color: _activePage == 0 ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            padding: new EdgeInsets.only(
              top: screenHeight * 0.19,
            ),
            width: screenWidth * 0.4,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              heroTag: 'submenu_center',
              elevation: 30.0,
              mini: _activePage == 1 ? false : true,
              onPressed: () {
                _pageController.animateTo(
                  MediaQuery.of(context).size.width * 1.0,
                  duration: new Duration(seconds: 1),
                  curve: Curves.easeIn,
                );
                setState(() {
                  // _activePage = 1;
                });
              },
              backgroundColor:
                  _activePage == 1 ? Colors.yellow[600] : Colors.lightBlue[50],
              child: Icon(
                Icons.public,
                color: _activePage == 1 ? Colors.black87 : Colors.black,
              ),
            ),
          ),
          Container(
            padding: new EdgeInsets.only(
              top: screenHeight * 0.19,
            ),
            width: screenWidth * 0.25,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              heroTag: 'submenu_right',
              elevation: 30.0,
              mini: _activePage == 2 ? false : true,
              onPressed: () {
                _pageController.animateTo(
                  MediaQuery.of(context).size.width * 3,
                  duration: new Duration(seconds: 1),
                  curve: Curves.easeIn,
                );
                setState(() {
                  // _activePage = 2;
                });
              },
              backgroundColor:
                  _activePage == 2 ? Colors.green : Colors.lightBlue[50],
              child: Icon(
                Icons.format_list_bulleted,
                color: _activePage == 2 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _buildPageSettings({int index, Color color}) {
      return SettingsPage(index, color);
    }

    Widget _buildPageMap({int index, Color color}) {
      return Container(
        alignment: AlignmentDirectional.center,
        // color: color,
        child: Column(
          children: <Widget>[
            // Text(
            //   '$index',
            //   style: TextStyle(fontSize: 132.0, color: Colors.white),
            // ),
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * .001,
                left: screenWidth * 0.04,
              ),
              child: StreetMaps(screenHeight, screenWidth),
            ),
          ],
        ),
      );
    }

    Widget _buildPageLists({int index, Color color}) {
      return Container(
        padding: new EdgeInsets.only(
          top: screenHeight * .00,
          left: 15.0,
          right: 15.0,
          // bottom: 15.0,
        ),
        alignment: AlignmentDirectional.center,
        // color: color,
        child: CommandControl(),
      );
    }

    Widget _buildPageView() {
      return PageView(
        onPageChanged: (int value) {
          print('cambie: ' + value.toString());
          setState(() {
            _activePage = value;
          });
        },
        controller: _pageController,
        children: [
          _buildPageSettings(index: 1, color: Colors.green),
          _buildPageMap(index: 2, color: Colors.blue),
          _buildPageLists(index: 3, color: Colors.indigo),
          // _buildPage(index: 4, color: Colors.red),
        ],
      );
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(
                top: screenHeight * 0.04,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      operadorHero,
                      DecoratedBox(
                        decoration: BoxDecoration(),
                        child: SizedBox(
                          height: 10.0,
                          width: 0.05 * screenWidth,
                        ),
                      ),
                      GestureDetector(
                        onTap: _handleAppTap,
                        child: isotypeHero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildPageView(),
          ],
        ),
      ),
      floatingActionButton: _buildNavIconButton,
    );
  }
}
