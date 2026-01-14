import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';


import 'state.dart';

class DemoLogic extends GetxController {
  var images = ['airpods.png', 'controller.png', 'iphone13.png', 'iphone15promax.png', 'macbookair.png', 'xbox.png'].obs;
  final dio = Dio();

  Future<void> fetchImages() async {
    String url = 'https://api.unsplash.com/photos/random?count=15&client_id=YOUR_ACCESS_KEY';

    try {
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        images.value = response.data;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> downloadImage(String imageUrl) async {
    try {
      // 1. Download image bytes using Dio
      final dio = Dio();
      final response = await dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to download image');
      }

      final bytes = response.data!;

      // 2. Get temp directory
      final dir = await getTemporaryDirectory();
      final String filename = 'downloaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String localPath = '${dir.path}/$filename';

      // 3. Write to file
      final file = File(localPath);
      await file.writeAsBytes(bytes);

      // 4. Ask user to save via flutter_file_dialog
      final params = SaveFileDialogParams(sourceFilePath: localPath);
      final savedPath = await FlutterFileDialog.saveFile(params: params);

      if (savedPath != null) {
        Get.snackbar("Image Saved to ", savedPath);
      } else {
        Get.snackbar('Save Cancelled', '');
      }
    } catch (e) {
      print('Error downloading image: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  final DemoState state = DemoState();
}
