import 'dart:ui';

class Utils {
  static Color hexToColor(String hexString, {double opacity = 1.0}) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16)).withOpacity(opacity);
  }
}
