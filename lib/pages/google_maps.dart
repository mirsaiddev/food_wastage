import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkerIcon();
  }

  Future<void> _setMarkerIcon() async {}

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) async {
          _markers.add(
            Marker(
              markerId: MarkerId('1234'),
              position: LatLng(37.43296265331129, -122.08832357078792),
              infoWindow: InfoWindow(title: 'selam'),
              //icon: _markerIcon,
            ),
          );
          setState(() {});
          _controller.complete(controller);
        },
        markers: _markers,
        onLongPress: (pos) {
          print('pos = $pos');
          _markers = {};
          _markers.add(
            Marker(
              markerId: MarkerId('1234'),
              position: pos,
              infoWindow: InfoWindow(title: 'selam'),
            ),
          );
          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
