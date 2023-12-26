import 'package:post_and_comments/domain/repository/PostsRepository.dart';
import 'package:post_and_comments/data/repository/PostsRepositoryImpl.dart';
import 'package:post_and_comments/domain/repository/PhotosRepository.dart';
import 'package:post_and_comments/domain/network/NetworkService.dart';
import 'package:post_and_comments/data/repository/PhotosRepositoryImpl.dart';
import 'package:post_and_comments/data/network/NetworkServiceImpl.dart';
import 'package:post_and_comments/domain/repository/UserRepository.dart';
import 'package:post_and_comments/data/repository/UserRepositoryImpl.dart';

class DependencyInjection {
  static NetworkService networkService = NetworkServiceImpl();
  static PostsRepository postsRepository = PostsRepositoryImpl(networkService: networkService);
  static PhotosRepository photosRepository = PhotosRepositoryImpl(networkService: networkService);
  static UserRepository userRepository = UserRepositoryImpl(networkService: networkService);
}