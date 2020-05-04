import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import './streets_page.dart';
import 'package:intl/intl.dart';
import './conductor_street_history.dart';
import '../../globals.dart' as globals;

class ConductorStreetPage extends StatefulWidget {
  final Street street;

  ConductorStreetPage(this.street);
  @override
  State<StatefulWidget> createState() {
    return _ConductorStreetPageState(street);
  }
}

class _ConductorStreetPageState extends State<ConductorStreetPage> {
  Street street;

  _ConductorStreetPageState(this.street);

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

    DateTime _date = new DateTime.now();
    TimeOfDay _time = new TimeOfDay.now();
    String _titleDay = "Hoy,\n" + new DateFormat.yMd().format(new DateTime.now());
    String _selectedDate = "";
    String _selectedTime = "";
    bool _flagDate, _flagTime;

    Widget _showNoDateDialog(BuildContext context) {
      //MEnsaje de aviso, funcion
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Datos inexistentes',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 25.0,
              ),
            ),
            content: Text(
              'Lo sentimos pero no tenemos informacion de parqueo para la fecha que buscas',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'CONTINUAR',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context,
                  //     true); //Devuelvo true para borrar segun mi logica
                },
              ),
            ],
          );
        },
      );
    }

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2019),
      );
      // deco
      if (picked != null && picked != _date) {
        setState(() {
          _date = picked;
          _selectedDate = DateFormat.yMd().format(picked);
          _selectedDate = _selectedDate.replaceAll("/", "-");
        });
        // print('Date selected: ${_selectedDate}');
        _flagDate = true;
      } else {
        print('No quiero seleccionar fecha');
        _flagDate = false;
      }
    }

    Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay picked =
          await showTimePicker(context: context, initialTime: _time);

      if (picked != null /* && picked != _time */) {
        setState(() {
          _time = picked;
          _selectedTime = picked.toString().split("(")[1].replaceAll(")", "");
          _flagTime = true;
        });
        // print('Time selected: ${_selectedTime}');
      } else {
        setState(() {
          print('No quiero seleccionar hora');
          _flagTime = false;
        });
      }
    }

    var _buildNavIconButton = Container(
      padding: new EdgeInsets.only(
        top: screenHeight * 0.89,
        left: screenWidth * 0.83,
      ),
      child: FloatingActionButton(
        elevation: 20.0,
        onPressed: () {
          _selectDate(context).whenComplete(() {
            if (_flagDate) {
              _selectTime(context).whenComplete(() {
                if (_flagTime) {
                  var spaceHours = Firestore.instance
                      .collection('sur_obrajes')
                      .document("c" + street.id.toString())
                      .collection("historial")
                      .document(_selectedDate);

                  spaceHours.get().then((hours) {
                    if (hours.exists) {
                      print("Se encontraron los sgtes. datos de parqueo");
                      print(hours.data);
                      print(hours.data["spaceNumbers"][0]);

                      List oldSpaceNumers = [];
                      int _userHour = int.parse(_selectedTime.split(":")[0]);
                      int _userMinute = int.parse(_selectedTime.split(":")[1]);
                      var _userTimeConst = _userHour * 60 + _userMinute;

                      hours.data["spaceNumbers"].forEach((space) {
                        var hours = space.split(";");
                        print(hours);
                        bool ocupado = false;
                        for (int i = 1; i < hours.length - 1; i += 2) {
                          int _oldHourInf = int.parse(hours[i].split(":")[0]);
                          int _oldMinuteInf = int.parse(hours[i].split(":")[1]);
                          var _oldTimeConstInf =
                              _oldHourInf * 60 + _oldMinuteInf;

                          int _oldHourSup =
                              int.parse(hours[i + 1].split(":")[0]);
                          int _oldMinuteSup =
                              int.parse(hours[i + 1].split(":")[1]);
                          var _oldTimeConstSup =
                              _oldHourSup * 60 + _oldMinuteSup;

                          if (_oldTimeConstInf <= _userTimeConst &&
                              _oldTimeConstSup >= _userTimeConst) {
                            ocupado = true;
                            break;
                          }
                        }
                        if (ocupado) {
                          oldSpaceNumers.add('O');
                        } else {
                          oldSpaceNumers.add('L');
                        }
                      });
                      print('-------------');
                      print(oldSpaceNumers);
                      Street oldStreet = Street(
                          spaceNumbers: oldSpaceNumers,
                          name: street.name,
                          direction: street.direction,
                          id: street.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConductorStreetHistoryPage(
                                oldStreet, _selectedDate)),
                      );
                    } else {
                      print(
                          "No existe datos para la fecha y hora seleccionados");
                      _showNoDateDialog(context);
                    }
                  });
                }
              });
            }
          });
          // _selectTime(context).whenComplete(action);
          setState(() {
            // _activePage = 0;
          });
        },
        backgroundColor: Colors.red[400],
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black54,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(
          Icons.date_range,
          color: Colors.white,
          size: 35.0,
        ),
      ),
    );

    Widget _showReservedDialog(BuildContext context, int index) {
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
              'Esta reservado y no puede ser ocupado por el momento.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.yellow[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'CONTINUAR',
                  style: TextStyle(
                    color: Colors.yellow[800],
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

    Widget _showOccupiedDialog(BuildContext context, int index) {
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
              'Este espacio no puede ser ocupado por el momento, puesto que existe ya, un vehiculo aparcado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            actions: <Widget>[
              // FlatButton(
              //   child: Text('DISCARD'),
              //   onPressed: () {
              //     Navigator.pop(context); //Esto cierra el dialogo
              //   },
              // ),
              FlatButton(
                child: Text(
                  'CONTINUAR',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context,
                  //     true); //Devuelvo true para borrar segun mi logica
                },
              ),
            ],
          );
        },
      );
    }

    Widget _showPendingRequestDialog(BuildContext context, int index) {
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
              'Lo sentimos pero ya tienes una reserva pendiente o no has cumplido con una reserva anterior.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red[600],
                  // fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            actions: <Widget>[
              // FlatButton(
              //   child: Text('DISCARD'),
              //   onPressed: () {
              //     Navigator.pop(context); //Esto cierra el dialogo
              //   },
              // ),
              FlatButton(
                child: Text(
                  'CONTINUAR',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context,
                  //     true); //Devuelvo true para borrar segun mi logica
                },
              ),
            ],
          );
        },
      );
    }

    Widget _showNoAccountDialog(BuildContext context, int index) {
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
              'Para reservar un espacio, primero debe contar con una cuenta (Atras -> Pestaña Izq. -> Intro. su nro de celular)',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red[600],
                  // fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            actions: <Widget>[
              // FlatButton(
              //   child: Text('DISCARD'),
              //   onPressed: () {
              //     Navigator.pop(context); //Esto cierra el dialogo
              //   },
              // ),
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
                  // Navigator.pop(context,
                  //     true); //Devuelvo true para borrar segun mi logica
                },
              ),
            ],
          );
        },
      );
    }

    Widget _showConfirmationDialog(BuildContext context, int index) {
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
              'En segundos el operador de tu calle, aceptara o rechazara tu solicitud. Tendras 30 min para tomar el espacio en caso de ser plausible..',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'ENTENDIDO',
                  style: TextStyle(
                    color: Colors.green,
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

    void uploadReservePetition(BuildContext context, int index) {
      var streetRequested = Firestore.instance
          .collection('sur_obrajes')
          .document('c' + street.id.toString());

      var streetRequestedAux = Firestore.instance
          .collection('sur_obrajes')
          .document('c' + street.id.toString());

      var userData = Firestore.instance
                      .collection('usuarios')
                      .document(globals.accountPhone);
      userData.updateData({
        "isPending": false,
      });
      


      streetRequested.get().then((streetData) {
        List auxStreetData = streetData.data["spaceNumbers"];
        print("--------------------");
        print(auxStreetData);
        auxStreetData[(index - 1)] =
            "L/" + globals.accountPhone + "/" + globals.carPlate;
        streetRequestedAux.updateData({"spaceNumbers": auxStreetData});
      });
      _showConfirmationDialog(context, index);
    }

    Widget _showYesNoDialog(BuildContext context, int index) {
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
              'Si no lo tomas en 30 min. tendras una penalización (ver condiciones de uso).\n¿Estas seguro?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
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
                  // Navigator.pop(context,
                  //     true); //Devuelvo true para borrar segun mi logica
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
                  uploadReservePetition(context, index);
                  // Navigator.pop(context,
                  //     true); //Devuelvo true para borrar segun mi logica
                },
              ),
            ],
          );
        },
      );
    }

    Widget _showFreeDialog(BuildContext context, int index) {
      //MEnsaje de aviso, funcion
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            semanticLabel: 'asd',
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
              'Esta libre en este momento. Si deseas podrias reservarlo para tomarlo en max. en los sgtes 30 min.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'RESERVAR',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                onPressed: () {
                  var userData = Firestore.instance
                      .collection('usuarios')
                      .document(globals.accountPhone);

                  userData.get().then((dataUser) {
                    // print(dataUser.data["isPending"]);
                    setState(() {
                      globals.isPending = dataUser.data["isPending"];
                    });
                  }).whenComplete(() {
                    Navigator.pop(context);
                    if (!globals.isPending) {
                      print("is false");
                      _showYesNoDialog(context, index);
                    } else {
                      print("is true");
                      _showPendingRequestDialog(context, index);
                    }
                  });
                },
              ),
              FlatButton(
                child: Text(
                  'CANCELAR',
                  style: TextStyle(
                    color: Colors.red[600],
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

    String calcSpaceState(int index, List spaces) {
      if (spaces[index].split("/")[0] != 'L') {
        return spaces[index].split("/")[0];
      }
      return (index + 1).toString();
    }

    Widget _buildItem(
        {int index, double parentSize, String spaceState, List spaces}) {
      double edgeSize = 8.0;
      double itemSize = screenWidth * 0.3;
      return Container(
        padding: EdgeInsets.all(edgeSize),
        child: GestureDetector(
          onTap: () {
            // print('Yo soy el box nro: ' + index.toString());
            if (spaceState.split("/")[0] == 'R') {
              _showReservedDialog(context, index);
            } else if (spaceState.split("/")[0] == 'O') {
              _showOccupiedDialog(context, index);
            } else {
              if (globals.accountPhone != "none") {
                _showFreeDialog(context, index);
              } else {
                _showNoAccountDialog(context, index);
              }
            }
          },
          child: SizedBox(
            width: 50.0,
            height: itemSize,
            child: Container(
              alignment: AlignmentDirectional.center,
              color: spaceState.split("/")[0] == 'R'
                  ? Colors.yellow
                  : spaceState.split("/")[0] == 'O'
                      ? Colors.red[600]
                      : Colors.green,
              child: Text(
                calcSpaceState(index - 1, spaces),
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
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('sur_obrajes')
                .document('c' + street.id.toString())
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
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data["spaceNumbers"].length,
                  itemBuilder: (BuildContext content, int index) {
                    return _buildItem(
                      index: index + 1,
                      parentSize: height / 4,
                      spaceState: snapshot.data["spaceNumbers"][index],
                      spaces: snapshot.data["spaceNumbers"],
                    );
                  });
            }),
      );
    }

    Widget _buildContent() {
      //  return ListView.builder(
      //   itemCount: 1,
      //   itemBuilder: (BuildContext content, int index) {
      //     return _buildHorizontalList(parentIndex: index);
      //   },
      // );

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
                      // isotypeHero,
                    ],
                  ),
                ],
              ),
            ),
            _buildNavIconButton,
            // _buildPageView(),
          ],
        ),
      ),
      // floatingActionButton: _buildNavIconButton,
    );
  }
}
