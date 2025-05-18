class LivestreamModel {
  final int id;
  final int userId;
  final String title;
  final String streamKey;
  final String url;
  final DateTime startTime;
  final DateTime? endTime;

  LivestreamModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.streamKey,
    required this.url,
    required this.startTime,
    this.endTime,
  });

  factory LivestreamModel.fromJson(Map<String, dynamic> json) {
    return LivestreamModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      streamKey: json['stream_key'],
      url: json['url'],
      startTime: DateTime.parse(json['started_at']),
      endTime: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
    );
  }
}
