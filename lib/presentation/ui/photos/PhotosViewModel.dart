import 'package:post_and_comments/domain/repository/PhotosRepository.dart';
import 'package:post_and_comments/domain/model/Photo.dart';
import 'dart:async';

class PhotosViewModel {

  final PhotosRepository _repository;

  int _currentPage = 1;
  int _limit = 10;
  bool _maxReached = false;
  List<Photo> _allPhotos = [];

  final StreamController<List<Photo>> _photosController = StreamController<List<Photo>>();
  Stream<List<Photo>> get photosStream => _photosController.stream;

  PhotosViewModel({required PhotosRepository repository}) : _repository = repository;

  Future<void> getPhotos() async {
    try {
      final photos = await _repository.getPhotos(page: _currentPage, limit: _limit);
      _maxReached = photos.isEmpty;
      _currentPage++;

      _allPhotos.addAll(photos);
      _photosController.add(_allPhotos);
    } catch (e) {
      _photosController.addError(e);
    }
  }

  void updateLimit(int newLimit) {
    _limit = newLimit;
  }

  bool isMaxReached() => _maxReached;
}