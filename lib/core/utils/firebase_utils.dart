import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

late CollectionReference<Map<String, dynamic>> dbUtils;

late CollectionReference<Map<String, dynamic>> dbTable;

late CollectionReference<Map<String, dynamic>> dbFixtures;

class FirebaseUtils {
  FirebaseUtils() {
    dbUtils = _firestore.collection('utils');
    dbTable = _firestore.collection('table');
    dbFixtures = _firestore.collection('fixtures');
  }
}
