import 'package:flutter/material.dart';

import './info_page.dart';

class ChoosePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ChoosePageState();
  }
}

class _ChoosePageState extends State<ChoosePage> {
  bool _active = false;

  void _handleAppTap() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(1, 'La aplicación APPARCAR se desarrolló por un grupo de estudiantes que encontraron un problema en las personas que conducían vehículos en la zona obrajes ya que debido a la frustración que provoca buscar parqueos en las calles muchos llegaban tarde a sus destinos, por tal motivo hemos ubicado los distintos parqueos marcados por el GAMLP en las calles de obrajes. Puedes Usar nuestra Aplicación para Ver espacios disponibles en tiempo real por cada calle de obrajes. Para comprobar las Horas de Funcionamiento, los precios y el método de reserva. Verificar notificaciones y tiempo restante de aparcamiento. En APPARCAR desarrollamos las soluciones más precisas para transformar tu experiencia de estacionarte. ');
        },
      ),
    );
  }

  void _handleLaPazTap() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(
              1, 'Estimados conductores, el GAMLP comunica que la Secretaria Municipal de Movilidad como Autoridad Municipal de Transporte y Transito a través de la Guardia Municipal de Transporte, desde el Octubre de 2018, ha iniciado controles en materia de estacionamiento en vía publica, en cumplimiento a la Ley Municipal de Transporte y Transito Urbano, al Reglamento Municipal del Régimen Sancionatorio en materia Transporte Urbano, Estacionamiento y Paradas Momentáneas y a las Resoluciones Ejecutivas N°903/2014 y N°317/2016, que determinaran los distintos tipos de infracciones que se puede realizar.');
        },
      ),
    );
  }

  void _handleChooseTap() {
    setState(() {
      _active = !_active;
    });
  }

  Widget _buildAcceptSwitch() {
    return Switch(
      value: _active,
      inactiveThumbColor: Colors.indigo,
      inactiveTrackColor: Colors.indigo[200],
      activeColor: Colors.green[600],
      activeTrackColor: Colors.green[300],
      onChanged: (bool value) {
        setState(() {
          _active = value;
        });
      },
    );
  }

  void _submitForm() {
    if (_active) {
      Navigator.of(context).pushNamed('/operador');
    } else {
      Navigator.of(context).pushNamed('/conductor');
    }
  }

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

    var logotypeLaPaz = new Image.asset(
      'assets/logotipo_lapaz.png',
      width: screenWidth * 0.30,
    );

    var conductorBox = new Image.asset(
      _active
          ? 'assets/choose/choose_empty.png'
          : 'assets/choose/choose_conductor.png',
      width: screenWidth * 0.55,
    );

    var conductorHero = new Hero(
      tag: 'tag-conductor-title',
      child: conductorBox,
    );

    var operadorBox = new Image.asset(
      _active
          ? 'assets/choose/choose_operador.png'
          : 'assets/choose/choose_empty.png',
      width: screenWidth * 0.55,
    );

    var operadorHero = new Hero(
      tag: 'tag-operador-title',
      child: operadorBox,
    );

    return new /* WillPopScope(
      onWillPop: () => Navigator.of(context).popAndPushNamed('/'),
      child: */ Scaffold(
        // appBar: AppBar(
        //   title: Text('Login'),
        // ),
        body: Container(
          child: Column(
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
                    child: isotypeHero,
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  // GestureDetector(
                  // onTap: _handleTap,
                  Center(
                    child: Image.asset(
                      _active
                          ? 'assets/choose/choose1.png'
                          : 'assets/choose/choose2.png',
                      width: screenWidth * 0.9,
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleChooseTap,
                    child: Container(
                      // alignment: Alignment.topCenter,
                      padding: new EdgeInsets.only(
                        top: screenHeight * .479,
                        left: screenWidth * 0.04,
                      ),
                      child: new Container(
                        child: conductorHero,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleChooseTap,
                    child: Container(
                      // alignment: Alignment.topCenter,
                      padding: new EdgeInsets.only(
                        top: screenHeight * .348,
                        left: screenWidth * 0.39,
                      ),
                      child: new Container(
                        child: operadorHero,
                      ),
                    ),
                  ),
                  Container(
                    // alignment: Alignment.topCenter,
                    padding: new EdgeInsets.only(
                      top: screenHeight * 0.69,
                      // left: screenWidth * 0.01,
                    ),
                    child: Center(
                      child: new Container(
                        width: screenWidth * 0.7,
                        child: _buildAcceptSwitch(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: screenWidth * 0.7,
                    child: MaterialButton(
                      height: screenHeight / 11,
                      color: Theme.of(context).accentColor,
                      child: Text(
                        'CONTINUAR',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          // fontFamily: 'Oswald',
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 34.0,
                        ),
                      ),
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
