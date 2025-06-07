import 'user_model.dart';

class CommentModel {
  int? id;
  int? userId;
  int? cocktailId;
  String? text;
  String? createdAt;
  UserModel? author;

  CommentModel({
    this.id,
    this.userId,
    this.cocktailId,
    this.text,
    this.createdAt,
    this.author,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      cocktailId: json['cocktail_id'] as int?,
      text: json['text'] as String?,
      createdAt: json['created_at'] as String?,
      author: json['author'] != null
          ? UserModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'cocktail_id': cocktailId,
      'text': text,
      'created_at': createdAt,
      'author': author?.toJson(),
    };
  }

  static CommentModel empty() => CommentModel(
        id: 0,
        userId: 0,
        cocktailId: 0,
        text: '',
        createdAt: '',
        author: UserModel.empty(),
      );
}
