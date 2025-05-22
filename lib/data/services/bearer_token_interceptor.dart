import 'dart:async';
import 'package:grpc/grpc.dart';

class BearerTokenInterceptor extends ClientInterceptor {
  final String token;

  BearerTokenInterceptor(this.token);

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request,
      CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    options = options.mergedWith(CallOptions(metadata: {
      'authorization': 'Bearer $token',
    }));
    return super.interceptUnary(method, request, options, invoker);
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method,
      Stream<Q> requests,
      CallOptions options,
      ClientStreamingInvoker<Q, R> invoker) {
    options = options.mergedWith(CallOptions(metadata: {
      'authorization': 'Bearer $token',
    }));
    return super.interceptStreaming(method, requests, options, invoker);
  }
}
