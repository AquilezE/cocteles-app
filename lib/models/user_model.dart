class UserModel {

  int? id;
  String? username;
  String? email;
  String? profilePicture;
  String? bio;
  String? role;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.profilePicture,
    this.bio,
    this.role,
  });
  
  static UserModel empty() => UserModel(
    id: 0,
    username: '',
    email: '',
    profilePicture: '',
    bio: '',
    role: '',
  );

  //Aqui no se como putas le puedas meter lo de la contraseña
  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'bio': bio,
      'role': role,
    };
  }

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String?,
    );
  }
}