import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';
import '../widgets/news_card.dart';

class FavoritesPage extends StatelessWidget {
  final NewsController controller = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita Favorit'),
        actions: [
          Obx(
            () => controller.favoriteArticles.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () => _showClearAllDialog(),
                  )
                : Container(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.favoriteArticles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Belum ada berita favorit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Tambahkan berita ke favorit dengan menekan ikon hati',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: controller.favoriteArticles.length,
          itemBuilder: (context, index) {
            return NewsCard(
              article: controller.favoriteArticles[index],
              showFavoriteButton: true,
            );
          },
        );
      }),
    );
  }

  void _showClearAllDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Hapus Semua Favorit'),
        content: Text(
          'Apakah Anda yakin ingin menghapus semua berita favorit?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          TextButton(
            onPressed: () {
              controller.favoriteArticles.clear();
              Get.back();
              Get.snackbar(
                'Favorit',
                'Semua favorit telah dihapus',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Hapus', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
