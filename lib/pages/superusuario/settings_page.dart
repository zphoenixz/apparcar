import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../globals.dart' as globals;

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

  void initState() {
    super.initState();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List fruits) {
    List<DropdownMenuItem<String>> items = new List();
    for (String fruit in fruits) {
      items.add(new DropdownMenuItem(value: fruit, child: new Text(fruit)));
    }
    return items;
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Widget _buildIdCardTextField() {
    return TextFormField(
      initialValue: globals.operatorData['id_card'],
      enabled: false,
      decoration: InputDecoration(
        labelText: 'CARNET',
        labelStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),
    );
  }


  Widget _buildFirstNameTextField() {
    return TextFormField(
      initialValue: globals.operatorData['firstname'],
      enabled: false,
      decoration: InputDecoration(
        labelText: 'NOMBRE',
        labelStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),
    );
  }

  Widget _buildLastNameTextField() {
    return TextFormField(
      initialValue: globals.operatorData['lastname'],
      enabled: false,
      decoration: InputDecoration(
        labelText: 'APELLIDO',
        labelStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),
    );
  }

    Widget _buildAsignedStreetTextField() {
    return TextFormField(
      initialValue: globals.operatorData['asigned_street'],
      enabled: false,
      decoration: InputDecoration(
        labelText: 'ZONA ASIGNADA',
        labelStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(),
        fillColor: Colors.white54,
        filled: true,
      ),
    );
  }



  Widget _buildPageContent(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double labelSpacing = screenHeight*0.05;

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
            SizedBox(height: labelSpacing),
            _buildIdCardTextField(),
            SizedBox(height: labelSpacing),
            _buildFirstNameTextField(),
            SizedBox(height: labelSpacing),
            _buildLastNameTextField(),
            SizedBox(height: labelSpacing),
            _buildAsignedStreetTextField(),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final Widget pageContent = _buildPageContent(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: new EdgeInsets.only(
        top: screenHeight * 0.21,
        // left: screenWidth * 0.01,
      ),
      child: pageContent,
    );
  }
}
