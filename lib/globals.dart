library apparcar.globals;

String accountPhone = "";
String carPlate = "none";
String firstname = "";
String lastname = "";
bool isPending;
List plates = [];

bool isSuperuser = false;
String userPhone = "";
String operatorCode = "";
Map<String, dynamic> operatorData = {
  'asigned_street': null,
  'firstname': null,
  'lastname': null,
  'id_card': null
};

List superUserStreets = ['Libre','Calle 1', 'Calle 2', 'Calle 5', 'Calle 6', 'Calle 7', 'Calle 8', 'Calle 9', 'Calle 11', 'Calle 12'];
List superUserStreetsCodes = ['Libre','c1', 'c2', 'c5', 'c6', 'c7', 'c8', 'c9', 'c11', 'c12'];