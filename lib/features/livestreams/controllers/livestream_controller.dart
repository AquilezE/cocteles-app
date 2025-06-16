import 'package:cocteles_app/data/repositories/live_sessions/live_sessions_repository.dart';
import 'package:cocteles_app/features/livestreams/models/livestream_model.dart';
import 'package:get/get.dart';

class LivestreamController extends GetxController {
  final LiveSessionsRepository _repo = LiveSessionsRepository();

  final RxList<LivestreamModel> livestreams = <LivestreamModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    try {
      isLoading.value = true;
      final List<LivestreamModel> list = await _repo.fetchActive();
      livestreams.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar transmisiones');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<LivestreamModel?> createSession(String title) async {
    try {
      isLoading.value = true;
      final session = await _repo.create(title: title);
      livestreams.insert(0, session);
      return session;
    } catch (e) {
      Get.snackbar('Error', '$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
