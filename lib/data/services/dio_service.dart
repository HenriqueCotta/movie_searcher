import 'package:dio/dio.dart';

class DioService {
  final Dio dio;
  DioService(String baseUrl)
    : dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 15)));
}
