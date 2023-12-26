import 'package:post_and_comments/domain/repository/PhotosRepository.dart';
import 'package:post_and_comments/domain/model/Photo.dart';

class PhotosViewModel {

  final PhotosRepository _repository;

  int _currentPage = 1;
  int _limit = 10;
  bool _maxReached = false;

  PhotosViewModel({required PhotosRepository repository}) : _repository = repository;

  Future<List<Photo>> getPhotos() async {
    try {
      final photos = await _repository.getPhotos(page: _currentPage, limit: _limit);
      _maxReached = photos.isEmpty;
      _currentPage++;

      return photos;
    } catch (e) {
      throw e;
    }
  }

  void updateLimit(int newLimit) {
    _limit = newLimit;
  }

  bool isMaxReached() => _maxReached;
}