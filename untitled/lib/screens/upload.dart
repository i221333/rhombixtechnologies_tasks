import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/provider.dart';
import '../utils/theme.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _imagePath;
  String _selectedCategory = 'Digital Painting';
  bool _isUploading = false;

  final List<String> _categories = [
    'Digital Painting', '3D Art', 'Photography', 'Illustration',
    'Abstract', 'Pixel Art', 'Vector Art',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- Logic ---

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildImagePickerSheet(context),
    );

    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920, // Optimization for DB storage
      );
      if (image != null) {
        setState(() => _imagePath = image.path);
      }
    }
  }

  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate() || _imagePath == null) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide an image and a title.')),
      );
      return;
    }

    setState(() => _isUploading = true);
    HapticFeedback.mediumImpact();

    final provider = context.read<AppProvider>();
    final success = await provider.createArtwork(
      title: _titleController.text.trim(),
      imagePath: _imagePath!,
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
    );

    if (!mounted) return;
    setState(() => _isUploading = false);

    if (success) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 64, color: Colors.greenAccent),
              const SizedBox(height: 16),
              const Text('Masterpiece Published', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text('Your art is now live in the gallery.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  _resetForm();
                  // Optional: use a callback to tell the Home screen to switch tabs to Gallery
                },
                child: const Text('Back to Gallery'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() => _imagePath = null);
  }

  // --- UI Components ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NEW UPLOAD', style: TextStyle(letterSpacing: 1.5, fontSize: 16, fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildImageSlot(theme),
              const SizedBox(height: 32),
              _buildCategorySelector(theme),
              const SizedBox(height: 32),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Artwork Title'),
                validator: (v) => v!.isEmpty ? 'Give your art a name' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'The story behind the piece...'),
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(theme),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlot(ThemeData theme) {
    return GestureDetector(
      onTap: _pickImage,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          clipBehavior: Clip.antiAlias,
          child: _imagePath != null
              ? Image.file(File(_imagePath!), fit: BoxFit.cover)
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              const Text('Tap to choose artwork', style: TextStyle(color: Colors.white38)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CATEGORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white30)),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat;
              final catColor = AppTheme.getCategoryColor(cat);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (val) => setState(() => _selectedCategory = cat),
                  selectedColor: catColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? catColor : Colors.white38,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(color: isSelected ? catColor : Colors.white10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppTheme.gradients['midnight'],
        borderRadius: BorderRadius.circular(18),
      ),
      child: ElevatedButton(
        onPressed: _isUploading ? null : _handleUpload,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: _isUploading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('PUBLISH TO GALLERY', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
      ),
    );
  }

  Widget _buildImagePickerSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _pickerBtn(context, Icons.camera_alt_rounded, 'Camera', ImageSource.camera),
          _pickerBtn(context, Icons.photo_library_rounded, 'Gallery', ImageSource.gallery),
        ],
      ),
    );
  }

  Widget _pickerBtn(BuildContext context, IconData icon, String label, ImageSource source) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.05),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}