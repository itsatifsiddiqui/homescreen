import 'package:homescreen/posts/Post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostsRepository {
  Firestore _firestore = Firestore.instance;

  Future<List<Post>> getPosts() async {
    Query _query = _firestore
        .collection("posts")
        .orderBy("id", descending: true)
        .limit(10);
    QuerySnapshot _querySnapshot = await _query.getDocuments();
    List<DocumentSnapshot> _snpahots = _querySnapshot.documents;
    List<Post> _posts =
        _snpahots.map((post) => Post.fromJson(post.data)).toList();
    return _posts;
  }

  Future<List<Post>> fetchMore(Post lastDocument, int limit) async {
    print(
        "=========================MORE POSTS ARE BEING FETCHED =======================");
    return Future.wait(
      await Firestore.instance
          .collection("posts")
          .orderBy("id", descending: true)
          .startAfter([lastDocument.id])
          .limit(limit)
          .getDocuments()
          .then(
            ((posts) async {
              return posts.documents.map((post) async {
                return (Post.fromJson(post.data));
              }).toList();
            }),
          ),
    );
  }
}
