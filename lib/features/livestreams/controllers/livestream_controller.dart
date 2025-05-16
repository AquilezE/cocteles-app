import 'package:cocteles_app/features/livestreams/models/livestream_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivestreamController extends GetxController {
  final RxList<LivestreamModel> livestreams = <LivestreamModel>[
    LivestreamModel(
      id: '1',
      userId: 'user1',
      title: 'Live Cooking Show',
      streamKey: 'abc123',
      url: 'https://example.com/stream1',
      startTime: DateTime.now().subtract(Duration(hours: 1)),
      endTime: DateTime.now().add(Duration(hours: 1)),
    ),
    LivestreamModel(
      id: '2',
      userId: 'user2',
      title: 'Cocktail Masterclass',
      streamKey: 'def456',
      url: 'https://example.com/stream2',
      startTime: DateTime.now().subtract(Duration(hours: 2)),
      endTime: DateTime.now().add(Duration(hours: 2)),
    ),
    LivestreamModel(
      id: '3',
      userId: 'user3',
      title: 'Mixology 101',
      streamKey: 'ghi789',
      url: 'https://example.com/stream3',
      startTime: DateTime.now().subtract(Duration(minutes: 30)),
      endTime: DateTime.now().add(Duration(hours: 3)),
    ),
  ].obs;
  final RxBool isLoading = false.obs;
}
