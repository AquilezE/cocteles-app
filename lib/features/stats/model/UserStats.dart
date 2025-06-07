class UserStats {
  final String mes;
  final int total;

  UserStats({required this.mes, required this.total});

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      mes: json['mes'],
      total: json['total'],
    );
  }
}
