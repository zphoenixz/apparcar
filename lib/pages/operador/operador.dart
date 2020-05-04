import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'dart:io';

import '../../widgets/helper/text-formatter.dart';
import '../info_page.dart';

class OperadorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OperadorPageState();
  }
}

class _OperadorPageState extends State<OperadorPage> {
  final Map<String, dynamic> _formData = {
    'nombre': null,
    'apellido': null,
    'codigo': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _connectionStatus;
  final Connectivity _connectivity = new Connectivity();

  StreamSubscription<ConnectivityResult> _connectionSubscription;
  /*
  ConnectivityResult is an enum with the values as { wifi, mobile, none }.
  */
  @override
  void initState() {
    super.initState();
    // initConnectivity(); before calling on button press
    _connectionSubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result.toString();
      });
    });
    print("Initstate : $_connectionStatus");
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  Widget _showNoOperatorFoundDialog(BuildContext context) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Operador no encontrado!',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Lo sentimos, pero parece que no tienes permiso para acceder a esta interfaz.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
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

  Widget _showOperatorWithNoStreetFoundDialog(BuildContext context) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Operador libre!',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Lo sentimos, pero parece que no tienes asignada ninguna calle por el momento',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
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

  Widget _showSuperUserFoundDialog(BuildContext context) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Administrador ' + globals.operatorData['asigned_street'] + '!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Bienvenido a tu interfaz ' +
                globals.operatorData['firstname'] +
                ' ' +
                globals.operatorData['lastname'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              // fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'GRACIAS',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/superuser_home');
              },
            ),
          ],
        );
      },
    );
  }

  void _handleAppTap() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(2,
              'La aplicación APPARCAR se desarrolló por un grupo de estudiantes que encontraron un problema en las personas que conducían vehículos en la zona obrajes ya que debido a la frustración que provoca buscar parqueos en las calles muchos llegaban tarde a sus destinos, por tal motivo hemos ubicado los distintos parqueos marcados por el GAMLP en las calles de obrajes. Puedes Usar nuestra Aplicación para Ver espacios disponibles en tiempo real por cada calle de obrajes. Para comprobar las Horas de Funcionamiento, los precios y el método de reserva. Verificar notificaciones y tiempo restante de aparcamiento. En APPARCAR desarrollamos las soluciones más precisas para transformar tu experiencia de estacionarte. ');
        },
      ),
    );
  }

  void _handleLaPazTap() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(2,
              'Estimados conductores, el GAMLP comunica que la Secretaria Municipal de Movilidad como Autoridad Municipal de Transporte y Transito a través de la Guardia Municipal de Transporte, desde el Octubre de 2018, ha iniciado controles en materia de estacionamiento en vía publica, en cumplimiento a la Ley Municipal de Transporte y Transito Urbano, al Reglamento Municipal del Régimen Sancionatorio en materia Transporte Urbano, Estacionamiento y Paradas Momentáneas y a las Resoluciones Ejecutivas N°903/2014 y N°317/2016, que determinaran los distintos tipos de infracciones que se puede realizar.');
        },
      ),
    );
  }

  Future<Null> initConnectivity() async {
    String connectionStatus;
    print('entre');
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = "Internet connectivity failed";
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
    print("InitConnectivity : $_connectionStatus");
    if (_connectionStatus == "ConnectivityResult.mobile" ||
        _connectionStatus == "ConnectivityResult.wifi") {
      _submitForm();
      try {
        final result = await InternetAddress.lookup('google.com')/* .timeout(Duration(seconds: 4)) */;
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          // _submitForm();
        }else{
          
        }
      } on SocketException catch (_) {
        print('No estas conectado a internet a pesar de tener wifi');
      }
    } else {
      print("You are not connected to internet");
    }
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    print('Empezando...');
    _formKey.currentState.save();
    globals.operatorCode = _formData["codigo"];

    var operatorData = Firestore.instance
        .collection('operadores')
        .document(globals.operatorCode.toString());
    print('buscando operador...' + globals.operatorCode);
    operatorData.get().then((dataUser) {
      if (dataUser.exists) {
        setState(() {
          globals.isSuperuser = dataUser.data['isSuperuser'];
        });
        if (!globals.isSuperuser) {
          print('Employee detected!');

          setState(() {
            if (dataUser.data['asigned_street'].split('/')[1] != 'libre') {
              globals.operatorData['firstname'] = dataUser.data['firstname'];
              globals.operatorData['lastname'] = dataUser.data['lastname'];
              globals.operatorData['id_card'] = dataUser.data['id_card'];
              globals.operatorData['asigned_street'] =
                  dataUser.data['asigned_street'];
              print(globals.operatorData['firstname']);
              print(globals.operatorData['lastname']);
              print(globals.operatorData['id_card']);
              print(globals.operatorData['asigned_street']);
              Navigator.of(context).pushNamed('/operador_home');
            } else {
              _showOperatorWithNoStreetFoundDialog(context);
            }
          });
        } else {
          // superuser_home
          setState(() {
            globals.operatorData['firstname'] = dataUser.data['firstname'];
            globals.operatorData['lastname'] = dataUser.data['lastname'];
            globals.operatorData['asigned_street'] =
                dataUser.data['asigned_street'];
            globals.isSuperuser = dataUser.data['isSuperuser'];
          });
          print('Suerpuser detected!');
          print(globals.operatorData['firstname']);
          print(globals.operatorData['lastname']);
          print(globals.operatorData['asigned_street']);
        }
      } else {
        print('operador ${globals.operatorCode} no existe');
        setState(() {
          globals.isSuperuser = false;
        });
        _showNoOperatorFoundDialog(context);
      }
    }).catchError((error) {
      print('No tienes internet o este es el error ::: ' + error);
    }).whenComplete(() {
      if (globals.isSuperuser) {
        _showSuperUserFoundDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var isotypeBox = new Image.asset(
      'assets/logotipo.png',
      width: screenWidth * 0.45,
    );

    var logotypeLaPaz = new Image.asset(
      'assets/logotipo_lapaz.png',
      width: screenWidth * 0.30,
    );

    var operadorBox = new Image.asset(
      'assets/operador/operador_title.png',
      width: screenWidth * 0.60,
    );

    var operadorHero = new Hero(
      tag: 'tag-operador-title',
      child: operadorBox,
    );

    var idBox = new Image.asset(
      'assets/operador/id.png',
      width: screenWidth * 0.80,
    );

    FocusNode textSecondFocusNode = new FocusNode();

    var _buildCharTextForm = TextFormField(
      keyboardType: TextInputType.text,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: '1234567',
        counterText: '',
        fillColor: Colors.lime[50],
        isDense: true,
        filled: true,
      ),
      maxLines: 1,
      style: new TextStyle(
        fontSize: 32.0,
        // height: 1.0,
        color: Colors.amberAccent[700],
        fontWeight: FontWeight.bold, height: 1.0,
      ),
      onFieldSubmitted: (String value) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      inputFormatters: [
        new UpperCaseTextFormatter(),
      ],
      maxLength: 7,
      focusNode: textSecondFocusNode,
      autocorrect: false,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Intro. código';
        }
      },
      onSaved: (String value) {
        _formData['codigo'] = value;
      },
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: _handleLaPazTap,
                        child: logotypeLaPaz,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(),
                        child: SizedBox(
                          height: 10.0,
                          width: 0.25 * screenWidth,
                        ),
                      ),
                      GestureDetector(
                        onTap: _handleAppTap,
                        child: isotypeBox,
                      ),
                    ],
                  ),
                  Container(
                    // alignment: Alignment.topCenter,
                    padding: new EdgeInsets.only(
                      top: screenHeight * 0.05,
                      // left: screenWidth * 0.01,
                    ),
                    child: Center(
                      child: new Container(
                        child: operadorHero,
                      ),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: new EdgeInsets.only(
                          top: screenHeight * 0.01,
                          bottom: 0.0,
                        ),
                        child: Center(
                          child: Text(
                            'Mi código es ...',
                            // textAlign: TextAlign.justify,
                            style: TextStyle(
                              // fontFamily: 'Oswald',
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: new EdgeInsets.only(
                          top: screenHeight * 0.08,
                          // left: screenWidth * 0.01,
                        ),
                        child: Center(
                          child: new Container(
                            child: idBox,
                          ),
                        ),
                      ),
                      Container(
                        // alignment: Alignment.topCenter,
                        padding: new EdgeInsets.only(
                          top: screenHeight * 0.198,
                          left: screenWidth * 0.1,
                        ),
                        // height: 50.0,
                        child: Row(
                          children: <Widget>[
                            new SizedBox(
                              width: screenWidth * 0.35,
                            ),
                            Flexible(
                              child: _buildCharTextForm,
                            ),
                            new SizedBox(
                              width: screenWidth * 0.18,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: new EdgeInsets.only(
                          top: screenHeight * 0.50,
                          // left: screenWidth * 0.01,
                        ),
                        child: Center(
                          child: new Container(
                            child: MaterialButton(
                              minWidth: screenWidth * 0.85,
                              height: screenHeight / 11,
                              color: Theme.of(context).accentColor,
                              child: Text(
                                'EMPEZAR',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  // fontFamily: 'Oswald',
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0,
                                ),
                              ),
                              onPressed: () {
                                initConnectivity();
                              }, //_submitForm,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
