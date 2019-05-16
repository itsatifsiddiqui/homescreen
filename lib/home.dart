import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homescreen/authentication/authentication.dart';
import 'package:homescreen/posts/Post.dart';
import 'package:homescreen/posts/bloc/bloc.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;
  final UserRepository repository;

  const Home({
    Key key,
    @required this.user,
    @required this.repository,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PostBloc _postBloc;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  _HomeState() {
    _postBloc = PostBloc();
    _scrollController.addListener(_onScroll);
    _postBloc.dispatch(Fetch());
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postBloc.dispatch(FetchMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _postBloc,
      builder: (BuildContext context, PostState state) {
        if (state is PostUninitialized) {
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is PostError) {
          return Center(
            child: Text('failed to fetch posts'),
          );
        }
        if (state is PostLoaded) {
          if (state.posts.isEmpty) {
            return Center(
              child: Text('no posts'),
            );
          }
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.linked_camera),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .dispatch(LoggedOut());
                  },
                )
              ],
            ),
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.posts.length
                    ? BottomLoader()
                    : PostItem(post: state.posts[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              controller: _scrollController,
            ),
          );
        }
      },
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;

  PostItem({@required this.post, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    post.isOpened = false;
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Material(
        elevation: post.isOpened ? 0.0 : 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: mq.height / 2.2,
              child: post.isOpened
                  ? Stack(
                      fit: StackFit.passthrough,
                      children: <Widget>[
                        InkWell(
                          // onTap: () => openImage(context),
                          child: Container(
                              child: Image.network(
                            post.images.first,
                            fit: BoxFit.fitHeight,
                          )),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            iconSize: 30,
                            splashColor: Colors.black,
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              if (post.isOpened) post.isOpened = false;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        Center(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: post.images.first,
                          ),
                        ),
                      ],

                      // post.images.first,
                      // fit: BoxFit.fitHeight,
                    ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                    child: IconButton(
                      icon: Icon(
                        (post.isFavourite)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 28,
                        color: Theme.of(context).accentColor,
                      ),
                      // onPressed: onPressed,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      post.likes.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                          fontFamily: "sans"),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        size: 28,
                        color: Colors.blue,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      post.seen.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                          fontFamily: "sans"),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: OutlineButton(
                          borderSide: BorderSide.none,
                          splashColor: Colors.blue,
                          onPressed: () {},
                          child: Text(
                            "SHARE",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'sans',
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
