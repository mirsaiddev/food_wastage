import 'dart:async';
import 'package:food_wastage/services/location_permission_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/helpers/navigator_helper.dart';
import 'package:food_wastage/widgets/build_default_button.dart';
import 'package:food_wastage/widgets/build_place_picker_bar_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PlacePickerPage extends StatefulWidget {
  const PlacePickerPage({Key? key}) : super(key: key);

  @override
  _PlacePickerPageState createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  List<Placemark> _placemarks = [];
  String _barText = 'Please long-press to place that you want select';
  late BitmapDescriptor _markerIcon;
  late LatLng _position;
  late LocationData _currentPosition;

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(36.778259, -119.417931),
    zoom: 7,
  );

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
        infoWindow: InfoWindow(title: 'New Place Here'),
        icon: _markerIcon,
      ),
    );
    _position = position;
    _placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    _barText = '${_placemarks.first.administrativeArea}, ${_placemarks.first.street}';
    setState(() {});
  }

  void _apply() {
    Go.pop(context, [_position, _barText]);
  }

  Future<void> _locationLogic() async {
    await LocationService().locationPermissions();
    _currentPosition = await LocationService().getLocation();
    LatLng _newLatLng = LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    CameraPosition _newCameraPosition = CameraPosition(target: _newLatLng, zoom: 14);
    _setMarker(_newLatLng);
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
  void initState() {
    super.initState();
    _locationLogic();
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
              },
              markers: _markers,
              onLongPress: _setMarker,
            ),
            BuildPlacePickerBarText(barText: _barText),
            _markers.length > 0
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30.w),
                      child: BuildDefaultButton(text: Text('Apply Selected Place'), onPressed: _apply, color: MyColors.red),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
