import 'package:post_and_comments/domain/model/Photo.dart';

abstract class PhotosRepository {
  Future<List<Photo>> getPhotos({int page = 0, int limit = 10});
}