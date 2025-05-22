//
//  Generated code. Do not modify.
//  source: lib/data/services/proto/video.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class DownloadVideoRequest extends $pb.GeneratedMessage {
  factory DownloadVideoRequest({
    $core.String? name,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  DownloadVideoRequest._() : super();
  factory DownloadVideoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DownloadVideoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DownloadVideoRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadVideoRequest clone() => DownloadVideoRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadVideoRequest copyWith(void Function(DownloadVideoRequest) updates) => super.copyWith((message) => updates(message as DownloadVideoRequest)) as DownloadVideoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadVideoRequest create() => DownloadVideoRequest._();
  DownloadVideoRequest createEmptyInstance() => create();
  static $pb.PbList<DownloadVideoRequest> createRepeated() => $pb.PbList<DownloadVideoRequest>();
  @$core.pragma('dart2js:noInline')
  static DownloadVideoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DownloadVideoRequest>(create);
  static DownloadVideoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

enum DataChunkResponse_Request {
  data, 
  name, 
  notSet
}

class DataChunkResponse extends $pb.GeneratedMessage {
  factory DataChunkResponse({
    $core.List<$core.int>? data,
    $core.String? name,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  DataChunkResponse._() : super();
  factory DataChunkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataChunkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, DataChunkResponse_Request> _DataChunkResponse_RequestByTag = {
    1 : DataChunkResponse_Request.data,
    2 : DataChunkResponse_Request.name,
    0 : DataChunkResponse_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataChunkResponse', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataChunkResponse clone() => DataChunkResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataChunkResponse copyWith(void Function(DataChunkResponse) updates) => super.copyWith((message) => updates(message as DataChunkResponse)) as DataChunkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataChunkResponse create() => DataChunkResponse._();
  DataChunkResponse createEmptyInstance() => create();
  static $pb.PbList<DataChunkResponse> createRepeated() => $pb.PbList<DataChunkResponse>();
  @$core.pragma('dart2js:noInline')
  static DataChunkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataChunkResponse>(create);
  static DataChunkResponse? _defaultInstance;

  DataChunkResponse_Request whichRequest() => _DataChunkResponse_RequestByTag[$_whichOneof(0)]!;
  void clearRequest() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
