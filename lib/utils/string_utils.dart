class StringUtils {
  static final Map<String, String> replacements = {
    'á': 'as',
    'à': 'af',
    'ả': 'ar',
    'ã': 'ax',
    'ạ': 'aj',
    'â': 'aa',
    'ấ': 'as',
    'ầ': 'a',
    'ẩ': 'a',
    'ẫ': 'a',
    'ậ': 'a',
    'ǎ': 'aw',
    'ắ': 'as',
    'ằ': 'a',
    'ẳ': 'a',
    'ẵ': 'a',
    'ặ': 'a',
    'ă': 'a',
    'ó': 'o',
    'ò': 'o',
    'ỏ': 'o',
    'õ': 'o',
    'ọ': 'o',
    'ô': 'o',
    'ồ': 'o',
    'ổ': 'o',
    'ỗ': 'o',
    'ộ': 'o',
    'ơ': 'o',
    'ớ': 'o',
    'ờ': 'o',
    'ở': 'o',
    'ỡ': 'o',
    'ợ': 'o',
    'ê': 'ee',
    'ế': 'ee',
    'ể': 'ee',
    'ễ': 'ee',
    'ệ': 'ee',
  };

  static String removeVietnameseAccents(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final replacement = replacements[char];
      buffer.write(replacement ?? char); // Use original character if no replacement found
    }
    return buffer.toString();
  }
}
