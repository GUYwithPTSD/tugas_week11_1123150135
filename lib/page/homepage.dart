import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SupabaseClient supabase = Supabase.instance.client;

  String? _publicImageUrl;
  bool _isUploading = false;

  Future<void> _pickAndUploadToPublicBucket() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
      final filePath = 'uploads/$fileName';
      final bytes = await picked.readAsBytes();

      // final file = File(picked.path);

      await supabase.storage
          .from('my_images_bucket')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      final publicUrl = supabase.storage
          .from('my_images_bucket')
          .getPublicUrl(filePath);

      setState(() {
        _publicImageUrl = publicUrl;
      });
    } catch (e) {
      debugPrint('Error upload: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal upload: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Supabase Image Upload")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isUploading) const LinearProgressIndicator(),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isUploading ? null : _pickAndUploadToPublicBucket,
              child: const Text('Pilih & Upload Gambar'),
            ),

            const SizedBox(height: 24),

            if (_publicImageUrl != null) ...[
              const Text(
                'Gambar dari Public URL:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.network(_publicImageUrl!, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 8),
              // SelectableText(
              //   _publicImageUrl!,
              //   style: const TextStyle(fontSize: 12),
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
