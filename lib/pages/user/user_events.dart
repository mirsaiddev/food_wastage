import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_wastage/helpers/navigator_helper.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'view_map.dart';

class UserEvents extends StatefulWidget {
  const UserEvents({Key? key}) : super(key: key);

  @override
  _UserEventsState createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirestoreService().getCurrentUsersEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: (snapshot.data as List).length,
                itemBuilder: (context, index) {
                  var _event = (snapshot.data as List<QueryDocumentSnapshot<Object?>>)[index].data() as Map;
                  Timestamp _dateAdded = _event['dateAdded'];
                  DateTime _dateAddedDateTime = _dateAdded.toDate();
                  String _eventLocationString = _event['eventLocationString'];
                  GeoPoint _eventLocation = _event['eventLocation'];
                  String _eventID = _event['eventID'];
                  int _foodCondition = _event['foodCondition'];
                  String _note = _event['note'];

                  return Card(
                    child: ExpansionTile(
                      title: Text(_eventLocationString),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                          child: Column(
                            children: [
                              InfoRow(
                                infoKey: 'Date added',
                                value:
                                    '${_dateAddedDateTime.day}-${_dateAddedDateTime.month}-${_dateAddedDateTime.year} ${_dateAddedDateTime.minute}:${_dateAddedDateTime.hour}',
                              ),
                              InfoRow(
                                infoKey: 'Event ID',
                                value: _eventID,
                              ),
                              InfoRow(
                                infoKey: 'Food Condition',
                                value: _foodCondition.toString(),
                              ),
                              _note.characters.length < 1
                                  ? SizedBox()
                                  : InfoRow(
                                      infoKey: 'Note',
                                      value: _note,
                                    ),
                              TextButton(
                                  onPressed: () {
                                    Go.push(context, ViewMap(initialLatLng: LatLng(_eventLocation.latitude, _eventLocation.longitude)));
                                  },
                                  child: Text('View location in map')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String infoKey, value;

  const InfoRow({Key? key, required this.infoKey, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$infoKey :'),
          Text(value),
        ],
      ),
    );
  }
}
