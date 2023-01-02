import 'dart:async';

import 'package:gallery_package/module/album_selection/album_selection_controller.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ImageSelectionController extends GetxController
    with StateMixin<List<AssetEntity>> {
  final albumController = Get.find<AlbumSelectionController>();

  late final StreamSubscription _listenAlbumChanged;

  final refresher = RefreshController();

  ImageSelectionController() {
    _load();
    _listenAlbumChanged = albumController.album.listen(
      (_) {
        _load();
      },
    );
  }

  reload() async {
    final album = albumController.album.value;
    if (album == null) return;
    _page = 0;
    final result = await _addData(album);
    result.removeWhere((e) => e.type != AssetType.image);
    _page++;
    change(result, status: RxStatus.success());
    refresher.refreshCompleted();
  }

  int _page = 0;

  _load() async {
    final album = albumController.album.value;
    if (album == null) return;
    _page = 0;
    change(state, status: RxStatus.loading());
    final result = await _addData(album);
    result.removeWhere((e) => e.type != AssetType.image);
    _page++;
    change(result, status: RxStatus.success());
  }

  loadMore() async {
    final album = albumController.album.value;
    if (album == null) return;
    final result = await _addData(album);
    result.removeWhere((e) => e.type != AssetType.image);
    if (result.isEmpty) {
      refresher.loadNoData();
    } else {
      _page++;
      state?.addAll(result);
      change(state, status: RxStatus.success());
      refresher.loadComplete();
    }
  }

  Future<List<AssetEntity>> _addData(AssetPathEntity album) =>
      album.getAssetListPaged(
        page: _page,
        size: 60,
      );

  @override
  void dispose() {
    _listenAlbumChanged.cancel();
    super.dispose();
  }
}
