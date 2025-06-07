class AlcoholStats {
  final String alcoholType;
  final int total;

  AlcoholStats({required this.alcoholType, required this.total});

  factory AlcoholStats.fromJson(Map<String, dynamic> json) {
    return AlcoholStats(
      alcoholType: json['alcohol_type'],
      total: json['total'],
    );
  }
}
