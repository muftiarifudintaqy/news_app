import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article.dart';
import '../controllers/news_controller.dart';
import '../pages/detail_page.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final bool showFavoriteButton;
  final NewsController controller = Get.find<NewsController>();

  NewsCard({required this.article, this.showFavoriteButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(
            () => DetailPage(article: article),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 300),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(context),
                SizedBox(width: 16),
                _buildContentSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Hero(
      tag: 'news_image_${article.url}',
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: article.urlToImage.isNotEmpty
              ? Image.network(
                  article.urlToImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder(context);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildImagePlaceholder(context);
                  },
                )
              : _buildImagePlaceholder(context),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : Colors.grey[100],
      child: Icon(
        Icons.image_rounded,
        size: 32,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[600]
            : Colors.grey[400],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSourceInfo(context),
          SizedBox(height: 8),
          _buildTitle(context),
          SizedBox(height: 8),
          _buildDescription(context),
          SizedBox(height: 12),
          _buildMetaInfo(context),
        ],
      ),
    );
  }

  Widget _buildSourceInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.red[900]?.withOpacity(0.3)
            : Colors.red[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        article.source,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.red[300]
              : Colors.red[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      article.title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: Theme.of(context).textTheme.titleLarge?.color ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[900]),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      article.description,
      style: TextStyle(
        fontSize: 13,
        height: 1.4,
        color: Theme.of(context).textTheme.bodyMedium?.color ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[300]
                : Colors.grey[600]),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 14,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[400]
              : Colors.grey[500],
        ),
        SizedBox(width: 4),
        Text(
          _formatDate(article.publishedAt),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }



  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}