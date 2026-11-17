import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class UpdatePostScreen extends StatefulWidget {
  final Post post;

  const UpdatePostScreen({super.key, required this.post});

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _bodyController = TextEditingController(text: widget.post.body);
  }

  void _updatePost() async {
    setState(() => _isLoading = true);

    try {
      Post updatedPost = await _apiService.updatePost(
        widget.post.id,
        _titleController.text,
        _bodyController.text,
      );

      if (!mounted) return;
      print("CONSOLE: Post ID ${widget.post.id} berhasil diperbarui di layar.");

      // Mengembalikan objek yang sudah di-update ke PostScreen agar langsung berubah di list layar
      Navigator.pop(context, updatedPost);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post ID: ${widget.post.id}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Edit Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Edit Konten',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: _isLoading ? null : _updatePost,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Post', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}