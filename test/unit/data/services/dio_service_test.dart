import 'package:flutter_test/flutter_test.dart';
import 'package:movie_searcher/data/services/dio_service.dart';

void main() {
  test('DioService: configura baseUrl e timeouts', () {
    final s = DioService('https://api.example.com');
    expect(s.dio.options.baseUrl, 'https://api.example.com');
    expect(s.dio.options.connectTimeout, const Duration(seconds: 10));
    expect(s.dio.options.receiveTimeout, const Duration(seconds: 15));
  });
}
