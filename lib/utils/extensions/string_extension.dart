extension StringExtension on String {
  int get toInt => int.tryParse(this) ?? 0;
  double get toDouble => double.tryParse(this) ?? 0.0;

  String get isValidNum => isEmpty ? "0" : this;
}
