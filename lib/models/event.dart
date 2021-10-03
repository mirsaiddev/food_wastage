import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  late final LatLng location;
  late String locationString = 'Click to pick location';
  late int foodCondition = 3;
  late String note = '';
}

class FirestoreEvent {
  late Timestamp dateAdded;
  late String eventID;
  late GeoPoint eventLocation;
  late String eventLocationString;
  late int foodCondition;
  late String note;
  late String userUID;
  late String username;

  FirestoreEvent({
    required this.dateAdded,
    required this.eventID,
    required this.eventLocation,
    required this.eventLocationString,
    required this.foodCondition,
    required this.note,
    required this.userUID,
    required this.username,
  });

  DateTime get dateAddedDateTime => dateAdded.toDate();
  LatLng get eventLocationLatLng => LatLng(eventLocation.latitude, eventLocation.longitude);

  FirestoreEvent.fromJSON(Map<dynamic, dynamic> json) {
    dateAdded = json['dateAdded'];
    eventID = json['eventID'];
    eventLocation = json['eventLocation'];
    eventLocationString = json['eventLocationString'];
    foodCondition = json['foodCondition'];
    note = json['note'];
    userUID = json['userUID'];
    username = json['username'];
  }
}
