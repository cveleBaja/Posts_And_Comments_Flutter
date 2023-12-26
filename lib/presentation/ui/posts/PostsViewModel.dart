import 'package:post_and_comments/domain/repository/PostsRepository.dart';
import 'package:post_and_comments/domain/model/Post.dart';
import 'package:post_and_comments/domain/model/Comment.dart';
import 'package:post_and_comments/domain/repository/UserRepository.dart';

class PostsViewModel {
  final PostsRepository postsRepository;
  final UserRepository userRepository;

  int _currentPage = 0;
  int _limit = 10;
  bool _maxReached = false;

  PostsViewModel({required this.postsRepository, required this.userRepository});

  Future<List<Post>> getPosts() async {
    try {
      final posts = await postsRepository.getPosts(_currentPage * _limit, _limit);
      _currentPage++;
      _maxReached = posts.isEmpty;

      return posts;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Comment>> getComments(int postId) async {
    try {
      return await postsRepository.getComments(postId);
    } catch (e) {
      throw e;
    }
  }

  Future<int?> getUserIdByUsername(String username) async {
    try {
      return await userRepository.getUserIdByUsername(username);
    } catch (e) {
      return null;
    }
  }

  bool isMaxReached() => _maxReached;
}
