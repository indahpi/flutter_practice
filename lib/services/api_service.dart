import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/album_model.dart';
import '../models/photo_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Fetch daftar Post
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      // print("Sukses ambil data posts!");
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat post');
    }
  }

  // Fetch komentar secara dinamis berdasarkan postId
  Future<List<Comment>> fetchComments(int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/comments'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat komentar untuk post $postId');
    }
  }

  // Fetch daftar Album
  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$baseUrl/albums'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Album.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat album');
    }
  }


  Future<Album> createAlbum(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/albums'),
      headers: <String, String> {
        'Content-Type': 'application/json; character=UTF-8',
      },
      body: json.encode({ 'title': title }),
    );
  

    if (response.statusCode == 201) {
      return Album.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal membuat album');
    }
  }

  // Fetch daftar Photo
  Future<List<Photo>> fetchPhotos(int albumId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/albums/$albumId/photos'),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Photo.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat foto untuk album $albumId');
    }
  }
}
