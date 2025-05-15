class LivestreamModel {
  final String id;
  final String userId;
  final String title;
  final String streamKey;
  final String url;
  final DateTime startTime;
  final DateTime endTime;

  LivestreamModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.streamKey,
    required this.url,
    required this.startTime,
    required this.endTime,
  });

  factory LivestreamModel.fromJson(Map<String, dynamic> json) {
    return LivestreamModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      streamKey: json['stream_key'],
      url: json['url'],
      startTime: DateTime.parse(json['started_at']),
      endTime: DateTime.parse(json['ended_at']),
    );
  }
}
