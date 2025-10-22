import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';

class CategoryChips extends StatelessWidget {
  final NewsController controller = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedCategory.value == category.name;

            return Padding(
              padding: EdgeInsets.only(right: 12),
              child: _buildCategoryChip(category, isSelected),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(category, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? Colors.red[700] : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Colors.red[700]! : Colors.grey[300]!,
          width: 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: Colors.red[700]!.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.fetchNewsByCategory(category.name);
          },
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    category.icon,
                    size: 16,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
                SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                  child: Text(category.displayName),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}