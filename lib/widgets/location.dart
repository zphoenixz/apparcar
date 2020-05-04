import 'package:flutter/material.dart';
// import 'package:map_view/map_view.dart';

import '../widgets/helper/ensure-visible.dart';
// import 'package:photo_view/photo_view.dart';

class LocationInput extends StatefulWidget {

  LocationInput(this.screenHeight, this.screenWidth);
  final double screenWidth;
  final double screenHeight;

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState(screenHeight, screenWidth);
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  final double screenWidth;
  final double screenHeight;

  _LocationInputState(this.screenHeight, this.screenWidth);

  final FocusNode _addressInputFocusNode = FocusNode();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    getStaticMap();
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap() /* async */ {
    // final StaticMapProvider staticMapViewProvider =
    //     StaticMapProvider('AIzaSyBsXW706lYxb9BGFefN_9ftpDkjaGyOO4E');
    // final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
    //   [
    //     Marker(
    //       'id',
    //       'Posición',
    //       -16.523389,
    //       -68.112501, /* markerIcon:  */
    //     ),
    //     Marker('id', 'Posición', -16.523762, -68.111719),
    //   ],
    //   center: Location(-16.5234068, -68.1124952),
    //   width: 300,
    //   height: 400,
    //   maptype: StaticMapViewType.roadmap,
    // );
    // setState(
    //   () {
    //     _staticMapUri = staticMapUri;
    //     print(_staticMapUri.toString());
    //   },
    // );
  }

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
          ),
        ),
        SizedBox(
          height: screenHeight * 0.2,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          height: screenHeight * 0.6,
          width: screenWidth * 0.9,
          // child: PhotoViewInline(
          //     imageProvider: new NetworkImage(_staticMapUri
          //         .toString()) //Image.network(_staticMapUri.toString()),

          //     ),
        ),
      ],
    );
  }
}
