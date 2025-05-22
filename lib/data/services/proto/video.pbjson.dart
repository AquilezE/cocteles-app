//
//  Generated code. Do not modify.
//  source: lib/data/services/proto/video.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use downloadVideoRequestDescriptor instead')
const DownloadVideoRequest$json = {
  '1': 'DownloadVideoRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `DownloadVideoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadVideoRequestDescriptor = $convert.base64Decode(
    'ChREb3dubG9hZFZpZGVvUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1l');

@$core.Deprecated('Use dataChunkResponseDescriptor instead')
const DataChunkResponse$json = {
  '1': 'DataChunkResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '9': 0, '10': 'data'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'name'},
  ],
  '8': [
    {'1': 'request'},
  ],
};

/// Descriptor for `DataChunkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataChunkResponseDescriptor = $convert.base64Decode(
    'ChFEYXRhQ2h1bmtSZXNwb25zZRIUCgRkYXRhGAEgASgMSABSBGRhdGESFAoEbmFtZRgCIAEoCU'
    'gAUgRuYW1lQgkKB3JlcXVlc3Q=');

