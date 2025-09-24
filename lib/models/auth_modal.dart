class AuthModal {
  final String email;

  final String name;

  final String createdAtDate;



  final String? id;

  const AuthModal({
    required this.name,
    required this.email,
    
    required this.createdAtDate,
    this.id,
  });

  factory AuthModal.fromMap(Map<String, dynamic> map) {
    return AuthModal(
      name: map['name']??'',
      email: map['email']??'',
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
    };
  }
}
