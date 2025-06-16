import 'package:cocteles_app/features/livestreams/models/livestream_model.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:get/get.dart';

class LiveSessionsRepository {
  final UserController userController = Get.find<UserController>();

  Future<List<LivestreamModel>> fetchActive() async {
    const _base = 'api/v1/livesession';
    final raw = await AppHttpHelper.get('$_base?active=true', null);
    print(raw);
    final list = (raw['sessions'] as List<dynamic>);
    return list
        .map((e) => LivestreamModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LivestreamModel> create({
    required String title,
  }) async {
    final currentUserId = userController.user.value.id;

    const _base = 'api/v1/livesession';

    final body = {'user_id': currentUserId, 'title': title};
    final raw = await AppHttpHelper.post(_base, body, null);
    final jsonMap = raw;
    return LivestreamModel.fromJson(jsonMap);
  }
}
