import 'package:cpad_assignment/services/firebase_service.dart';
import 'package:uuid/uuid.dart';
import 'package:cpad_assignment/models/concern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConcernService {
  static CollectionReference concernCollectionReference =
      FirebaseFirestore.instance.collection('concern');

  static Future<Concerns> fetchConcerns() async {
    Concerns _concernList = Concerns();
    try {
      List<Map<String, dynamic>> _consolidatedDocs = [];

      await concernCollectionReference.get().then((docs) {
        if (docs.size > 0) {
          docs.docs.forEach((doc) {
            _consolidatedDocs.add(doc.data() as Map<String, dynamic>);
          });
          _concernList = Concerns.fromJson(_consolidatedDocs);
        }
      });
    } catch (e) {
      print(e);
      throw e;
    }
    return _concernList;
  }

  static Future<Concerns> fetchConcernsByUser() async {
    Concerns concernList = Concerns();

    try {
      List<Map<String, dynamic>> _consolidatedDocs = [];

      await concernCollectionReference
          .where("userID", isEqualTo: FirebaseService.currentUserId)
          .get()
          .then((docs) {
        if (docs.size > 0) {
          docs.docs.forEach((doc) {
            _consolidatedDocs.add(doc.data() as Map<String, dynamic>);
          });
          concernList = Concerns.fromJson(_consolidatedDocs);
        }
      });
    } catch (e) {
      throw e;
    }
    return concernList;
  }

  static Future<Concern> saveConcern({required Concern concern}) async {
    var uuid = Uuid();
    String id = uuid.v1();
    concern.id = id;

    try {
      await concernCollectionReference.doc(id).set(concern.toJson(id: id));
    } catch (e) {
      print(e);
      throw e;
    }
    return concern;
  }

  static Future<void> deleteConcernById({required String id}) async {
    try {
      concernCollectionReference.doc(id).delete();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<void> setResolved(
      {required String id, required bool isResolved}) async {
    try {
      concernCollectionReference
          .doc(id)
          .set({'isResolved': isResolved}, SetOptions(merge: true));
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
