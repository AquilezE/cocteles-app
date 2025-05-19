class CocktailModel {
  int? id;
  String? name;
  String? creationSteps;
  int? preparationTime;
  bool? isNonAlcoholic;
  String? alcoholType;
  String? videoUrl;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  int? userId;
  List<Map<String, dynamic>>? ingredients;
  List<Map<String, dynamic>>? comments;
  int? likes;

  CocktailModel({
    this.id,
    this.name,
    this.creationSteps,
    this.preparationTime,
    this.isNonAlcoholic,
    this.alcoholType,
    this.videoUrl,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.ingredients,
    this.comments,
    this.likes,
  });

  factory CocktailModel.fromJson(Map<String, dynamic> json) {
    return CocktailModel(
      id: json['id'],
      name: json['name'],
      creationSteps: json['creation_steps'],
      preparationTime: json['preparation_time'],
      isNonAlcoholic: json['is_non_alcoholic'],
      alcoholType: json['alcohol_type'],
      videoUrl: json['video_url'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['author']?['id'],
      ingredients: List<Map<String, dynamic>>.from(json['ingredients'] ?? []),
      comments: List<Map<String, dynamic>>.from(json['comments'] ?? []),
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "creation_steps": creationSteps,
      "preparation_time": preparationTime,
      "is_non_alcoholic": isNonAlcoholic,
      "alcohol_type": alcoholType,
      "video_url": videoUrl,
      "image_url": imageUrl,
      "user_id": userId,
      "ingredients": ingredients,
    };
  }

  static CocktailModel empty() => CocktailModel(
    id: 0,
    name: '',
    creationSteps: '',
    preparationTime: 0,
    isNonAlcoholic: false,
    alcoholType: '',
    videoUrl: '',
    imageUrl: '',
    createdAt: '',
    updatedAt: '',
    userId: 0,
    ingredients: [],
    comments: [],
    likes: 0,
  );
}