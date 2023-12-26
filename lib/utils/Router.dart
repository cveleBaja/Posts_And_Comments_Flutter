import 'package:go_router/go_router.dart';
import 'package:post_and_comments/presentation/ui/photos/PhotosScreen.dart';
import 'package:post_and_comments/presentation/ui/posts/PostsScreen.dart';
import 'package:post_and_comments/presentation/ui/post_details/PostDetailsScreen.dart';

enum Routes {
  postDetails,
  photos
}

extension RouteName on Routes {
  String get name {
    switch (this) {
      case Routes.postDetails:
        return "post_details";
      case Routes.photos:
        return "photos";
    }
  }
}

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      name: "/",
      path: "/",
      builder: (context, state) => const PostsScreen(),
    ),
    GoRoute(
      name: Routes.postDetails.name,
      path: "/${Routes.postDetails.name}",
      builder: (context, state) {
        final id = state.extra as int;
        return PostDetailsScreen(postId: id);
      },
    ),
    GoRoute(
      name: Routes.photos.name,
      path: "/${Routes.photos.name}",
      builder: (context, state) => PhotosScreen(),
    ),
  ],
);