extension DateTimeExtension on DateTime {
  /// 현재 시간으로부터 상대적인 시간을 문자열로 반환합니다.
  String toRelativeTimeString() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "$months month${months == 1 ? '' : 's'} ago";
    } else {
      final years = (difference.inDays / 365).floor();
      return "$years year${years == 1 ? '' : 's'} ago";
    }
  }
}
