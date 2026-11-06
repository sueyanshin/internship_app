import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? profileUrl;
  final DateTime? createdAt;

  new({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.profileUrl,
    this.createdAt,
  });
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: data['uid'] ?? "",
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      phone: data['phone'] ?? "",
      profileUrl: data['profileUrl'] ?? "",
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
