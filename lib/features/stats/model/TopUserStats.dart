class TopUserStats {
  final int userId;
  final int recetasCreadas;
  final Author author;

  TopUserStats({
    required this.userId,
    required this.recetasCreadas,
    required this.author,
  });

  factory TopUserStats.fromJson(Map<String, dynamic> json) {
    return TopUserStats(
      userId: json['user_id'],
      recetasCreadas: json['recetas_creadas'],
      author: Author.fromJson(json['author']),
    );
  }
}

class Author {
  final int id;
  final String username;

  Author({
    required this.id,
    required this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      username: json['username'],
    );
  }
}
