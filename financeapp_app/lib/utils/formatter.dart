// Formats a double to a string in the format '€ 1.000,00'
String formatCurrency(double amount) {
  final parts = amount.toString().split('.');
  final whole = parts[0];
  final decimal = parts.length > 1 ? parts[1] : '00';
  final formattedWhole = whole.splitMapJoin(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    onMatch: (m) => '.',
  );
  return '€ $formattedWhole,${decimal.padRight(2, '0')}';
}

// Format a double to a string in the format '€ 1k'
String formatCurrencyShort(double amount) {
  if (amount < 1000) {
    final rounded = (amount / 100).round() * 100;
    return '€ ${(rounded / 1000).toStringAsFixed(1)}k'.replaceAll('.', ',');
  } else if (amount < 1000000) {
    return '€ ${(amount / 1000).toStringAsFixed(0)}k'.replaceAll('.', ',');
  } else {
    return '€ ${(amount / 1000000).toStringAsFixed(0)}M'.replaceAll('.', ',');
  }
}

// Formats a date to a string in the format 'dd MM yyyy'
String formatDateTime(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')} ${date.month.toString().padLeft(2, '0')} ${date.year}';
}

// Format a date to a string in the format 'MM/yyyy'
String formatDateTimeShort(DateTime date) {
  return '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
