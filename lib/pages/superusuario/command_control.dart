import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../globals.dart' as globals;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CommandControl extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CommandControlPageState();
  }
}

class _CommandControlPageState extends State<CommandControl> {

  var _ciController = new TextEditingController();
  var _firstnameController = new TextEditingController();
  var _lastnameController = new TextEditingController();
  var _phoneController = new TextEditingController();

  String _tituloState = 'Crear/Actualizar Operador';

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedStreet;


  void initState() {
    // _firstnameController.text = globals.firstname;
    // _lastnameController.text = globals.lastname;
    _ciController.addListener(_printLatestValue);
    _dropDownMenuItems = buildAndGetDropDownMenuItems(globals.superUserStreets);
    _selectedStreet = _dropDownMenuItems[0].value;
    super.initState();
  }

    @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _ciController.removeListener(_printLatestValue);
    _ciController.dispose();
    super.dispose();
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
      _selectedStreet = selectedFruit;
    });
  }

  final Map<String, dynamic> _formData = {
    'id_card': null,
    'firstname': null,
    'lastname': null,
    'phone': null,
    'asigned_street': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _ciFocusNode = FocusNode();
  final _firstnameFocusNode = FocusNode();
  final _lastnameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  void updateFields(bool yesNo) {
    var userData = Firestore.instance
        .collection('operadores')
        .document(_formData['id_card'].toString());
    if (yesNo) {
      userData.updateData({
        "firstname": _formData["firstname"],
        "lastname": _formData["lastname"],
        "phone": _formData["phone"],
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
            'Los datos de Nombre, Apellido y/o telefono no son los mismos.\n¿Deseas modificarlos?',
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
            'Datos Actualizados!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Los datos de '+ _formData['id_card'].toString()+' han sido actualizados. ',
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

  Widget _showAsignStreetDialog(BuildContext context, String datos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Calle Asignada...',
            style: TextStyle(
              color: Colors.yellowAccent[700],
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'La calle se encuentra asignada a:\n' +
                'Cod: ' + datos.split('/')[1] +
                '\nNombre: ' + datos.split('/')[0] +
                '\n Deseas asignarla a:\n' +
                'Cod: ' + _formData['id_card'] +
                '\nNombre: ' + _formData['firstname'] + '?',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                // fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'ASIGNAR',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                var oldOperator = Firestore.instance
                .collection('sur_obrajes')
                .document(_formData['asigned_street'].split('/')[1]);

                oldOperator.updateData({
                  "operador": _formData['firstname']+'/'+_formData['id_card'],
                });

                var newStreetOperator = Firestore.instance
                .collection('operadores')
                .document(_formData['id_card']);

                newStreetOperator.updateData({
                  "asigned_street": 'obrajes/'+_formData['asigned_street'].split('/')[1],
                });

                var oldStreetOperator = Firestore.instance
                .collection('operadores')
                .document(datos.split('/')[1]);

                oldStreetOperator.updateData({
                  "asigned_street": 'obrajes/libre',
                });



                Navigator.pop(context);

              },
            ),
            FlatButton(
              child: Text(
                'NO',
                style: TextStyle(
                  color: Colors.red,
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

  Widget _buildCITextField() {
    return TextFormField(
      focusNode: _ciFocusNode,
      controller: _ciController,
      decoration: InputDecoration(
        labelText: 'Introduzca CI para cargar o crear sus datos',
        border: OutlineInputBorder(),
        fillColor: Colors.red[50],
        filled: true,
        counterText: ''
      ),
      keyboardType: TextInputType.number,
      maxLength: 7,
      
      validator: (String value) {
        if (value.isEmpty ||
            value.trim().length < 7 ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Solo nros, al menos 7 nros.';
        }
      },
      onSaved: (String value) {
        _formData['id_card'] = (int.parse(value)).toString().trim();
      },
    );
  }

  _printLatestValue() {
    
    if(_ciController.text.length>0){
      setState(() {
        _tituloState = 'Buscando...';     
      });
      
      print("CI ingresado: ${_ciController.text}");
      var operatorData = Firestore.instance
        .collection('operadores')
        .document(_ciController.text.toString());
      operatorData.get().then((dataOperator){
        if (dataOperator.exists) {
          setState(() {
            _tituloState = 'Encontrado!';        
          });
          _firstnameController.text = dataOperator.data['firstname'];
          _lastnameController.text = dataOperator.data['lastname'];
          _phoneController.text = dataOperator.data['phone'];
          bool flag = false;
          globals.superUserStreets.forEach((string){
            if(!flag && string.contains(dataOperator.data['asigned_street'].split('/')[1].split('c')[1])){
              print('Letra: '+dataOperator.data['asigned_street'].split('/')[1].split('c')[1]);
              setState(() {
                changedDropDownItem(string);
                _selectedStreet = string;
              });
              flag = true;
            }
          });

        }else{
          print('No existe!');
          setState(() {
            _tituloState = 'Crear/Actualizar Operador';        
          });
          _firstnameController.text = '';
          _lastnameController.text = '';
          _phoneController.text = '';
        }
      });
    }

  }

  Widget _buildFirstNameTextField() {
    return TextFormField(
      focusNode: _firstnameFocusNode,
      controller: _firstnameController,
      decoration: InputDecoration(
        labelText: 'Nombre(s)',
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Campo obligatorio';
        }
      },
      onSaved: (String value) {
        _formData['firstname'] = value.trim();
      },
    );
  }

  Widget _buildLastNameTextField() {
    return TextFormField(
      focusNode: _lastnameFocusNode,
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
        if (value.isEmpty) {
          return 'Compo obligatorio';
        }
      },
      onSaved: (String value) {
        _formData['lastname'] = value.trim();
      },
    );
  }

  Widget _buildPhoneTextField() {
    return TextFormField(
      focusNode: _phoneFocusNode,
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Nro. de Celular.',
        border: OutlineInputBorder(),
        fillColor: Colors.green[50],
        filled: true,
        counterText: '',
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
        _formData['phone'] = (int.parse(value)).toString().trim();
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
                _tituloState,
                style: new TextStyle(
                  fontSize: 30.0,
                  // height: 2.0,
                  color: Colors.red[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            _buildCITextField(),
            SizedBox(height: 5.0),
            _buildFirstNameTextField(),
            SizedBox(height: 20.0),
            _buildLastNameTextField(),
            SizedBox(height: 20.0),
            _buildPhoneTextField(),
            SizedBox(height: 5.0),
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
                        value: _selectedStreet,
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
          .collection('operadores')
          .document(_formData['id_card'].toString());

      for(int i = 0; i < globals.superUserStreets.length; i++){
        if(globals.superUserStreets[i] == _selectedStreet){
          setState(() {
            _formData['asigned_street'] = 'obrajes/'+globals.superUserStreetsCodes[i];  
            print('Calle asignada: ' + _formData['asigned_street']);       
          });
        }
      }
      userData.get().then((dataUser) {
        if (dataUser.exists) {
          print('El operador existe');
          if (dataUser.data['firstname'] != _formData['firstname'] ||
              dataUser.data['lastname'] != _formData['lastname']   || 
              dataUser.data['phone'] != _formData['phone']) {
            print("Quiero decidir si modificar info personal del operador o no..");
            _showYesNoDialog(context);
          }
        } else {
          print('El usuario no existe, entonces lo añado');
          userData.setData({
            "firstname": _formData['firstname'],
            "lastname": _formData['lastname'],
            "id_card": _formData['id_card'],
            "phone": _formData['phone'],
            "asigned_street": _formData['asigned_street'],
            "isSuperuser": false,
          });
          _showCreatedAccountDialog(context);
            
        }
        var oldOperator = Firestore.instance
            .collection('sur_obrajes')
            .document(_formData['asigned_street'].split('/')[1]);
        oldOperator.get().then((dataStreet) {
          if (dataStreet.exists) {
            print(dataStreet['operador'].split('/')[1] +' != '+ _formData['id_card']);
            if(dataStreet['operador'].split('/')[1] != _formData['id_card']){
              _showAsignStreetDialog(context, dataStreet['operador']); 
            } 
          }
        });
        //? Por el momento no puedo liberar asi por asi
        // if(_formData['asigned_street'].split('/')[1] == 'libre'){
        //   var operator = Firestore.instance
        //     .collection('operadores')
        //     .document(_formData['id_card']);

        //   operator.updateData({
        //     "asigned_street": 'obrajes/'+'libre',
        //   });
        // }
        //? Cuando cambia a alguien que tiene x ejm la calle 1 asiganda, a la calle 2
        // entonces la calle 1 y la calle 2 quedaran asignadas para el mismo individuo,
        // lo que llevara a un error de forma eventual

      });
    } catch (error) {
      print('error');
      // _showNoInternetDialog(context);
    }
  }



  // update(String token) {
  //   print(token);
  //   // textValue = token;
  //   var userToken = Firestore.instance
  //       .collection('usuarios')
  //       .document(_formData['phone'].toString());
  //   userToken.updateData({
  //     "token": token,
  //   });
  //   setState(() {});
  // }

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
