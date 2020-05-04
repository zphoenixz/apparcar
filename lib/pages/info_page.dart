import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final String textToShow;
  final int infoOption;
  InfoPage(this.infoOption, this.textToShow);

  @override
  State<StatefulWidget> createState() {
    return new _InfoPageState(infoOption, textToShow);
  }
}

class _InfoPageState extends State<InfoPage> {
  String _textToShow;
  int _infoOption;

  _InfoPageState(this._infoOption, this._textToShow);

  void _submitForm() {
    if (_infoOption == 1) {
      Navigator.popAndPushNamed(context, '/choose');
    } else if (_infoOption == 2) {
      Navigator.popAndPushNamed(context, '/conductor');
    } else if (_infoOption == 3) {
      Navigator.popAndPushNamed(context, '/conductor_home');
    } /* else if (_infoOption == 4) {
      Navigator.popAndPushNamed(context, '/conductor_home');
    }  */
    else {}
  }

  void _handleAppTap() {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(
              _infoOption, 'La aplicación APPARCAR se desarrolló por un grupo de estudiantes que encontraron un problema en las personas que conducían vehículos en la zona obrajes ya que debido a la frustración que provoca buscar parqueos en las calles muchos llegaban tarde a sus destinos, por tal motivo hemos ubicado los distintos parqueos marcados por el GAMLP en las calles de obrajes. Puedes Usar nuestra Aplicación para Ver espacios disponibles en tiempo real por cada calle de obrajes. Para comprobar las Horas de Funcionamiento, los precios y el método de reserva. Verificar notificaciones y tiempo restante de aparcamiento. En APPARCAR desarrollamos las soluciones más precisas para transformar tu experiencia de estacionarte. ');
        },
      ),
    );
  }

  void _handleLaPazTap() {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(_infoOption,
              'Estimados conductores, el GAMLP comunica que la Secretaria Municipal de Movilidad como Autoridad Municipal de Transporte y Transito a través de la Guardia Municipal de Transporte, desde el Octubre de 2018, ha iniciado controles en materia de estacionamiento en vía publica, en cumplimiento a la Ley Municipal de Transporte y Transito Urbano, al Reglamento Municipal del Régimen Sancionatorio en materia Transporte Urbano, Estacionamiento y Paradas Momentáneas y a las Resoluciones Ejecutivas N°903/2014 y N°317/2016, que determinaran los distintos tipos de infracciones que se puede realizar.');
        },
      ),
    );
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
              SizedBox(
                width: screenWidth*0.8,
                height: screenHeight * 0.75,
                child: new SingleChildScrollView(
                  child: Text(
                    _textToShow,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      // fontFamily: 'Oswald',
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20.0,
                    ),
                  ),
                ),
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
                        'ATRAS',
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
      ),
    );
  }
}
