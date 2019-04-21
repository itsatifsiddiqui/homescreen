import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homescreen/posts/Post.dart';

class PostsRepository {
  Firestore _firestore = Firestore.instance;

  Future<List<Post>> getPosts() async {
    return Future.wait(
      await _firestore.collection("posts").limit(20).getDocuments().then(
        ((posts) async {
          return posts.documents.map((post) async {
            return Post.fromJson(post.data);
          }).toList();
        }),
      ),
    );
  }

  Future<List<Post>> fetchMore(Post post, int limit) async {
    print(
        "=========================MORE POSTS ARE BEING FETCHED =======================");
    return Future.wait(
      await Firestore.instance
          .collection("posts")
          .orderBy("description", descending: true)
          .startAfter([post.description])
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
