class PaymentMethod {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.isDefault,
  });
}
