class TopLikedRecipe {
  final int id;
  final String name;
  final int totalLikes;
  final String authorUsername;

  TopLikedRecipe({
    required this.id,
    required this.name,
    required this.totalLikes,
    required this.authorUsername,
  });

  factory TopLikedRecipe.fromJson(Map<String, dynamic> json) {
    return TopLikedRecipe(
      id: json['id'],
      name: json['name'],
      totalLikes: json['total_likes'],
      authorUsername: json['author.username'],
    );
  }
}
