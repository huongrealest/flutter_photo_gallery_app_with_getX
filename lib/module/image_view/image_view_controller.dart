import 'package:gallery_package/module/image_selection/image_selection_screen.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageViewController extends GetxController
    with StateMixin<List<AssetEntity>> {
  ImageViewController() {
    _init();
  }

  _init() {
    change([], status: RxStatus.success());
  }

  navigateToPickImageScreen() {
    Get.to(() => const ImageSelectionScreen())?.then((value) {
      if (value == null || (value is List<AssetEntity>) == false) return;
      _handleWhenRecievedNewImage(value);
    });
  }

  _handleWhenRecievedNewImage(List<AssetEntity> images) {
    state?.addAll(images);
    change(state, status: RxStatus.success());
  }
}
