// Small formatting and validation helpers shared by multiple screens.
abstract final class AppUtils {
  // Formats a number as a fixed two-decimal currency string.
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  // Shortens long text for compact UI areas.
  static String truncate(String text, {int maxLength = 80}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }

  // Basic email format check for contact forms.
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Basic phone format check that allows spaces, dashes, and country codes.
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-()]{7,15}$').hasMatch(phone);
  }
}
