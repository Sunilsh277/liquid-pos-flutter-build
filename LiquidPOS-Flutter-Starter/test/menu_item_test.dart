import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_pos_flutter/models/cart_line.dart';
import 'package:liquid_pos_flutter/models/menu_item.dart';

void main() {
  test('maps a Convex menu item using integer paise', () {
    final item = MenuItem.fromJson({
      '_id': 'menuItems:abc',
      'categoryId': 'menuCategories:xyz',
      'name': 'Filter Coffee',
      'priceCents': 3500,
      'isAvailable': true,
      'variants': [{'name': 'Large', 'priceCents': 4500}],
      'addOns': [{'name': 'Extra shot', 'priceCents': 1000}],
    });
    expect(item.name, 'Filter Coffee');
    expect(item.pricePaise, 3500);
    expect(item.variants.single.pricePaise, 4500);
    expect(item.isAvailable, isTrue);
  });

  test('cart total uses variant and add-on prices without floating point', () {
    const item = MenuItem(
      id: 'a', categoryId: 'c', name: 'Coffee', pricePaise: 3500,
      isAvailable: true,
      variants: [MenuOption(name: 'Large', pricePaise: 4500)],
      addOns: [MenuOption(name: 'Extra shot', pricePaise: 1000)],
    );
    final line = CartLine(
      item: item,
      quantity: 2,
      selectedVariant: item.variants.single,
      selectedAddOns: [item.addOns.single],
    );
    expect(line.lineTotalPaise, 11000);
    expect(formatRupees(line.lineTotalPaise), '₹110.00');
  });
}
