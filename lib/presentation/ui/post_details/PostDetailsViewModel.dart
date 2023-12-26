import 'package:post_and_comments/domain/model/Post.dart';
import 'package:post_and_comments/domain/repository/PostsRepository.dart';
import 'dart:async';

class PostDetailsViewModel {

  final PostsRepository _repository;

  final StreamController<Post> _postController = StreamController<Post>();
  Stream<Post> get postStream => _postController.stream;

  PostDetailsViewModel({required PostsRepository repository}) : _repository = repository;

  Future<void> getPost(int id) async {
    try {
      final post = await _repository.getPost(id);
      _postController.add(post);
    } catch (e) {
      _postController.addError(e);
    }
  }
}