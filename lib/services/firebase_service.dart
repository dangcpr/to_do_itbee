import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
}