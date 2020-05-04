import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../globals.dart' as globals;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsPage extends StatefulWidget {
  final int index;
  final Color color;

  SettingsPage(this.index, this.color);
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState(index, color);
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final int index;
  final Color color;
  _SettingsPageState(this.index, this.color);

  var _firstnameController = new TextEditingController();
  var _lastnameController = new TextEditingController();

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedPlate;


  void initState() {
    if(globals.plates.length<1){
      globals.plates = [globals.carPlate];
    }
    

    _firstnameController.text = globals.firstname;
    _lastnameController.text = globals.lastname;


    _dropDownMenuItems = buildAndGetDropDownMenuItems(globals.plates);
    _selectedPlate = _dropDownMenuItems[0].value;
    super.initState();

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        print(" onMessage called ${(msg)}");
        showNotification(msg);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List plates) {
    List<DropdownMenuItem<String>> items = new List();
    for (String plate in plates) {
      items.add(new DropdownMenuItem(value: plate, child: new Text(plate)));
    }
    return items;
  }

  void changedDropDownItem(String selectedFruit) {
    setState(() {
      _selectedPlate = selectedFruit;
      globals.carPlate = _selectedPlate;
    });
    print(globals.carPlate);
  }

  final Map<String, dynamic> _formData = {
    'phone': null,
    'firstname': null,
    'lastname': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  void updateFields(bool yesNo) {
    var userData = Firestore.instance
        .collection('usuarios')
        .document(_formData['phone'].toString());
    if (yesNo) {
      userData.updateData({
        "firstname": _formData["firstname"],
        "lastname": _formData["lastname"],
      });
      _showUpdatedAccountDialog(context);
      print("Modifique");
    } else {
      print("No modifique");
    }
  }

  Widget _showYesNoDialog(BuildContext context) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Actualizacion de datos',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Tus datos de Nombre y/o Apellido no son los mismos.\n¿Deseas modificarlos?',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green,
                // fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'NO',
                style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                updateFields(false);
              },
            ),
            FlatButton(
              child: Text(
                'SI',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                updateFields(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showCreatedAccountDialog(BuildContext context) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Datos Creados!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Tus datos han sido validados con el nro:\n+591 ' +
                _formData['phone'].toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                // fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'GRACIAS',
                style: TextStyle(
                  color: Colors.green,
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

  Widget _showUpdatedAccountDialog(BuildContext context) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Datos Creados!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Tus datos han sido actualizados a tu cuenta con el nro:\n+591 ' +
                _formData['phone'].toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                // fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'GRACIAS',
                style: TextStyle(
                  color: Colors.green,
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

  Widget _showNewCarPlateDialog(BuildContext context) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Vehiculo Añadido!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Se encontro un nuevo nro. de placa: ' +
                globals.carPlate +
                '.\n Ya la añadimos a tu cuenta.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                // fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'GRACIAS',
                style: TextStyle(
                  color: Colors.green,
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

  Widget _showNoInternetDialog(BuildContext context) {
    //MEnsaje de aviso, funcion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error de conexión!',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Lo sentimos pero parece que no cuentas con conexion a internet, intenta mas tarde.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.green,
                  // fontWeight: FontWeight.bold,
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

  Widget _buildPhoneTextField() {
    return TextFormField(
      focusNode: _priceFocusNode,
      initialValue: globals.accountPhone == "" ? "" : globals.accountPhone,
      decoration: InputDecoration(
        labelText: 'Introduce tu nro para cargar o crear tus datos',
        border: OutlineInputBorder(),
        fillColor: Colors.red[50],
        filled: true,
      ),
      keyboardType: TextInputType.number,
      maxLength: 8,
      // initialValue://Obtener de firebase
      //     widget.product == null ? '' : widget.product['price'].toString(),
      validator: (String value) {
        if (value.isEmpty ||
            value.trim().length < 8 ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Solo nros, al menos 8 nros.';
        }
      },
      onSaved: (String value) {
        _formData['phone'] = int.parse(value);
      },
    );
  }

  Widget _buildFirstNameTextField() {
    return TextFormField(
      focusNode: _titleFocusNode,
      controller: _firstnameController,
      decoration: InputDecoration(
        labelText: 'Nombre(s)',
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),
      validator: (String value) {},
      onSaved: (String value) {
        _formData['firstname'] = value;
      },
    );
  }

  Widget _buildLastNameTextField() {
    return TextFormField(
      focusNode: _descriptionFocusNode,
      controller: _lastnameController,
      decoration: InputDecoration(
        labelText: 'Apellido(s)',
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),

      // initialValue: widget.product == null//Obtener de firebase si existe
      //     ? ''
      //     : widget.product['description'].toString(),
      validator: (String value) {
        // if (value.isEmpty || value.length < 4) {
        //   return 'El Apellido es requerido.';
        // }
      },
      onSaved: (String value) {
        _formData['lastname'] = value;
      },
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              child: Text(
                'Mis Datos',
                style: new TextStyle(
                  fontSize: 30.0,
                  height: 2.0,
                  color: Colors.red[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            _buildPhoneTextField(),
            SizedBox(height: 10.0),
            _buildFirstNameTextField(),
            SizedBox(height: 30.0),
            _buildLastNameTextField(),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: RaisedButton(
                    child: Text(
                      'Cargar',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.amber,
                    textColor: Colors.white,
                    onPressed: _submitForm,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  child: Container(
                    // color: Colors.amber[100],
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.blueAccent),
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: new DropdownButton(
                        value: _selectedPlate,
                        items: _dropDownMenuItems,
                        onChanged: changedDropDownItem,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          // decoration: TextDecoration.underline,
                        ),
                        iconSize: 30.0,
                        elevation: 24,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    print('fuera');
    _formKey.currentState.save();

    try {
      print('try');
      var userData = Firestore.instance
          .collection('usuarios')
          .document(_formData['phone'].toString());

      var carData = Firestore.instance
          .collection('usuarios')
          .document(_formData['phone'].toString())
          .collection('cars')
          .document(globals.carPlate);

      userData.get().then((dataUser) {
        if (dataUser.exists) {
          print('El usuario existe');
          if (_formData['firstname'] == "" && _formData['lastname'] == "") {
            print('No quiero modificar mi informacion, solo cargarla.');
            setState(() {
              globals.firstname = dataUser.data['firstname'];
              globals.lastname = dataUser.data['lastname'];
              _firstnameController.text = globals.firstname;
              _lastnameController.text = globals.lastname;
            });
          } else if (dataUser.data['firstname'] != _formData['firstname'] ||
              dataUser.data['lastname'] != _formData['lastname']) {
            print("Quiero decidir si modificar mi informaciono no.");

            _showYesNoDialog(context);
          }
        } else {
          print('El usuario no existe, entonces lo añado');
          // if(_formData['firstname'] == "")
          //   _formData['firstname'] = "none";
          // if(_formData['firstname'] == "")
          //   _formData['firstname'] = "none";
          userData.setData({
            "firstname": _formData['firstname'],
            "lastname": _formData['lastname'],
            "isPending": false,
          });
          _showCreatedAccountDialog(context);
        }
        //-----

        firebaseMessaging.getToken().then((token) {
          update(token);
        });
        //-----
        print("Quiero adicionar placa si corresponde");
        setState(() {
          globals.accountPhone = _formData['phone'].toString();
          print("Mi telefono ya es variable global: " + globals.accountPhone);
        });
        carData.get().then((dataCar) {
          if (!dataCar.exists) {
            print('La placa no existe asi que la añado');
            carData.setData({
              // "placa": globals.carPlate,
              "color": "none",
              "tipo": "none",
              "marca": "none",
            });
            _showNewCarPlateDialog(context);
          } else {
            print(globals.carPlate +
                ": La placa existe asi que no la molesto XD");
          }
        });
        var platesData = Firestore.instance
            .collection('usuarios')
            .document(_formData['phone'].toString())
            .collection('cars');

        platesData.getDocuments().then((onValue) {
          globals.plates.clear();
          globals.plates.add(globals.carPlate);
          var a = onValue.documents /* .elementAt(0) */;
          a.forEach((plate) {
            if (plate.documentID != globals.carPlate) {
              globals.plates.add(plate.documentID);
            }
          });
          setState(() {
            _dropDownMenuItems = buildAndGetDropDownMenuItems(globals.plates);
            print(globals.plates);
          });
        });
      });
    } catch (error) {
      print('error');
      _showNoInternetDialog(context);
    }
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    print('-------------');
    // print(msg.);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, msg['notification']['title'], msg['notification']['body'], platform);
  }

  update(String token) {
    print(token);
    // textValue = token;
    var userToken = Firestore.instance
        .collection('usuarios')
        .document(_formData['phone'].toString());
    userToken.updateData({
      "token": token,
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Widget pageContent = _buildPageContent(context);
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: new EdgeInsets.only(
        top: screenHeight * 0.21,
        // left: screenWidth * 0.01,
      ),
      child: pageContent,
    );
  }
}
