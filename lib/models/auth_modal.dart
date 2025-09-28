class AuthModal {
  final String email;

  final String name;

  final String fcmToken;

  final String createdAtDate;



  final String? id;

  const AuthModal({
    required this.name,
    required this.email,
    required this.fcmToken,
    required this.createdAtDate,
    this.id,
  });

  factory AuthModal.fromMap(Map<String, dynamic> map) {
    return AuthModal(
      name: map['name']??'',
      email: map['email']??'',
      fcmToken: map['fcm_token']??'',
      createdAtDate: map['createdAt']??'',
      id: map['uid']??'',
    );
  }

  Map<String, dynamic> toMap(String myId) {
    return {
      'name': name,
      'email': email,
      'createdAt': createdAtDate,
      'uid': myId,
      'fcm_token': fcmToken
    };
  }

   Map<String, dynamic> toMapWithoutFCMToken(String myId) {
    return {
      'name': name,
      'email': email,
      'createdAt': createdAtDate,
      'uid': myId,
    };
  }
}
