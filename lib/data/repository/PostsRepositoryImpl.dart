import 'dart:convert';
import 'package:post_and_comments/domain/repository/PostsRepository.dart';
import 'package:post_and_comments/domain/model/Post.dart';
import 'package:post_and_comments/domain/model/Comment.dart';
import 'package:post_and_comments/utils/Constants.dart';
import 'package:post_and_comments/domain/network/NetworkService.dart';

class PostsRepositoryImpl implements PostsRepository {
  final NetworkService _networkService;

  PostsRepositoryImpl({required NetworkService networkService})
      : _networkService = networkService;

  @override
  Future<List<Post>> getPosts(int page, int limit) async {
    final response = await _networkService.sendRequest(
        Uri.parse('${Constants.BASE_URL}/posts?_start=$page&_limit=$limit'));

    if (response.statusCode >= 200 || response.statusCode <= 299) {
      final parsed =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      return parsed.map<Post>((json) => Post.fromJson(json)).toList();
    }

    // TODO return custom exception depending on the error code
    throw Exception('Failed to load paginated posts');
  }

  @override
  Future<List<Comment>> getComments(int postId) async {
    final response = await _networkService.sendRequest(
        Uri.parse('${Constants.BASE_URL}/comments?postId=$postId'));

    if (response.statusCode >= 200 || response.statusCode <= 299) {
      final parsed =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      return parsed.map<Comment>((json) => Comment.fromJson(json)).toList();
    }

    throw Exception('Failed to load user details');
  }

  @override
  Future<Post> getPost(int id) async {
    final response = await _networkService
        .sendRequest(Uri.parse('${Constants.BASE_URL}/posts/$id'));

    if (response.statusCode >= 200 || response.statusCode <= 299) {
      return Post.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load paginated posts');
  }
}
