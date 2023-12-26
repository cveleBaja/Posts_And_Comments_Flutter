import 'package:flutter/material.dart';
import 'package:post_and_comments/domain/model/Photo.dart';
import 'package:post_and_comments/di/DependencyInjection.dart';
import 'package:post_and_comments/presentation/ui/photos/PhotosViewModel.dart';

class PhotosScreen extends StatefulWidget {
  final photosViewModel =
      PhotosViewModel(repository: DependencyInjection.photosRepository);

  PhotosScreen({super.key});

  @override
  _PhotosScreenState createState() =>
      _PhotosScreenState(photosViewModel: photosViewModel);
}

class _PhotosScreenState extends State<PhotosScreen> {
  final PhotosViewModel photosViewModel;

  _PhotosScreenState({required this.photosViewModel});

  final ScrollController _scrollController = ScrollController();
  List<Photo> photos = [];

  @override
  void initState() {
    super.initState();
    _getPhotos();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _getPhotos() async {
    try {
      final fetchedPhotos = await photosViewModel.getPhotos();
      setState(() {
        photos.addAll(fetchedPhotos);
      });
    } catch (e) {
      print('Error fetching more photos: $e');
    }
  }

  void _scrollListener() {
    if (photosViewModel.isMaxReached()) {
      return;
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getPhotos();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Photos Screen'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter limit (10 by default)',
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (newValue) {
                  if (newValue.isEmpty) {
                    return;
                  }
                  photosViewModel.updateLimit(int.parse(newValue));
                },
                textInputAction: TextInputAction.go,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: photos.length + 1,
                itemBuilder: (context, index) {
                  if (index < photos.length) {
                    final photo = photos[index];

                    return ListTile(
                      title: Text(photo.title),
                      subtitle: Text('ID: ${photo.id}'),
                      leading: Image.network(photo.thumbnailUrl),
                    );
                  } else {
                    return photosViewModel.isMaxReached() ? Container() : const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}
