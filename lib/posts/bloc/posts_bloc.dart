import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  @override
  PostsState get initialState => PostUninitialized();

  @override
  Stream<PostsState> mapEventToState(
    PostsEvent event,
  ) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          // final posts = await _fetchPosts(0, 20);
          // yield PostLoaded(posts: posts, hasReachedMax: false);
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
