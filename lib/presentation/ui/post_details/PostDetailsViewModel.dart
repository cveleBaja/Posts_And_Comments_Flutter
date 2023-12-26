import 'package:post_and_comments/domain/model/Post.dart';
import 'package:post_and_comments/domain/repository/PostsRepository.dart';
import 'dart:async';

class PostDetailsViewModel {

  final PostsRepository _repository;

  PostDetailsViewModel({required PostsRepository repository}) : _repository = repository;

  Future<Post> getPost(int id) async {
    try {
      return await _repository.getPost(id);
    } catch (e) {
      rethrow;
    }
  }
}