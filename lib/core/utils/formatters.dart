import 'package:intl/intl.dart';

/// Common Formatting Utilities for Vendor App
class Formatters {
  Formatters._();

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormatter = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 1,
  );

  static final NumberFormat _numberFormatter = NumberFormat.decimalPattern();

  // Currency Formatting
  static String formatCurrency(double amount) {
    return _currencyFormatter.format(amount);
  }

  static String formatCompactCurrency(double amount) {
    return _compactCurrencyFormatter.format(amount);
  }

  static String formatNumber(num number) {
    return _numberFormatter.format(number);
  }

  // Date & Time Formatting
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(dateTime);
    }
  }

  // Order ID Formatter
  static String formatOrderId(String orderId) {
    if (orderId.length > 8) {
      return '#${orderId.substring(0, 8).toUpperCase()}';
    }
    return '#${orderId.toUpperCase()}';
  }
}
