class UserModel {

  int? id;
  String? username;
  String? email;
  String? profilePicture;
  String? bio;
  String? role;
  String? password;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.profilePicture,
    this.bio,
    this.role,
    this.password,
  });
  
  static UserModel empty() => UserModel(
    id: 0,
    username: '',
    email: '',
    profilePicture: '',
    bio: '',
    role: '',
    password: '',
  );

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile_picture_path': profilePicture,
      'bio': bio,
      'role': role,
      if (password != null) 'password': password,
    };
  }

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profile_picture_path'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String?,
    );
  }
}