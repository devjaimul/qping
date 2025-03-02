import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qping/Controller/message/media_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';

class MediaScreen extends StatelessWidget {
  final String conversationId;
  final String type;
  final MediaController controller = Get.put(MediaController());

  MediaScreen({super.key, required this.conversationId, required this.type});

  @override
  Widget build(BuildContext context) {
    // Trigger the initial fetch if the list is empty.
    if (controller.mediaImages.isEmpty) {
      controller.fetchMediaImages(conversationId: conversationId,type: type);
    }
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: 'Media', fontSize: 18.sp),
      ),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoading.value &&
                  scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
                controller.fetchMediaImages(conversationId: conversationId,type: type);
              }
              return false;
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
              ),
              itemCount: controller.mediaImages.length,
              itemBuilder: (context, index) {
                final imageUrl = controller.mediaImages[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to PhotoViewScreen to enable zoom/pan.
                    Get.to(() => PhotoViewScreen(imageUrl: imageUrl));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}


class PhotoViewScreen extends StatelessWidget {
  final String imageUrl;
  const PhotoViewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
