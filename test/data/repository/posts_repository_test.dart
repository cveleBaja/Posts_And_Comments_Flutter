import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:post_and_comments/domain/network/NetworkService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../util/test_constants.dart';
import 'package:post_and_comments/data/repository/PostsRepositoryImpl.dart';
import 'package:post_and_comments/domain/repository/PostsRepository.dart';

import 'posts_repository_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {

  late MockNetworkService mockNetworkService;
  late PostsRepository postsRepository;

  setUp(() {
    mockNetworkService = MockNetworkService();
    postsRepository = PostsRepositoryImpl(networkService: mockNetworkService);
  });

  group('getPosts', () {
    test('should return a list of posts on successful API call', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response(jsonEncode(TestConstants.fakePostsResponse), 200),
      );

      // Act
      final result = await postsRepository.getPosts(1, 10);

      // Assert
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].title, 'Post Title 1');

      verify(mockNetworkService.sendRequest(any)).called(1);
    });

    test('should throw an exception on unsuccessful API call', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response('Error', 404),
      );

      // Act and Assert
      expect(() => postsRepository.getPosts(1, 10), throwsException);
    });
  });

  group('getComments', () {
    test('should return a list of comments on successful API call', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response(jsonEncode(TestConstants.fakeCommentsResponse), 200),
      );

      // Act
      final result = await postsRepository.getComments(1);

      // Assert
      expect(result[0].id, 1);
      expect(result[0].postId, 1);

      verify(mockNetworkService.sendRequest(any)).called(1);
    });

    test('should throw an exception on unsuccessful API call', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response('Error', 404),
      );

      // Act and Assert
      expect(() => postsRepository.getComments(1), throwsException);
    });
  });

}