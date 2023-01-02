import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumSelectionController extends GetxController
    with StateMixin<List<AssetPathEntity>> {
  AlbumSelectionController() {
    _load();
  }

  final Rx<AssetPathEntity?> album = Rxn();

  _load() async {
    change([], status: RxStatus.loading());
    try {
      final result = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );
      album(result.first);
      change(result, status: RxStatus.success());
    } catch (e) {
      print(e);
    }
  }
}
