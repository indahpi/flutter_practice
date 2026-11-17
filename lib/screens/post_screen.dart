import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import 'comment_screen.dart';
import 'create_post_screen.dart';
import 'update_post_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ApiService apiService = ApiService();
  List<Post> postsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialPosts();
  }

  // Ambil data pertama kali
  void _fetchInitialPosts() async {
    try {
      List<Post> data = await apiService.fetchPosts();
      setState(() {
        postsList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  // Fungsi Refresh: menarik ulang data dari server (mereset perubahan lokal)
  void _refreshData() async {
    print("CONSOLE: Tombol refresh ditekan. Mengambil ulang data dari server...");
    setState(() => isLoading = true);
    try {
      List<Post> data = await apiService.fetchPosts();
      setState(() {
        postsList = data;
        isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data direfresh, kembali ke kondisi awal server.')),
      );
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // Fungsi Delete Post di layar secara langsung
  void _deletePost(int id) async {
    try {
      await apiService.deletePost(id);
      
      setState(() {
        // Langsung hapus item dari list state agar hilang seketika di layar
        postsList.removeWhere((post) => post.id == id);
      });

      if (!mounted) return;
      print("CONSOLE: Post ID $id telah dihapus dari layar dan server.");

      // Pop-up notifikasi sesuai permintaan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post telah terhapus.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Post'), // Judul bersih sesuai permintaan
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: _refreshData, 
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : postsList.isEmpty
              ? const Center(child: Text('Tidak ada post tersedia.'))
              : ListView.builder(
                  itemCount: postsList.length,
                  itemBuilder: (context, index) {
                    Post post = postsList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade100,
                          child: Text('${post.id}'),
                        ),
                        title: Text(
                          post.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tombol Edit / Update
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                              onPressed: () async {
                                final updatedPost = await Navigator.push<Post>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdatePostScreen(post: post),
                                  ),
                                );
                                // Jika sukses update, langsung ubah data di list layar secara real-time
                                if (updatedPost != null) {
                                  setState(() {
                                    int indexToUpdate = postsList.indexWhere((p) => p.id == updatedPost.id);
                                    if (indexToUpdate != -1) {
                                      postsList[indexToUpdate] = updatedPost;
                                    }
                                  });
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Post berhasil diperbarui di layar!')),
                                  );
                                }
                              },
                            ),
                            // Tombol Delete
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _deletePost(post.id),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Klik card untuk masuk ke detail komentar post
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(postId: post.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      // Tombol + di kanan bawah untuk menambah post baru
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          final newPost = await Navigator.push<Post>(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
          // Jika sukses membuat post, langsung masukkan ke urutan teratas list layar
          if (newPost != null) {
            setState(() {
              postsList.insert(0, newPost);
            });
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post baru berhasil ditambahkan ke layar!')),
            );
          }
        },
      ),
    );
  }
}