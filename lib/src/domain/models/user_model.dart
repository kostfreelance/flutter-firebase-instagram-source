class User {
  final String id;
  final String imageUrl;
  final String imagePath;
  final String name;
  final String email;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isCurrent;
  final Object? doc;

  User({
    required this.id,
    required this.imageUrl,
    required this.imagePath,
    required this.name,
    required this.email,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.isCurrent,
    required this.doc
  });
}