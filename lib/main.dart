import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:map_view/map_view.dart';
// import 'package:flutter/rendering.dart';

import './pages/start.dart';
import './pages/choose.dart';
import './pages/conductor/conductor.dart';
import './pages/info_page.dart';
import './pages/conductor/conductor_home.dart';

import './pages/operador/operador.dart';
import './pages/operador/operador_home.dart';

import './pages/superusuario/superuser_home.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // MapView.setApiKey('AIzaSyBsXW706lYxb9BGFefN_9ftpDkjaGyOO4E');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  String _textToShow;
  int _infoOption;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Colors.amberAccent[100],
        primarySwatch: Colors.green,
        accentColor: Colors.blue[50],
        buttonColor: Colors.redAccent[100],
      ),
      //home: AuthPage(),// "/" esta reservada para la home page
      routes: {
        '/': (BuildContext context) => new StartPage(), //Home Page
        '/choose': (BuildContext context) => new ChoosePage(), 
        '/info': (BuildContext context) => new InfoPage(_infoOption ,_textToShow), 

        '/conductor': (BuildContext context) => new ConductorPage(), 
        '/conductor_home': (BuildContext context) => new ConductorHomePage(), 

        '/operador': (BuildContext context) => new OperadorPage(), 
        '/operador_home': (BuildContext context) => new OperadorHomePage(), 

        '/superuser_home': (BuildContext context) => new SuperuserHomePage(), 

      },
      onUnknownRoute: (RouteSettings settings) {
        //como el 404 no encontrado
        // return MaterialPageRoute(
        // builder: (BuildContext context) => ProductsPage(_products));
      },
    );
  }
}
