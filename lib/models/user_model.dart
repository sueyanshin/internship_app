import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? profileUrl;
  final DateTime? createdAt;
  final bool isProfileCompleted;

  new({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.profileUrl,
    this.createdAt,
    this.isProfileCompleted = false,
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
      isProfileCompleted: data['isProfileCompleted'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'profileUrl': profileUrl,
    };
  }
}
