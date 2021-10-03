import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_wastage/models/event.dart';
import 'package:food_wastage/models/message.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:random_string/random_string.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveNewUserData(
      {required User user,
      String role = 'unknown',
      required String username}) async {
    await _firestore.collection('users').doc(user.uid).set(
      {
        'uid': user.uid,
        'email': user.email,
        'role': role,
        'username': username,
      },
    );
  }

  Future<void> updateRole({required User user, String role = 'unknown'}) async {
    await _firestore.collection('users').doc(user.uid).update(
      {
        'role': role,
      },
    );
  }

  Future<String> getCurrentUsersRole() async {
    User _user = AuthService().getCurrentUser() as User;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(_user.uid).get();
    return snapshot.get('role');
  }

  Future<void> addNewEvent(Event event) async {
    User _user = AuthService().getCurrentUser()!;
    String _username = await FirestoreService().getCurrentUsersUsername();
    String _randomForEventID = randomNumeric(4);
    String _eventID =
        '${event.locationString.split(',').first.replaceAll(' ', '').toLowerCase()}${event.location.latitude.toString().split('.').first}${event.location.longitude.toString().split('.').first}$_randomForEventID';

    await _firestore.collection('events').doc(_eventID).set({
      'eventID': _eventID,
      'eventLocation':
          GeoPoint(event.location.latitude, event.location.longitude),
      'eventLocationString': event.locationString,
      'foodCondition': event.foodCondition,
      'note': event.note,
      'userUID': _user.uid,
      'username': _username,
      'dateAdded': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<String> getCurrentUsersUsername() async {
    User? _user = AuthService().getCurrentUser();
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(_user!.uid).get();
    return snapshot.get('username');
  }

  Future<List> getCurrentUsersEvents() async {
    User _user = AuthService().getCurrentUser()!;
    QuerySnapshot snapshot = await _firestore
        .collection('events')
        .where('userUID', isEqualTo: _user.uid)
        .get();
    return snapshot.docs;
  }

  Future<void> changeUsername(String newUsername) async {
    User _user = AuthService().getCurrentUser()!;
    await _firestore
        .collection('users')
        .doc(_user.uid)
        .update({'username': newUsername});
  }

  Future<List<FirestoreEvent>> getAllEvents() async {
    QuerySnapshot _querySnapshot = await _firestore.collection('events').get();
    List<QueryDocumentSnapshot<Object?>> _events = _querySnapshot.docs;
    List<FirestoreEvent> _firestoreEvents = [];
    _events.forEach((element) {
      FirestoreEvent _firestoreEvent =
          FirestoreEvent.fromJSON(element.data() as Map);
      _firestoreEvents.add(_firestoreEvent);
    });
    return _firestoreEvents;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getAllUsers(String type) async {
    QuerySnapshot _querySnapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: type)
        .get();
    return _querySnapshot.docs;
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Future<void> deleteEvent(String eventID) async {
    await _firestore.collection('events').doc(eventID).delete();
  }

  Future<int> getTotalEventsNumber() async {
    QuerySnapshot _querySnapshot = await _firestore.collection('events').get();
    List<QueryDocumentSnapshot<Object?>> _events = _querySnapshot.docs;
    return _events.length;
  }

  Future<String> getUsernameByUID(String uid) async {
    QuerySnapshot _querySnapshot =
        await _firestore.collection('users').where('uid', isEqualTo: uid).get();
    return (_querySnapshot.docs.first.data() as Map)['username'];
  }
}
