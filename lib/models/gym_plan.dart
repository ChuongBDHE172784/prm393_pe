/// Gym plan: Basic (500k), Premium (1tr), VIP (2tr).
enum GymPlan {
  basic(price: 500000, label: 'Basic'),
  premium(price: 1000000, label: 'Premium'),
  vip(price: 2000000, label: 'VIP');

  const GymPlan({required this.price, required this.label});
  final int price;
  final String label;

  String get priceDisplay {
    if (price >= 1000000) return '${price ~/ 1000000}tr';
    return '${price ~/ 1000}k';
  }
}
