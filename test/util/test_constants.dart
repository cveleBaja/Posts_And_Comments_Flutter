class TestConstants {
  static const fakePhotosResponse = [
    {
      'albumId': 1,
      'id': 1,
      'title': 'Photo 1',
      'url': 'https://example.com/photo1.jpg',
      'thumbnailUrl': 'https://example.com/photo2.jpg'
    },
    {
      'albumId': 2,
      'id': 2,
      'title': 'Photo 2',
      'url': 'https://example.com/photo2.jpg',
      'thumbnailUrl': 'https://example.com/photo2.jpg'
    },
  ];

  static const fakeUserResponse = [
    {
      'id': 1,
      'name': 'Test User',
      'username': 'testuser',
      'email': 'test@user.com',
    },
  ];

  static const fakePostsResponse = [
    {
      'userId': 1,
      'id': 1,
      'title': 'Post Title 1',
      'body': 'Post Body 1',
    },
    {
      'userId': 2,
      'id': 2,
      'title': 'Post Title 2',
      'body': 'Post Body 2',
    },
  ];

  static const fakeCommentsResponse = [
    {
      'postId': 1,
      'id': 1,
      'name': "Comment 1",
      'email': "email1@email.com",
      'body': "Comment Body 1",
    },
    {
      'postId': 1,
      'id': 2,
      'name': "Comment 2",
      'email': "email2@email.com",
      'body': "Comment Body 2",
    },
  ];
}
