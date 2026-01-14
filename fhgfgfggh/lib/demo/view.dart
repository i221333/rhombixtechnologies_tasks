import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class DemoPage extends StatelessWidget {
  DemoPage({super.key});

  final DemoLogic logic = Get.put(DemoLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Unsplash Images')),),
      body: SafeArea(
          child: Obx(() {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: logic.images.length,
              itemBuilder: (context, index) {
                final image = logic.images[index];
                final imageUrl = 'assets/$image';

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            title: const Text('Confirmation'),
                            content: const Text(
                                'Would you like to download this image?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  logic.downloadImage('https://www.bing.com/images/search?view=detailV2&ccid=B39%2b1Evw&id=0C9405AE20E0DF7F4A45D151D5BAD36A32AA99E7&thid=OIP.B39-1EvwOFXOffOfIKZT0AHaEK&mediaurl=https%3a%2f%2fmy.alfred.edu%2fzoom%2f_images%2ffoster-lake.jpg&cdnurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.077f7ed44bf03855ce7df39f20a653d0%3frik%3d55mqMmrTutVR0Q%26pid%3dImgRaw%26r%3d0&exph=3261&expw=5797&q=image&simid=607987187827766136&FORM=IRPRST&ck=05123CADFB029ABFD72A22100818E37A&selectedIndex=0&itb=0');
                                  Get.back();
                                },
                                child: const Text('Download'),
                              ),
                            ],
                          ),
                    );
                  },
                  child: GridTile(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0,),
                        child: Image(image: AssetImage(imageUrl),
                          fit: BoxFit.contain,)
                    ),
                  ),
                );
              },
            );
          })
      ),
    );
  }
}
