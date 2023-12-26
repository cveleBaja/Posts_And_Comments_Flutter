import 'package:post_and_comments/domain/model/Comment.dart';

class CommentsForPost {
  int postId;
  List<Comment> comments;

  CommentsForPost({required this.postId, required this.comments});
}