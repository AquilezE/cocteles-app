class UserRegistration {
  final String? username;
  final String? email;
  final String? password;
  final String? role;
  final String? profile_picture_path;
  final String? bio; 

  UserRegistration({
    required this.username,
    required this.email,
    required this.password,
    this.role = 'user',
    this.profile_picture_path,
    this.bio,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'profile_picture_path': profile_picture_path,
      'bio': bio, 
    };
  }

  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    return UserRegistration(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'user',
      profile_picture_path: json['profile_picture_path'],
      bio: json['bio'], 
    );
  }
}
