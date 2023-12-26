import 'package:post_and_comments/domain/repository/PhotosRepository.dart';
import 'package:post_and_comments/domain/model/Photo.dart';
import 'dart:convert';
import 'package:post_and_comments/utils/Constants.dart';
import 'package:post_and_comments/domain/network/NetworkService.dart';

class PhotosRepositoryImpl implements PhotosRepository {

  final NetworkService _networkService;

  PhotosRepositoryImpl({required NetworkService networkService}) : _networkService = networkService;

  @override
  Future<List<Photo>> getPhotos({int page = 0, int limit = 10}) async {
    final response = await _networkService.sendRequest(Uri.parse('${Constants.BASE_URL}/photos?_page=$page&_limit=$limit'));
    if (response.statusCode >= 200 || response.statusCode <= 299) {
      final parsed = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
    }

    throw Exception('Failed to load photos');
  }
}