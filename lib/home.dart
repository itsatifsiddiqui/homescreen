import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homescreen/authentication/authentication.dart';
import 'package:homescreen/posts/Post.dart';
import 'package:homescreen/posts/bloc/bloc.dart';
import 'package:homescreen/posts/posts_repository/posts_repository.dart';

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
  PostsRepository _postsRepository;
  PostsBloc _postsBloc;

  @override
  void initState() {
    _postsRepository = PostsRepository();
    _postsBloc = PostsBloc(postsRepository: _postsRepository);
    _postsBloc.dispatch(Fetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsEvent, PostsState>(
      bloc: _postsBloc,
      builder: (BuildContext context, PostsState state) {
        print("POSTS STATE IS ${state.toString()}");
        if (state is PostsUninitialized)
          return Center(child: CircularProgressIndicator());
        if (state is PostLoaded)
          return Scaffold(
            appBar: AppBar(
              title: Text("POSTS"),
            ),
            body: ListView(
              children: state.posts.map((post) {
                return PostItem(
                  post: post,
                );
              }).toList(),
            ),
          );

        return Scaffold(
          appBar: AppBar(
            title: Text("HOME"),
          ),
          body: Column(
            children: <Widget>[
              Text(widget.user.displayName),
              RaisedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).dispatch(
                    LoggedOut(),
                  );
                },
                child: Text("LOGOUT"),
              )
            ],
          ),
        );
      },
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;

  PostItem({@required this.post, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Material(
        // elevation: post.isOpened ? 0.0 : 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(
              post.images.first,
              fit: BoxFit.fitHeight,
            ),
            Container(
              height: mq.height / 2.2,
              child: 
                  //   child: post.isOpened
                  //       ? Stack(
                  //           fit: StackFit.passthrough,
                  //           children: <Widget>[
                  //             InkWell(
                  //               onTap: () => openImage(context),
                  //               child: Container(child: buildImage()),
                  //             ),
                  //             Align(
                  //               alignment: Alignment.topLeft,
                  //               child: IconButton(
                  //                 iconSize: 30,
                  //                 splashColor: Colors.black,
                  //                 icon: Icon(Icons.arrow_back),
                  //                 onPressed: () {
                  //                   if (post.isOpened) post.isOpened = false;
                  //                   Navigator.pop(context);
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //       : buildImage(),
                  // ),
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
            ),
          ],
        ),
      ),
    );
  }
}
