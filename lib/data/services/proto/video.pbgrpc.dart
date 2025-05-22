//
//  Generated code. Do not modify.
//  source: lib/data/services/proto/video.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'video.pb.dart' as $0;

export 'video.pb.dart';

@$pb.GrpcServiceName('VideoService')
class VideoServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  static final _$downloadVideo = $grpc.ClientMethod<$0.DownloadVideoRequest, $0.DataChunkResponse>(
      '/VideoService/downloadVideo',
      ($0.DownloadVideoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DataChunkResponse.fromBuffer(value));
  static final _$uploadVideo = $grpc.ClientMethod<$0.DataChunkResponse, $0.DownloadVideoRequest>(
      '/VideoService/uploadVideo',
      ($0.DataChunkResponse value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DownloadVideoRequest.fromBuffer(value));

  VideoServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseStream<$0.DataChunkResponse> downloadVideo($0.DownloadVideoRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$downloadVideo, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.DownloadVideoRequest> uploadVideo($async.Stream<$0.DataChunkResponse> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$uploadVideo, request, options: options).single;
  }
}

@$pb.GrpcServiceName('VideoService')
abstract class VideoServiceBase extends $grpc.Service {
  $core.String get $name => 'VideoService';

  VideoServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.DownloadVideoRequest, $0.DataChunkResponse>(
        'downloadVideo',
        downloadVideo_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.DownloadVideoRequest.fromBuffer(value),
        ($0.DataChunkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DataChunkResponse, $0.DownloadVideoRequest>(
        'uploadVideo',
        uploadVideo,
        true,
        false,
        ($core.List<$core.int> value) => $0.DataChunkResponse.fromBuffer(value),
        ($0.DownloadVideoRequest value) => value.writeToBuffer()));
  }

  $async.Stream<$0.DataChunkResponse> downloadVideo_Pre($grpc.ServiceCall $call, $async.Future<$0.DownloadVideoRequest> $request) async* {
    yield* downloadVideo($call, await $request);
  }

  $async.Stream<$0.DataChunkResponse> downloadVideo($grpc.ServiceCall call, $0.DownloadVideoRequest request);
  $async.Future<$0.DownloadVideoRequest> uploadVideo($grpc.ServiceCall call, $async.Stream<$0.DataChunkResponse> request);
}
