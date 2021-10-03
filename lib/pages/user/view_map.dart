import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key, required this.initialLatLng}) : super(key: key);
  final LatLng initialLatLng;

  @override
  _ViewMapState createState() => _ViewMapState(initialLatLng);
}

class _ViewMapState extends State<ViewMap> {
  final LatLng initialLatLng;

  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  late BitmapDescriptor _markerIcon;

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(36.778259, -119.417931),
    zoom: 7,
  );

  _ViewMapState(this.initialLatLng);

  Future<void> _onMapCreated(GoogleMapController controller, BuildContext context) async {
    _controller.complete(controller);
    await _setCustomMapPin(context);
  }

  Future<void> _setMarker(LatLng position) async {
    _markers = {};
    _markers.add(
      Marker(
        markerId: MarkerId('1234'),
        position: position,
        infoWindow: InfoWindow(title: 'Location of event'),
        icon: _markerIcon,
      ),
    );
    setState(() {});
  }

  Future<void> _locationLogic() async {
    CameraPosition _newCameraPosition = CameraPosition(target: initialLatLng, zoom: 14);
    _setMarker(initialLatLng);
    await _animateCamera(_newCameraPosition);
  }

  Future<void> _animateCamera(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future<void> _setCustomMapPin(context) async {
    final ImageConfiguration _imageConfiguration = createLocalImageConfiguration(context, size: Size(30.h, 50.h));
    _markerIcon = await BitmapDescriptor.fromAssetImage(_imageConfiguration, 'assets/mapmarker.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) async {
                await _onMapCreated(controller, context);
                await _locationLogic();
              },
              markers: _markers,
            ),
          ],
        ),
      ),
    );
  }
}
