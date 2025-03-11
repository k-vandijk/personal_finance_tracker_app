String formatCurrency(double amount) {
    final parts = amount.toString().split('.');
    final whole = parts[0];
    final decimal = parts.length > 1 ? parts[1] : '00';
    final formattedWhole = whole.splitMapJoin(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      onMatch: (m) => '.',
    );
    return '€ $formattedWhole,$decimal';
  }

// Format DateTime to dd mm yyyy without using any packages
String formatDateTime(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')} ${date.month.toString().padLeft(2, '0')} ${date.year}';
}