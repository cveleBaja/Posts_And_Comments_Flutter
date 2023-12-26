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
  Post? _post;

  @override
  void initState() {
    super.initState();
    _getPost();
  }

  Future<void> _getPost() async {
    try {
      final post = await postDetailsViewModel.getPost(widget.postId);
      setState(() {
        _post = post;
      });
    } catch (e) {
      // Log error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${_post?.title ?? ""}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Body: ${_post?.body ?? ""}'),
            const SizedBox(height: 16),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}