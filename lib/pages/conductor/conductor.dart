import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../globals.dart' as globals;


import '../../widgets/helper/text-formatter.dart';
import '../info_page.dart';

class ConductorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConductorPageState();
  }
}

class _ConductorPageState extends State<ConductorPage> {
  final Map<String, dynamic> _formData = {
    'placa_n': null,
    'placa_l': null,
    'nombre': null,
    'apellido': null,
    'celular': null,
    'imagen': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _active = false;
  bool _acceptTerms = false;

  void _handleAppTap() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(2, 'La aplicación APPARCAR se desarrolló por un grupo de estudiantes que encontraron un problema en las personas que conducían vehículos en la zona obrajes ya que debido a la frustración que provoca buscar parqueos en las calles muchos llegaban tarde a sus destinos, por tal motivo hemos ubicado los distintos parqueos marcados por el GAMLP en las calles de obrajes. Puedes Usar nuestra Aplicación para Ver espacios disponibles en tiempo real por cada calle de obrajes. Para comprobar las Horas de Funcionamiento, los precios y el método de reserva. Verificar notificaciones y tiempo restante de aparcamiento. En APPARCAR desarrollamos las soluciones más precisas para transformar tu experiencia de estacionarte. ');
        },
      ),
    );
  }

  void _handleLaPazTap() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(
              2, 'Estimados conductores, el GAMLP comunica que la Secretaria Municipal de Movilidad como Autoridad Municipal de Transporte y Transito a través de la Guardia Municipal de Transporte, desde el Octubre de 2018, ha iniciado controles en materia de estacionamiento en vía publica, en cumplimiento a la Ley Municipal de Transporte y Transito Urbano, al Reglamento Municipal del Régimen Sancionatorio en materia Transporte Urbano, Estacionamiento y Paradas Momentáneas y a las Resoluciones Ejecutivas N°903/2014 y N°317/2016, que determinaran los distintos tipos de infracciones que se puede realizar.');
        },
      ),
    );
  }

  void _handleUserTermsTap() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InfoPage(2, 'CONDICIONES DE USO\nGracias por utilizar la aplicación APPARCAR Al hacer uso de nuestro Servicio usted está aceptando estas condiciones. Por favor, léalas detenidamente. Nuestro Servicio es muy diverso, de modo que en ocasiones podrían ser aplicables condiciones y/o requisitos adicionales. En tales casos, las condiciones adicionales estarán disponibles en el servicio correspondiente. \nCondiciones de Uso:\n• No utilice nuestro Servicio de forma indebida.\n• El uso de nuestro Servicio otorga derecho de propiedad pública.\n• En relación al uso del Servicio, podremos enviarle anuncios del servicio, mensajes administrativos, vencimiento de plazos y otra información de su interés. Usted podrá rechazar algunas de dichas comunicaciones.\n• Nuestro Servicio está disponible en dispositivos móviles. Utilice responsablemente dichos servicios, de modo que NO le distraigan o impidan cumplir con las leyes de tránsito o afecten su seguridad.');
        },
      ),
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _active,
      // inactiveThumbColor: Colors.indigo,
      // inactiveTrackColor: Colors.indigo[200],
      activeColor: Colors.green[600],
      // activeTrackColor: Colors.green[300],
      onChanged: (bool value) {
        setState(() {
          _active = value;
        });
      },

      title: GestureDetector(
        onTap: _handleUserTermsTap,
        child: Text(
          'Acepto los terminos',
          textAlign: TextAlign.right,
          style: TextStyle(
              // fontFamily: 'Oswald',
              color: _acceptTerms ? Colors.red : Colors.black45,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 15.0,
              decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_active) {
      setState(() {
        _acceptTerms = true;
      });
    }

    if (!_formKey.currentState.validate() || !_active) {
      return;
    }
    _formKey.currentState.save();
    // print(_formKey);
    // print(_formData);
    globals.carPlate = _formData["placa_n"] + _formData["placa_l"];
    Navigator.of(context).pushNamed('/conductor_home');
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

    var conductorBox = new Image.asset(
      'assets/conductor/conductor_title.png',
      width: screenWidth * 0.60,
    );

    var conductorHero = new Hero(
      tag: 'tag-conductor-title',
      child: conductorBox,
    );

    var placaBox = new Image.asset(
      'assets/conductor/placa.png',
      width: screenWidth,
    );

    FocusNode textSecondFocusNode = new FocusNode();

    var _buildNumberTextForm = TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '1234',
        counterText: '',
      ),
      maxLength: 4,
      style: new TextStyle(
        fontSize: 55.0,
        height: 2.0,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(textSecondFocusNode);
      },
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Solo números';
        }
      },
      onSaved: (String value) {
        _formData['placa_n'] = value;
      },
    );

    var _buildCharTextForm = TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'XYZ',
        counterText: '',
      ),
      style: new TextStyle(
        fontSize: 55.0,
        height: 2.0,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
      onFieldSubmitted: (String value) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      inputFormatters: [
        new UpperCaseTextFormatter(),
      ],
      maxLength: 3,
      focusNode: textSecondFocusNode,
      autocorrect: false,
      validator: (String value) {
        if (value.isEmpty ||
            RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Solo letras';
        }
      },
      onSaved: (String value) {
        _formData['placa_l'] = value;
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
                      // GestureDetector(
                      //   onTap: _handleAppTap,
                      //   child: isotypeBox,
                      // ),
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
                        child: conductorHero,
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
                            'Mi placa es ...',
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
                          top: screenHeight * 0.04,
                          // left: screenWidth * 0.01,
                        ),
                        child: Center(
                          child: new Container(
                            child: placaBox,
                          ),
                        ),
                      ),
                      Container(
                        // alignment: Alignment.topCenter,
                        padding: new EdgeInsets.only(
                          top: screenHeight * 0.124,
                          // left: screenWidth * 0.01,
                        ),
                        child: Row(
                          children: <Widget>[
                            new SizedBox(
                              width: screenWidth * 0.19,
                            ),
                            Flexible(
                              child: _buildNumberTextForm,
                            ),
                            Flexible(
                              child: _buildCharTextForm,
                            ),
                            new SizedBox(
                              width: screenWidth * 0.1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: new EdgeInsets.only(
                          top: screenHeight * 0.4,
                          right: screenWidth * 0.15,
                        ),
                        child: _buildAcceptSwitch(),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: new EdgeInsets.only(
                          top: screenHeight * 0.48,
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
                              onPressed: _submitForm,
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
