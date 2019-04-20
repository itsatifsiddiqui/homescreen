import 'package:equatable/equatable.dart';
import 'package:homescreen/posts/Post.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PostsState extends Equatable {
  PostsState([List props = const []]) : super(props);
}

class PostUninitialized extends PostsState {
  @override
  String toString() => 'PostUninitialized';
}

class PostError extends PostsState {
  @override
  String toString() => 'PostError';
}

class PostLoaded extends PostsState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostLoaded({
    this.posts,
    this.hasReachedMax,
  }) : super();

  PostLoaded copyWith({
    List<Post> posts,
    bool hasReachedMax,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
