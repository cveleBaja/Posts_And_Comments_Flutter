import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:post_and_comments/domain/network/NetworkService.dart';
import 'package:post_and_comments/domain/repository/PhotosRepository.dart';
import 'package:post_and_comments/data/repository/PhotosRepositoryImpl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../util/test_constants.dart';

import 'photos_repository_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {

  late MockNetworkService mockNetworkService;
  late PhotosRepository photosRepository;

  setUp(() {
    mockNetworkService = MockNetworkService();
    photosRepository = PhotosRepositoryImpl(networkService: mockNetworkService);
  });

  group('getPhotos', () {
    test('should return a list of photos on successful API call', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response(jsonEncode(TestConstants.fakePhotosResponse), 200),
      );

      // Act
      final result = await photosRepository.getPhotos(page: 1, limit: 10);

      // Assert
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].title, 'Photo 1');
      expect(result[0].url, 'https://example.com/photo1.jpg');

      verify(mockNetworkService.sendRequest(any)).called(1);
    });

    test('should throw an exception on unsuccessful API call', () async {
      // Arrange
      when(mockNetworkService.sendRequest(any)).thenAnswer(
            (_) async => http.Response('Error', 404),
      );

      // Act and Assert
      expect(() => photosRepository.getPhotos(page: 1, limit: 10), throwsException);
    });
  });
}