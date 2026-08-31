/// Password Strength Level
enum PasswordStrength {
  none,
  weak,
  medium,
  strong;

  String get label {
    switch (this) {
      case PasswordStrength.none:
        return '';
      case PasswordStrength.weak:
        return 'Weak (needs numbers / symbols)';
      case PasswordStrength.medium:
        return 'Moderate (good start)';
      case PasswordStrength.strong:
        return 'Strong (secure)';
    }
  }

  double get score {
    switch (this) {
      case PasswordStrength.none:
        return 0.0;
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
    }
  }
}

/// Form Validation Utilities for Vendor Inputs
class Validators {
  Validators._();

  // Name Validation (at least 3 chars, letters/spaces only, no numbers or strange symbols)
  static String? validateName(String? value, [String fieldName = 'Full Name']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return '$fieldName must be at least 3 characters';
    }
    if (trimmed.length > 50) {
      return '$fieldName cannot exceed 50 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s.'-]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return '$fieldName can only contain alphabetic letters and spaces';
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(trimmed)) {
      return '$fieldName must contain alphabetic characters';
    }
    return null;
  }

  // Business Name Validation
  static String? validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Business Name is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Business Name must be at least 3 characters';
    }
    final businessRegex = RegExp(r"^[a-zA-Z0-9\s&.',()\-]+$");
    if (!businessRegex.hasMatch(trimmed)) {
      return 'Please enter a valid business name';
    }
    return null;
  }

  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Strict Password Strength Validation
  static String? validatePasswordStrength(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least 1 uppercase letter (A-Z)';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least 1 lowercase letter (a-z)';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 number (0-9)';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>~_+=/\-\[\]\\]').hasMatch(value)) {
      return 'Password must contain at least 1 special character (!@#\$%^&*)';
    }
    return null;
  }

  // Standard Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Password Strength Evaluator for interactive UI bars
  static PasswordStrength evaluatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;

    int points = 0;
    if (password.length >= 8) points++;
    if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) points++;
    if (RegExp(r'[0-9]').hasMatch(password)) points++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>~_+=/\-\[\]\\]').hasMatch(password)) points++;

    if (points >= 4) return PasswordStrength.strong;
    if (points >= 2) return PasswordStrength.medium;
    return PasswordStrength.weak;
  }

  // Required Field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Bangladesh (+880) 10-digit Phone Validation (e.g. 1711778889 or 01711778889)
  static String? validateBdPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');

    // Allow entering either 10 digits (e.g. 1711778889) or with leading 0 (01711778889)
    String digits = cleaned;
    if (digits.startsWith('+880')) {
      digits = digits.substring(4);
    } else if (digits.startsWith('880')) {
      digits = digits.substring(3);
    }

    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    if (digits.length != 10) {
      return 'Please enter a 10-digit number (e.g. 1711778889)';
    }

    // BD mobile operators start with 13, 14, 15, 16, 17, 18, 19
    final bdOperatorRegex = RegExp(r'^1[3-9]\d{8}$');
    if (!bdOperatorRegex.hasMatch(digits)) {
      return 'Enter a valid Bangladeshi operator number (e.g. 17XXXXXXXX)';
    }

    return null;
  }

  // Generic Phone Number Validation
  static String? validatePhone(String? value) {
    return validateBdPhone(value);
  }

  // Price Validation
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value.replaceAll(',', ''));
    if (price == null || price < 0) {
      return 'Please enter a valid price (e.g. 9.99)';
    }
    return null;
  }

  // Stock/Quantity Validation
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final qty = int.tryParse(value);
    if (qty == null || qty < 0) {
      return 'Please enter a valid whole number';
    }
    return null;
  }
}
