class UserCredentials {

  final String email;
  final String username;
  final String role;
  String jwt;


  UserCredentials({
    required this.email,
    required this.username,
    required this.role,
    required this.jwt,
  });

  Map<String,dynamic> toJson(){
    return {
      'email': email,
      'username': username,
      'role': role,
      'jwt': jwt,
    };
  }

  factory UserCredentials.fromJson(Map<String,dynamic> json){
    return UserCredentials(
      email: json['email'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      jwt: json['jwt'] as String,
    );
  }

}