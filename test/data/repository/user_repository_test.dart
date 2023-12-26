import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:post_and_comments/domain/network/NetworkService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../util/test_constants.dart';
import 'package:post_and_comments/domain/repository/UserRepository.dart';
import 'package:post_and_comments/data/repository/UserRepositoryImpl.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {

  late MockNetworkService mockNetworkService;
  late UserRepository userRepository;

  setUp(() {
    mockNetworkService = MockNetworkService();
    userRepository = UserRepositoryImpl(networkService: mockNetworkService);
  });

  group('getUserIdByUsername', () {
    test('should return user ID on successful API call', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response(jsonEncode(TestConstants.fakeUserResponse), 200),
      );

      // Act
      final result = await userRepository.getUserIdByUsername('testuser');

      // Assert
      expect(result, 1);
      verify(mockNetworkService.sendRequest(any)).called(1);
    });

    test('should return null on successful API call with no users', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response(jsonEncode([]), 200),
      );

      // Act
      final result = await userRepository.getUserIdByUsername('nonexistentuser');

      // Assert
      expect(result, null);
      verify(mockNetworkService.sendRequest(any)).called(1);
    });

    test('should throw an exception on unsuccessful API call', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response('Error', 404),
      );

      // Act and Assert
      expect(() => userRepository.getUserIdByUsername('testuser'), throwsException);
    });
  });
}