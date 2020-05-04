import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_database/firebase_database.dart';

import '../../globals.dart' as globals;

class CalleNumero {
  CalleNumero({this.spaceNumber, this.name, this.direction, this.id});
  // int leftSpaces;
  final String spaceNumber;
  final String name;
  final String direction;
  final int id;
}

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  //----------------------------------------------------------------------------

  String textValue = 'Hello World !';

  @override
  void initState() {
    super.initState();
  }

  //----------------------------------------------------------------------------
  Future _showSpaceAskedDialog(
      BuildContext context, int space, String plate) async {
    //MEnsaje de aviso, funcion
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Espacio #' + space.toString(),
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'El usuario XXXXXX con la placa ' +
                plate +
                ' quiere reservar el espacio #' +
                space.toString(),
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

  bool flag = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('sur_obrajes')
            .document(globals.operatorData['asigned_street'].split("/")[1])
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
            itemCount: snapshot.data["spaceNumbers"].length,
            itemBuilder: (BuildContext content, int index) {
              CalleNumero calleNro = CalleNumero(
                spaceNumber: snapshot.data["spaceNumbers"][index],
                name: snapshot.data['name'],
                direction: snapshot.data['direction'],
                id: snapshot.data['id'],
              );

              return Column(
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white70,
                      borderRadius: new BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                      border: Border.all(),
                    ),
                    child: CalleListTile(calleNro, content, index + 1),
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              );
            },
            // controller: controlar(),
          );
        },
      ),
    );
  }
}

class CalleListTile extends ListTile {
  static Widget _showApparcarDialog(
      BuildContext context, int space, String plate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Espacio #' + space.toString(),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Desea aparcar un vehiculo en este espacio? ',
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
            FlatButton(
              child: Text(
                'SI',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                apparcarVehiculo(space);
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _showCobrarDialog(
      BuildContext context, int space, String plate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Espacio #' + space.toString(),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Desea cobrar el tiempo al vehiculo? ',
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
            FlatButton(
              child: Text(
                'SI',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {    

                
               
                cobrarVehiculo(context, space);
                
                
              },
            ),
          ],
        );
      },
    );
  }

    static Widget _showTiempoAparcadoDialog(
      BuildContext context, int space, String horas) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Espacio #' + space.toString(),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 25.0,
            ),
          ),
          content: Text(
            'Usted estuvo aparcado un total de:\n'+horas,
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
                'COBRAR',
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

  static void apparcarVehiculo(int space) {
    print('..............');
    String dateNow = new DateFormat.yMd().format(new DateTime.now());
    String timeNow =
        (new TimeOfDay.now()).toString().split("(")[1].replaceAll(")", "");
    dateNow = dateNow.replaceAll('/', '-');
    print('Fecha: ' + dateNow + '  Hora: ' + timeNow);

    var streetRequested = Firestore.instance
        .collection('sur_obrajes')
        .document(globals.operatorData['asigned_street'].split("/")[1]);

    streetRequested.get().then((streetData) {
      List auxStreetData = streetData.data["spaceNumbers"];
      auxStreetData[(space - 1)] = "O/";

      streetRequested
          .updateData({"spaceNumbers": auxStreetData}).whenComplete(() {
        var spaceHours = Firestore.instance
            .collection('sur_obrajes')
            .document(globals.operatorData['asigned_street'].split("/")[1])
            .collection("historial")
            .document(dateNow);
        spaceHours.get().then((hours) {
          print('Se ocupara el espacio ' + space.toString());
          if (hours.exists) {
            print(
                'Si existen datos para ' + dateNow + ' asi que los modifico.');
            String spaceHour = timeNow + ';';
            print('Nueva cadena para el espacio ' + space.toString());
            print(spaceHour);
            List aux = hours.data["spaceNumbers"];
            aux[(space - 1)] += spaceHour;
            spaceHours.updateData({
              "spaceNumbers": aux,
            });
          } else {
            print('No existen datos para ' + dateNow + ' asi que los creo.');
            for (int i = 0; i < auxStreetData.length; i++) {
              if ((space - 1) == i) {
                auxStreetData[i] = ';' + timeNow + ';';
              } else {
                auxStreetData[i] = ';';
              }
            }
            spaceHours.setData({
              "spaceNumbers": auxStreetData,
            });
          }
        });
      });
    });
  }
  
  static String respuesta;
  static void cobrarVehiculo(BuildContext context,int space) {
    print('..............');
    String dateNow = new DateFormat.yMd().format(new DateTime.now());
    String timeNow =
        (new TimeOfDay.now()).toString().split("(")[1].replaceAll(")", "");
    dateNow = dateNow.replaceAll('/', '-');
    print('Fecha: ' + dateNow + '  Hora: ' + timeNow);
    int _userHour = int.parse(timeNow.split(":")[0]);
    int _userMinute = int.parse(timeNow.split(":")[1]);
    var _userTimeConst = _userHour * 60 + _userMinute;
    

    var streetRequested = Firestore.instance
        .collection('sur_obrajes')
        .document(globals.operatorData['asigned_street'].split("/")[1]);

    streetRequested.get().then((streetData) {
      List auxStreetData = streetData.data["spaceNumbers"];
      auxStreetData[(space - 1)] = "L/";
      
      streetRequested
          .updateData({"spaceNumbers": auxStreetData});
        var spaceHours = Firestore.instance
            .collection('sur_obrajes')
            .document(globals.operatorData['asigned_street'].split("/")[1])
            .collection("historial")
            .document(dateNow);
        spaceHours.get().then((hours) {
          print('Se desocupara el espacio ' + space.toString());
          if (hours.exists) {
            String spaceHour = timeNow + ';';
            print('Nueva cadena para el espacio ' + space.toString());
            print(spaceHour);
            List aux = hours.data["spaceNumbers"];
            print(aux[(space - 1)]);
            String oldHourCad = aux[(space - 1)].split(';')[(aux[(space - 1)].split(';').length-2)];
            print('Empezo a las '+ oldHourCad);
            int _oldHour = int.parse(oldHourCad.split(":")[0]);
            int _oldMinute = int.parse(oldHourCad.split(":")[1]);
            int _oldTimeConst = _oldHour * 60 + _oldMinute;

            int tiempoAparcado = _userTimeConst - _oldTimeConst;
            respuesta = ((tiempoAparcado/60).toInt()).toString()+' hrs. con '+(tiempoAparcado%60).toString()+' min.';

            Set();

            print('Estuviste parqueado ' + tiempoAparcado.toString() + ' minutos.');
            print(respuesta);
            print('00000');
            Navigator.pop(context);
            _showTiempoAparcadoDialog(context, space, respuesta);
            
            aux[(space - 1)] += spaceHour;
            spaceHours.updateData({
              "spaceNumbers": aux,
            });
    
            // 
          }
        });
    });
  }

  static void rejectPetition(int index) {
    print("Mi calle es:: " +
        globals.operatorData['asigned_street'].split("/")[1]);
    var streetRequested = Firestore.instance
        .collection('sur_obrajes')
        .document(globals.operatorData['asigned_street'].split("/")[1]);

    var streetRequestedAux = Firestore.instance
        .collection('sur_obrajes')
        .document(globals.operatorData['asigned_street'].split("/")[1]);

    streetRequested.get().then((streetData) {
      List auxStreetData = streetData.data["spaceNumbers"];
      print("--------------------");
      print(auxStreetData);
      globals.userPhone = auxStreetData[(index - 1)].split('/')[1];

      auxStreetData[(index - 1)] = "L/" +
          auxStreetData[(index - 1)].split('/')[1] +
          '/' +
          auxStreetData[(index - 1)].split('/')[2] +
          "/NO";

      streetRequestedAux
          .updateData({"spaceNumbers": auxStreetData}).whenComplete(() {
        auxStreetData[(index - 1)] = "L/";
        streetRequestedAux.updateData({"spaceNumbers": auxStreetData});
      }).whenComplete(() {
        var userData = Firestore.instance
            .collection('usuarios')
            .document(globals.userPhone);
        print('User refected Phone is :: ' + globals.userPhone);
        userData.updateData({
          "isPending": false,
        });
      });
    });
  }

  static void aceptedPetition(int index) {
    print("Mi calle es:: " +
        globals.operatorData['asigned_street'].split("/")[1]);
    var streetRequested = Firestore.instance
        .collection('sur_obrajes')
        .document(globals.operatorData['asigned_street'].split("/")[1]);

    var streetRequestedAux = Firestore.instance
        .collection('sur_obrajes')
        .document(globals.operatorData['asigned_street'].split("/")[1]);

    streetRequested.get().then((streetData) {
      List auxStreetData = streetData.data["spaceNumbers"];
      print("--------------------");
      print(auxStreetData);
      globals.userPhone = auxStreetData[(index - 1)].split('/')[1];
      auxStreetData[(index - 1)] = "L/" +
          auxStreetData[(index - 1)].split('/')[1] +
          '/' +
          auxStreetData[(index - 1)].split('/')[2] +
          "/YES";
      streetRequestedAux
          .updateData({"spaceNumbers": auxStreetData}).whenComplete(() {
        auxStreetData[(index - 1)] = "R/";
        streetRequestedAux.updateData({"spaceNumbers": auxStreetData});
        ;
      });
    });
  }

  CalleListTile(CalleNumero street, BuildContext context, int nroParqueo)
      : super(
          title: null,
          /* Stack(
            children: <Widget>[
              Container(
                child: Text(
                  "Espacio #" + nroParqueo.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ), */
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    // alignment: Alignment(0.0, 0.0),
                    padding: new EdgeInsets.only(
                      right: 100.0,
                      // left: screenWidth * 0.01,
                    ),
                    child: Text(
                      "Espacio #" + nroParqueo.toString(),
                      style: TextStyle(
                        // fontFamily: 'Oswald',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    child: Text(street.direction),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Opacity(
                    opacity: street.spaceNumber.split("/")[1] == "" ? 0.0 : 1.0,
                    child: Text(
                      street.spaceNumber.split("/")[1] == ""
                          ? 'nada'
                          : street.spaceNumber.split("/")[2] +
                              ',\ndesea reservar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Opacity(
                          opacity: street.spaceNumber.split("/")[1] == ""
                              ? 0.0
                              : 1.0,
                          child: MaterialButton(
                            minWidth: 00.0,
                            height: 0.0,
                            color: Colors.green,
                            child: Text(
                              'SI',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                // fontFamily: 'Oswald',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            onPressed: () {
                              if (street.spaceNumber.split("/")[1] != "") {
                                print('si');
                                aceptedPetition(nroParqueo);
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: Opacity(
                          opacity: street.spaceNumber.split("/")[1] == ""
                              ? 0.0
                              : 1.0,
                          child: MaterialButton(
                            minWidth: 10.0,
                            height: 0.0,
                            color: Colors.red,
                            child: Text(
                              'NO',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                // fontFamily: 'Oswald',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            onPressed: () {
                              if (street.spaceNumber.split("/")[1] != "") {
                                print('no');
                                rejectPetition(nroParqueo);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          leading: Stack(
            children: <Widget>[
              CircleAvatar(
                child: Text(
                  // _calcLeftSpaces(street.spaceNumber),
                  street.spaceNumber.split("/")[0],
                  style: TextStyle(
                      color: street.spaceNumber.split("/")[0] == 'R'
                          ? Colors.black87
                          : street.spaceNumber.split("/")[0] == 'O'
                              ? Colors.white
                              : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: street.spaceNumber.split("/")[0] == 'R'
                    ? Colors.yellow
                    : street.spaceNumber.split("/")[0] == 'O'
                        ? Colors.red[600]
                        : Colors.green,
              ),
            ],
          ),
          onTap: () {
            if (street.spaceNumber.split("/")[0] == 'R' ||
                street.spaceNumber.split("/")[0] == 'L') {
              _showApparcarDialog(context, nroParqueo, "werwert");
            } else if (street.spaceNumber.split("/")[0] == 'O') {
              _showCobrarDialog(context, nroParqueo, "werwert");
            }
            //OJO ACA METERE MENSAJES PARA L, O y R
          },
        );
}
