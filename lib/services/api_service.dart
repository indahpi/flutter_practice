import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/comment_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET: Ambil semua post
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      print("CONSOLE: Sukses ambil data posts!");
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      print("CONSOLE: Gagal memuat data posts!");
      throw Exception('Gagal memuat post');
    }
  }

  // POST: Buat post baru
  Future<Post> createPost(String title, String body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      print("CONSOLE: Sukses membuat post baru (CREATED)!");
      return Post.fromJson(json.decode(response.body));
    } else {
      print("CONSOLE: Gagal membuat post.");
      throw Exception('Gagal membuat post.');
    }
  }

  // PUT: Update post
  Future<Post> updatePost(int id, String title, String body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 200) {
      print("CONSOLE: Sukses memperbarui post ID $id (UPDATED)!");
      return Post.fromJson(json.decode(response.body));
    } else {
      print("CONSOLE: Gagal memperbarui post ID $id.");
      throw Exception('Gagal memperbarui post.');
    }
  }

  // DELETE: Hapus post
  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print("CONSOLE: Post dengan ID $id berhasil dihapus dari server (DELETED)!");
    } else {
      print("CONSOLE: Gagal menghapus post ID $id.");
      throw Exception('Gagal menghapus post.');
    }
  }

  // GET: Komentar berdasarkan postId
  Future<List<Comment>> fetchComments(int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/comments'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      print("CONSOLE: Sukses mengambil komentar untuk post ID $postId");
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat komentar untuk post $postId');
    }
  }
}