import 'package:flutter/material.dart';
import 'package:post_and_comments/presentation/ui/post_details/PostDetailsViewModel.dart';
import 'package:post_and_comments/di/DependencyInjection.dart';
import 'package:post_and_comments/domain/model/Post.dart';

class PostDetailsScreen extends StatefulWidget {
  final int postId;

  const PostDetailsScreen({super.key, required this.postId});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final postDetailsViewModel =
      PostDetailsViewModel(repository: DependencyInjection.postsRepository);

  @override
  void initState() {
    super.initState();
    _getPost();
  }

  Future<void> _getPost() async {
    await postDetailsViewModel.getPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: StreamBuilder<Post>(
        stream: postDetailsViewModel.postStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final post = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${post?.title ?? ""}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Body: ${post?.body ?? ""}'),
                const SizedBox(height: 16),
                // Add more details as needed
              ],
            ),
          );
        },
      ),
    );
  }
}
