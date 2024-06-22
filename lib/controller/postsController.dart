import 'package:flutter_blog_app/models/postsModel.dart';
import 'package:flutter_blog_app/service/database.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;

  final PostService postService;

  PostController(this.postService);

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  void fetchPosts() async {
    try {
      isLoading(true);
      var fetchedPosts = await postService.fetchPosts();
      posts.assignAll(fetchedPosts);
    } finally {
      isLoading(false);
    }
  }

  void addPost(Post post) async {
    try {
      var newPost = await postService.createPost(post);
      posts.add(newPost);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Search for a post by title
  void searchPost(String title) async {
    try {
      isLoading(true);
      var searchedPosts = await postService.searchPost(title);
      posts.assignAll(searchedPosts);
    } catch (e) {
      Get.snackbar('Error', 'Failed to search the posts: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
