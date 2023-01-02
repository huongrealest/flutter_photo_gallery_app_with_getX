import 'package:flutter/material.dart';
import 'package:gallery_package/module/album_selection/album_selection_controller.dart';
import 'package:gallery_package/module/album_selection/album_selection_mbs.dart';
import 'package:gallery_package/module/image_selection/image_selection_controller.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../widget/image_item_widget.dart';

class ImageSelectionScreen extends StatelessWidget {
  const ImageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlbumSelectionController>(
      init: AlbumSelectionController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Obx(
            () => InkWell(
              onTap: () {
                Get.bottomSheet(
                  AlbumSelectionMbs(
                    controller: controller,
                  ),
                  isScrollControlled: true,
                  ignoreSafeArea: false,
                  backgroundColor: Colors.transparent,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(controller.album.value?.name ?? ''),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
        body: controller.obx(
          (album) => album == null
              ? const SizedBox.shrink()
              : GetBuilder<ImageSelectionController>(
                  init: ImageSelectionController(),
                  builder: (image) => image.obx(
                    (images) => images == null
                        ? const SizedBox()
                        : SmartRefresher(
                            onLoading: image.loadMore,
                            controller: image.refresher,
                            onRefresh: image.reload,
                            enablePullDown: true,
                            enablePullUp: true,
                            child: GridView.custom(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              childrenDelegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  final AssetEntity entity = images[index];
                                  return ImageItemWidget(
                                    key: ValueKey<int>(index),
                                    entity: entity,
                                    option: const ThumbnailOption(
                                        size: ThumbnailSize.square(200)),
                                  );
                                },
                                childCount: images.length,
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
                ),
        ),
      ),
    );
  }
}
