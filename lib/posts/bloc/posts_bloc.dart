import 'package:homescreen/posts/bloc/bloc.dart';
import 'package:homescreen/posts/posts_repository/posts_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostsRepository _postsRepository = PostsRepository();

  @override
  Stream<PostEvent> transform(Stream<PostEvent> events) {
    return (events as Observable<PostEvent>).debounce(Duration(seconds: 1));
  }

  @override
  get initialState => PostUninitialized();

  @override
  Stream<PostState> mapEventToState(event) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          final posts = await _postsRepository.getPosts();
          yield PostLoaded(posts: posts, hasReachedMax: false);
        }
      } catch (_) {
        yield PostError();
      }
    }
    if (event is FetchMore) {
      if (currentState is PostLoaded && !_hasReachedMax(currentState)) {
        final posts = await _postsRepository.fetchMore(
            (currentState as PostLoaded).posts.last, 5);
        print("FETCH MORE EVENT IS CALLED");

        yield posts.isEmpty
            ? (currentState as PostLoaded).copyWith(hasReachedMax: true)
            : PostLoaded(
                posts: (currentState as PostLoaded).posts + posts,
                hasReachedMax: false);
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;
}
