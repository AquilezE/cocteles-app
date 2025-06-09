import 'dart:async';
import 'dart:io';

import 'package:cocteles_app/data/services/bearer_token_interceptor.dart';
import 'package:cocteles_app/data/services/proto/video.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VideoService {
  final XFile? videoFile;
  final String? videoUrl;
  final String jwt;

  VideoService({this.videoFile, this.videoUrl, required this.jwt});

  var clientChannel = ClientChannel(dotenv.env['GRPC_URL']!,
      port: int.parse(dotenv.env['GRPC_PORT']!),
      options:
          const ChannelOptions(credentials: ChannelCredentials.insecure()));

  Future<XFile> startDownload(String fileName) async {
    final stub = VideoServiceClient(
      clientChannel,
      interceptors: [BearerTokenInterceptor(jwt)],
    );

    final request = DownloadVideoRequest(name: fileName);
    var file;
    if(Platform.isWindows){
      file = File('${(await getTemporaryDirectory()).path}\\$fileName');
    } else {
      file = File('${(await getTemporaryDirectory()).path}/$fileName');
    }

    final fileSink = file.openWrite();

    try {
      await for (var response in stub.downloadVideo(request)) {
        final dataChunk = response.data;
        fileSink.add(dataChunk);
      }
    } catch (e) {
      await fileSink.close();
    }

    await fileSink.close();
    await clientChannel.shutdown();
    return XFile(file.path);
  }

  Future<void> startUpload() async {
    final stub = VideoServiceClient(
      clientChannel,
      interceptors: [BearerTokenInterceptor(jwt)],
    );

    await stub.uploadVideo(_sendVideoChunks());

    await clientChannel.shutdown();
  }

  Stream<DataChunkResponse> _sendVideoChunks() async* {
    yield DataChunkResponse(name: videoUrl);
    final videoBytes = await videoFile?.readAsBytes();
    int index = 0;
    while (index < videoBytes!.length) {
      int lastIndex = index + 1024;
      if (lastIndex > videoBytes.length) lastIndex = videoBytes.length;
      final data =
          DataChunkResponse(data: videoBytes.sublist(index, lastIndex));
      yield data;
      index = lastIndex;
    }
  }
}
