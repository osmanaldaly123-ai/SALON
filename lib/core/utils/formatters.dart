import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String price(double amount, {String symbol = 'SAR'}) {
    final formatted = NumberFormat('#,##0.##').format(amount);
    return '$formatted $symbol';
  }

  static String distance(double? km) {
    if (km == null) return '';
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  static String rating(double? value) {
    if (value == null) return '—';
    return value.toStringAsFixed(1);
  }

  static String duration(int? minutes) {
    if (minutes == null) return '';
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  static String dealExpiry(DateTime? date) {
    if (date == null) return '';
    return DateFormat.yMMMd().format(date);
  }

  static String discount(double percent) {
    return '${percent.round()}%';
  }
}
