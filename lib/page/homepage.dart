import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _publicImageUrl;
  bool _isUploading = false;
  final SupabaseClient supabase = Supabase.instance.client;
  Future<void> _pickAndUploadToPublicBucket() async {
    final picker = ImagePicker();
    //memanggil library membuka folder dll
    final picked = await picker.pickImage(source: ImageSource.gallery);
    // jika diambil maka mempunyai nilai
    // jika tidak di ambil tdk ada nilai atau null
    if (picked == null) return;
    // karena sudah di ambil diberikan status proses uploading
    // _isuploading jadi true
    setState(() => _isUploading = true);
    // mulai persipan mengirim image
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
      final filePath = 'uploads/$fileName';
      final file = File(picked.path);
      // upload ke bucket public `public-images`
      await supabase.storage.from('my_images_bucket').upload(filePath, file);
      // ambil public URL
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
      // Final ini jika semua proses diatas sudah selesai
      // baik gagal atau berhasil lakukan printah ini
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
