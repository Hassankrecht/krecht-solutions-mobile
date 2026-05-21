abstract final class AppUtils {
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  static String truncate(String text, {int maxLength = 80}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-()]{7,15}$').hasMatch(phone);
  }
}
