class UserRegistration {
  final String? username;
  final String? email;
  final String? password;
  final String? role;

  UserRegistration({
    required this.username,
    required this.email,
    required this.password,
    this.role = 'user'
    
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    return UserRegistration(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'user',
    );
  }
}
