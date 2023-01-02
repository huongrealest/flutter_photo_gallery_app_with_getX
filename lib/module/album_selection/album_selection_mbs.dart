import 'package:flutter/material.dart';
import 'package:gallery_package/module/album_selection/album_selection_controller.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumSelectionMbs extends StatelessWidget {
  const AlbumSelectionMbs({
    super.key,
    required this.controller,
  });

  final AlbumSelectionController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: GetBuilder<AlbumSelectionController>(
          init: controller,
          builder: (controller) => controller.obx(
            (state) => state == null
                ? const SizedBox.shrink()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemBuilder: (context, index) {
                      final item = state[index];
                      return ListTile(
                        onTap: () {
                          controller.album(item);
                          Get.back();
                        },
                        title: Text(item.name),
                        trailing: FutureBuilder<List<AssetEntity>>(
                          future: item.getAssetListPaged(page: 0, size: 1),
                          builder: (context, snapshot) {
                            final data = snapshot.data;
                            return data != null && data.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: AssetEntityImage(
                                      data.first,
                                      isOriginal: false,
                                      fit: BoxFit.cover,
                                      height: 56,
                                      width: 56,
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemCount: state.length,
                  ),
          ),
        ),
      ),
    );
  }
}
