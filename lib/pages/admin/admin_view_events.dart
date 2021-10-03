import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:food_wastage/helpers/show.dart';
import 'package:food_wastage/models/event.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:food_wastage/services/shared_preferences_service.dart';
import 'package:food_wastage/widgets/build_event_info_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:food_wastage/main.dart';

class AdminViewEvents extends StatefulWidget {
  const AdminViewEvents({Key? key}) : super(key: key);

  @override
  _AdminViewEventsState createState() => _AdminViewEventsState();
}

class _AdminViewEventsState extends State<AdminViewEvents> {
  List<FirestoreEvent> _events = [];
  bool _allEventsGet = false;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  late BitmapDescriptor _markerIcon;
  late BuildEventInfoCard _eventInfoCard;
  bool _showInfoCard = false;

  Future<void> _getAllEvents() async {
    _events = await FirestoreService().getAllEvents();
    _allEventsGet = true;
    setState(() {});
  }

  Future<void> _onMapCreated(GoogleMapController controller, BuildContext context) async {
    _controller.complete(controller);
    await _setCustomMapPin(context);
    _events.forEach((element) {
      _setMarker(element);
    });
  }

  Future<void> _setMarker(FirestoreEvent event) async {
    _markers.add(
      Marker(
          markerId: MarkerId(event.eventID),
          position: event.eventLocationLatLng,
          infoWindow: InfoWindow(title: event.eventLocationString),
          icon: _markerIcon,
          onTap: () {
            _eventInfoCard = BuildEventInfoCard(
              username: event.username,
              location: event.eventLocationString,
              dateAdded: event.dateAddedDateTime.format(),
              foodCondition: event.foodCondition.toString(),
              note: event.note,
              userUID: event.userUID,
              button: TextButton(
                onPressed: () {
                  Show.dialog(
                    context,
                    AlertDialog(
                      title: Text('Warning!'),
                      content: Text('Are you sure that you want to delete this event?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                        TextButton(
                            onPressed: () async {
                              await FirestoreService().deleteEvent(event.eventID);
                              _events.removeWhere((element) => element.eventID == event.eventID);
                              _markers.removeWhere((element) => element.markerId == MarkerId(event.eventID));
                              _showInfoCard = false;
                              setState(() {});
                              Navigator.pop(context);
                              Show.snackbar(context, 'Event deleted successfully');
                            },
                            child: Text('Delete')),
                      ],
                    ),
                  );
                },
                child: Text('Delete this Event'),
              ),
            );
            _showInfoCard = true;
            setState(() {});
          }),
    );
    setState(() {});
  }

  Future<void> _setCustomMapPin(context) async {
    final ImageConfiguration _imageConfiguration = createLocalImageConfiguration(context, size: Size(30.h, 50.h));
    _markerIcon = await BitmapDescriptor.fromAssetImage(_imageConfiguration, 'assets/mapmarker.png');
  }

  @override
  void initState() {
    super.initState();
    _getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _allEventsGet
            ? Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _events.last.eventLocationLatLng,
                      zoom: 5,
                    ),
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) async {
                      await _onMapCreated(controller, context);
                    },
                    markers: _markers,
                  ),
                  _showInfoCard ? _eventInfoCard : SizedBox(),
                ],
              )
            : Center(child: CircularProgressIndicator()));
  }
}
