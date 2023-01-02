import 'package:flutter/material.dart';
import 'package:gallery_package/module/image_view/image_view_controller.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../widget/image_item_widget.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageViewController>(
      init: ImageViewController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('View Image'),
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              onPressed: controller.navigateToPickImageScreen,
              icon: const Icon(
                Icons.add_photo_alternate,
              ),
            ),
          ],
        ),
        body: controller.obx(
          (state) => state == null
              ? const SizedBox()
              : GridView.custom(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final AssetEntity entity = state[index];
                      return ImageItemWidget(
                        key: ValueKey<int>(index),
                        entity: entity,
                        option: const ThumbnailOption(
                            size: ThumbnailSize.square(200)),
                      );
                    },
                    childCount: state.length,
                    findChildIndexCallback: (Key key) {
                      // Re-use elements.
                      if (key is ValueKey<int>) {
                        return key.value;
                      }
                      return null;
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
