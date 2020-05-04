// import 'dart:async';
// import 'package:flutter/material.dart';
// import './helper/layout_type.dart';
// // import 'package:layout_demo_flutter/pages/main_app_bar.dart';

// import '../pages/conductor_street.dart';

// class Street {
//   Street({this.totalSpace, this.name, this.direccion, this.id});
//   // int leftSpaces;
//   List totalSpace;
//   final String name;
//   final String direccion;
//   final String id;
// }

// class ListPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _ListPageState();
//   }
// }

// class _ListPageState extends State<ListPage> {
//   static List<Street> allStreets = [
//     Street(
//         // leftSpaces: 4,
//         totalSpace: ['R', 'O', 'O', 'O', 'R', 'L', 'R', 'R', 'R', 'R', 'O'],
//         name: 'Calle# 1 ',
//         direccion: 'Calle 1, Zona Sur, Obrajes',
//         id: 'lp_s_o_c1'),
//     Street(
//         // leftSpaces: 5,
//         totalSpace: ['R', 'O', 'O', 'R', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 2 ',
//         direccion: 'Calle 2, Zona Sur, Obrajes',
//         id: 'lp_s_o_c2'),
//     Street(
//         // leftSpaces: 6,
//         totalSpace: ['R', 'O', 'O', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 3 ',
//         direccion: 'Calle 3, Zona Sur, Obrajes',
//         id: 'lp_s_o_c3'),
//     Street(
//         // leftSpaces: 2,
//         totalSpace: ['O', 'O', 'O', 'O', 'O', 'O', 'R', 'R', 'L', 'L', 'O'],
//         name: 'Calle# 4 ',
//         direccion: 'Calle 4, Zona Sur, Obrajes',
//         id: 'lp_s_o_c4'),
//     Street(
//         // leftSpaces: 0,
//         totalSpace: ['R', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 5 ',
//         direccion: 'Calle 5, Zona Sur, Obrajes',
//         id: 'lp_s_o_c5'),
//     Street(
//         // leftSpaces: 13,
//         totalSpace: ['R', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 6 ',
//         direccion: 'Calle 6, Zona Sur, Obrajes',
//         id: 'lp_s_o_c6'),
//     Street(
//         // leftSpaces: 2,
//         totalSpace: ['R', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 7 ',
//         direccion: 'Calle 7, Zona Sur, Obrajes',
//         id: 'lp_s_o_c7'),
//     Street(
//         // leftSpaces: 14,
//         totalSpace: ['R', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 8 ',
//         direccion: 'Calle 8, Zona Sur, Obrajes',
//         id: 'lp_s_o_c8'),
//     Street(
//         // leftSpaces: 6,
//         totalSpace: ['R', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 9 ',
//         direccion: 'Calle 9, Zona Sur, Obrajes',
//         id: 'lp_s_o_c9'),
//     Street(
//         // leftSpaces: 7,
//         totalSpace: ['R', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 10',
//         direccion: 'Calle 10, Zona Sur, Obrajes',
//         id: 'lp_s_o_c10'),
//     Street(
//         // leftSpaces: 2,
//         totalSpace: ['R', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 11',
//         direccion: 'Calle 11, Zona Sur, Obrajes',
//         id: 'lp_s_o_c11'),
//     Street(
//         // leftSpaces: 6,
//         totalSpace: ['R', 'O', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'O'],
//         name: 'Calle# 12',
//         direccion: 'Calle 12, Zona Sur, Obrajes',
//         id: 'lp_s_o_c12')
//   ];

//   var refreshKey = GlobalKey<RefreshIndicatorState>();

//   @override
//   void initState() {
//     super.initState();
//     // random = Random();
//     // _handleRefresh();
//   }

//   Future<Null> _handleRefresh() async {
//     setState(() {
//       allStreets[0].totalSpace[0] = 'R';
//       allStreets[0].totalSpace[1] = 'O';
//       allStreets[0].totalSpace[2] = 'R';
//       allStreets[0].totalSpace[3] = 'R';
//       allStreets[0].totalSpace[4] = 'O';
//       allStreets[0].totalSpace[5] = 'R';
//       allStreets[0].totalSpace[6] = 'R';
//       allStreets[0].totalSpace[7] = 'R';
//       allStreets[0].totalSpace[8] = 'R';
//       allStreets[0].totalSpace[9] = 'R';
//       allStreets[0].totalSpace[10] = 'R';
//       // allStreets[0].totalSpace[5] = 'L';
//     });
//     await new Future.delayed(new Duration(seconds: 2));
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: new RefreshIndicator(
//         key: refreshKey,
//         child: _buildContent(),
//         onRefresh: _handleRefresh,
//         displacement: 200.0,
//         color: Colors.black54,
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return ListView.builder(
//     itemCount: allStreets.length,
//     itemBuilder: (BuildContext content, int index) {
//       Street calleNro = allStreets[index];
//       return Container(
//         decoration: new BoxDecoration(color: Colors.white70),
//         child: CalleListTile(calleNro, content),
//       );
//     },
//   );;
//   }

//   // void _onTap(BuildContext context) {
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => ConductorStreetPage()),
//   //   );
//   // }
// }

// class CalleListTile extends ListTile {
//   static int leftSpaces;
//   static String _calcLeftSpaces(List espacios) {
//     int c = 0;
//     for (int i = 0; i < espacios.length; i++) {
//       if (espacios[i] == 'L') c++;
//     }
//     leftSpaces = c;
//     return c.toString();
//   }

//   CalleListTile(Street street, BuildContext context)
//       : super(
//           title: Text(
//             street.name,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           subtitle: Text(street.direccion),
//           leading: CircleAvatar(
//             child: Text(
//               _calcLeftSpaces(street.totalSpace),
//               style: TextStyle(
//                   color: leftSpaces < 3
//                       ? Colors.white
//                       : leftSpaces < 8 ? Colors.black87 : Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: leftSpaces < 3
//                 ? Colors.red[600]
//                 : leftSpaces < 8 ? Colors.yellow : Colors.green,
//           ),
//           onTap: () {
//             print(street.id);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => ConductorStreetPage(street)),
//             );
//           },
//         );
// }
