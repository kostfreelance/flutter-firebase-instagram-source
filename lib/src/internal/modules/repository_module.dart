import 'package:flutter_firebase_instagram/src/data/services/services.dart';
import 'package:flutter_firebase_instagram/src/data/repositories/repositories.dart';
import 'package:flutter_firebase_instagram/src/domain/repositories/repositories.dart';

abstract class RepositoryModule {
  static IAuthRepository? _authRepository;
  static IUserRepository? _userRepository;
  static IChatRepository? _chatRepository;
  static IPostRepository? _postRepository;
  static IFollowRepository? _followRepository;
  static ICommentRepository? _commentRepository;

  static IAuthRepository authRepository() {
    _authRepository ??= AuthRepository(
      AuthService()
    );
    return _authRepository!;
  }

  static IUserRepository userRepository() {
    _userRepository ??= UserRepository(
      UserService()
    );
    return _userRepository!;
  }

  static IChatRepository chatRepository() {
    _chatRepository ??= ChatRepository(
      ChatService()
    );
    return _chatRepository!;
  }

  static IPostRepository postRepository() {
    _postRepository ??= PostRepository(
      PostService()
    );
    return _postRepository!;
  }

  static IFollowRepository followRepository() {
    _followRepository ??= FollowRepository(
      FollowService()
    );
    return _followRepository!;
  }

  static ICommentRepository commentRepository() {
    _commentRepository ??= CommentRepository(
      CommentService()
    );
    return _commentRepository!;
  }
}
