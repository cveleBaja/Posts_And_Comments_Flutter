import 'package:flutter/material.dart';
import 'package:post_and_comments/presentation/ui/posts/PostsViewModel.dart';
import 'package:post_and_comments/utils/Router.dart';
import 'package:go_router/go_router.dart';
import 'package:post_and_comments/domain/model/Post.dart';
import 'package:post_and_comments/domain/model/CommentsForPost.dart';
import 'package:post_and_comments/di/DependencyInjection.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSONPlaceholder App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Your App Logo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Posts'),
              onTap: () {
                GoRouter.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Photos'),
              onTap: () {
                GoRouter.of(context).pop();
                GoRouter.of(context).pushNamed(Routes.photos.name);
              },
            ),
          ],
        ),
      ),
      body: PostList(),
    );
  }
}

class PostList extends StatefulWidget {
  final postsViewModel = PostsViewModel(
      postsRepository: DependencyInjection.postsRepository,
      userRepository: DependencyInjection.userRepository);

  @override
  _PostListState createState() =>
      _PostListState(postsViewModel: postsViewModel);
}

class _PostListState extends State<PostList> {
  ScrollController _scrollController = ScrollController();
  List<Post> _posts = [];
  CommentsForPost? _commentsForPost;

  final PostsViewModel postsViewModel;

  _PostListState({required this.postsViewModel});

  @override
  void initState() {
    super.initState();
    _getPosts();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _getPosts() async {
    try {
      final posts = await postsViewModel.getPosts();
      setState(() {
        _posts.addAll(posts);
      });
    } catch (e) {
      // Log error
    }
  }

  Future<void> _getComments(int postId) async {
    try {
      final posts = await postsViewModel.getComments(postId);
      setState(() {
        _commentsForPost = CommentsForPost(postId: postId, comments: posts);
      });
    } catch (e) {
      // Log error
    }
  }

  void _scrollListener() {
    if (postsViewModel.isMaxReached()) {
      return;
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getPosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search by username',
            ),
            keyboardType: TextInputType.name,
            onSubmitted: (newValue) {
              if (newValue.isEmpty) {
                return;
              }

              _handleGetUserIdByUsername(newValue);
            },
            textInputAction: TextInputAction.go,
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _posts.length + 1,
            itemBuilder: (context, index) {
              if (index < _posts.length) {
                final post = _posts[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _getComments(post.id);
                        },
                        child: Text('See comments'),
                      ),
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed(Routes.postDetails.name, extra: post.id);
                      },
                    ),
                    _commentsForPost != null &&
                            post.id == _commentsForPost?.postId
                        ? CommentStreamWidget(
                            commentsForPost: _commentsForPost!,
                          )
                        : SizedBox.shrink(),
                  ],
                );
              } else {
                return postsViewModel.isMaxReached()
                    ? Container()
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              }
            },
          ),
        ),
      ],
    );
  }

  void _handleGetUserIdByUsername(String username) async {
    final userId = await postsViewModel.getUserIdByUsername(username);

    if (userId == null) {
      return;
    }

    setState(() {
      _posts.where((element) => element.userId == userId).toList();
    });
  }
}

class CommentStreamWidget extends StatelessWidget {
  CommentsForPost commentsForPost;

  CommentStreamWidget({required this.commentsForPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: commentsForPost.comments
            .map<Widget>(
              (comment) => ListTile(
                title: Text(comment.name),
                subtitle: Text(comment.body),
              ),
            )
            .toList(),
      ),
    );
  }
}
