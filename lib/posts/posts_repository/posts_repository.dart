import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homescreen/posts/Post.dart';

class PostsRepository {
  Firestore _firestore = Firestore.instance;

  Future<List<Post>> getPosts() async {
    return Future.wait(
      await Firestore.instance.collection("posts").getDocuments().then(
        ((posts) async {
          return posts.documents.map((post) async {
            return Post.fromJson(post.data);
          });
        }),
      ),
    );
  }
}
