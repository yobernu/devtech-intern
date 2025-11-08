import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  // Singleton pattern (optional)
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Collections
  CollectionReference get tasksCollection => firestore.collection('tasks');
  CollectionReference get usersCollection => firestore.collection('users');

  // Example: Get current user ID
  String? get currentUserId => auth.currentUser?.uid;

  // Example: Get user-specific task collection
  CollectionReference get userTasks =>
      usersCollection.doc(currentUserId).collection('tasks');
}
