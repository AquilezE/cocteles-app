class LiveSession {
  final int userId;
  final String title;
  final String streamKey;
  final String url;
  final DateTime? startedAt;
  final DateTime? endedAt;

  LiveSession({
    required this.userId,
    required this.title,
    required this.streamKey,
    required this.url,
    this.startedAt,
    this.endedAt,
  });

  factory LiveSession.fromJson(Map<String, dynamic> json) {
    return LiveSession(
      userId: json['user_id'] as int,
      title: json['title'] as String,
      streamKey: json['stream_key'] as String,
      url: json['url'] as String,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'stream_key': streamKey,
      'url': url,
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
    };
  }
}
