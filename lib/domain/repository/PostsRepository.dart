import 'package:post_and_comments/domain/model/Post.dart';
import 'package:post_and_comments/domain/model/Comment.dart';

abstract class PostsRepository {
  Future<List<Post>> getPosts(int page, int limit);
  Future<List<Comment>> getComments(int postId);
  Future<Post> getPost(int id);
}