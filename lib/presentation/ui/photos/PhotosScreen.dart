import 'package:flutter/material.dart';
import 'package:post_and_comments/domain/model/Photo.dart';
import 'package:post_and_comments/di/DependencyInjection.dart';
import 'package:post_and_comments/presentation/ui/photos/PhotosViewModel.dart';

class PhotosScreen extends StatefulWidget {
  PhotosScreen({super.key});

  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final photosViewModel =
      PhotosViewModel(repository: DependencyInjection.photosRepository);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getPhotos();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _getPhotos() async {
    await photosViewModel.getPhotos();
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
          StreamBuilder<List<Photo>>(
            stream: photosViewModel.photosStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final photos = snapshot.data ?? [];
              return Expanded(
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
                      return photosViewModel.isMaxReached()
                          ? Container()
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
