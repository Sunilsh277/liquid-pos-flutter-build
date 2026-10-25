import 'menu_item.dart';

/// Cart calculations remain in integer paise to match the existing backend.
class CartLine {
  const CartLine({required this.item, this.quantity = 1, this.selectedVariant, this.selectedAddOns = const []});

  final MenuItem item;
  final int quantity;
  final MenuOption? selectedVariant;
  final List<MenuOption> selectedAddOns;

  int get unitPricePaise =>
      (selectedVariant?.pricePaise ?? item.pricePaise) +
      selectedAddOns.fold<int>(0, (sum, option) => sum + option.pricePaise);

  int get lineTotalPaise => unitPricePaise * quantity;

  CartLine withQuantity(int next) => CartLine(
        item: item,
        quantity: next,
        selectedVariant: selectedVariant,
        selectedAddOns: selectedAddOns,
      );
}

String formatRupees(int paise) => '₹${(paise / 100).toStringAsFixed(2)}';
