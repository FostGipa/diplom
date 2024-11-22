import 'package:app/data/user/client_model.dart';
import 'package:app/data/user/volunteer_model.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveClientRecord(ClientModel user) async {
    try {
      await _db.collection("Clients").doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Что-то пошло не так';
    }
  }

  Future<void> saveVolunteerRecord(VolunteerModel user) async {
    try {
      await _db.collection("Volunteers").doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Что-то пошло не так';
    }
  }
}