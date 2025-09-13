import 'package:dio/dio.dart';
import '../models/movie_dto.dart';
import 'dio_service.dart';

class MovieService {
  final Dio _dio;
  final String apiKey;
  MovieService(DioService dioService, {required this.apiKey}) : _dio = dioService.dio;

  Future<List<MovieDto>> fetchMovies(String query) async {
    final res = await _dio.get(
      '',
      queryParameters: {'apikey': apiKey, 's': query, 'type': 'movie'},
    );
    final list = (res.data['Search'] as List?) ?? [];
    return list.map((e) => MovieDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<MovieDto> fetchMovieById(String id) async {
    final res = await _dio.get('', queryParameters: {'apikey': apiKey, 'i': id, 'plot': 'full'});
    return MovieDto.fromJson(res.data as Map<String, dynamic>);
  }
}
