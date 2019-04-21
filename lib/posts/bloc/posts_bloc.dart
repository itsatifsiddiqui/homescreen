import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:homescreen/posts/Post.dart';
import 'package:homescreen/posts/posts_repository/posts_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository _postsRepository;

  PostsBloc({@required PostsRepository postsRepository})
      : assert(postsRepository != null),
        _postsRepository = postsRepository;

  @override
  PostsState get initialState => PostsUninitialized();

  @override
  Stream<PostsState> mapEventToState(
    PostsEvent event,
  ) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostsUninitialized) {
          List<Post> posts = await _postsRepository.getPosts();
          print(posts.first);
          yield PostLoaded(posts: posts, hasReachedMax: false);
        }
        if (currentState is PostLoaded) {
          // final posts = await _fetchPosts(currentState.posts.length, 20);
          // yield posts.isEmpty
          //     ? currentState.copyWith(hasReachedMax: true)
          //     : PostLoaded(
          //         posts: currentState.posts + posts, hasReachedMax: false);
        }
      } catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostsState state) =>
      state is PostLoaded && state.hasReachedMax;
}
