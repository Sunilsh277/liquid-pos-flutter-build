import 'cart_line.dart';

/// Builds the exact argument shape accepted by convex/orders/mutations.ts.
/// The backend remains authoritative for pricing; the client sends menu choices,
/// never a client-computed unit price.
class PlaceOrderRequest {
  const PlaceOrderRequest({
    required this.orderType,
    required this.lines,
    required this.paymentMethod,
    this.tableId,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.guests,
    this.note,
    this.discount = const {'kind': 'none'},
    this.tipPaise = 0,
    this.packagingPaise,
    this.settledPaise,
    this.paymentSplits,
  });

  final String orderType; // dine_in | takeaway | delivery
  final List<CartLine> lines;
  final String paymentMethod; // cash | upi | card | other | due
  final String? tableId;
  final String? customerName;
  final String? customerPhone;
  final String? deliveryAddress;
  final int? guests;
  final String? note;
  final Map<String, dynamic> discount;
  final int tipPaise;
  final int? packagingPaise;
  final int? settledPaise;
  final List<Map<String, dynamic>>? paymentSplits;

  Map<String, dynamic> toConvexArgs() {
    if (lines.isEmpty) throw ArgumentError('Add at least one item.');
    if (orderType == 'dine_in' && (tableId == null || tableId!.isEmpty)) {
      throw ArgumentError('Choose a table for a dine-in order.');
    }
    if (orderType == 'delivery') {
      if ((customerName ?? '').trim().isEmpty) throw ArgumentError('Add the customer name for delivery.');
      if (_digits(customerPhone ?? '').length < 10) throw ArgumentError('Add a valid customer phone number.');
    }
    if (paymentMethod == 'due') {
      if ((customerName ?? '').trim().isEmpty) throw ArgumentError('Add a customer name for a pay-later order.');
      if (_digits(customerPhone ?? '').length < 10) throw ArgumentError('Add a valid customer phone number for a pay-later order.');
    }
    if (lines.length > 50) throw ArgumentError('An order can contain at most 50 lines.');
    if (tipPaise < 0) throw ArgumentError('Tip cannot be negative.');

    return <String, dynamic>{
      'orderType': orderType,
      if ((customerName ?? '').trim().isNotEmpty) 'customerName': customerName!.trim(),
      if (guests != null && guests! > 0) 'guests': guests,
      if ((note ?? '').trim().isNotEmpty) 'note': note!.trim(),
      if ((customerPhone ?? '').trim().isNotEmpty) 'customerPhone': customerPhone!.trim(),
      if ((deliveryAddress ?? '').trim().isNotEmpty) 'deliveryAddress': deliveryAddress!.trim(),
      if (tableId != null && tableId!.isNotEmpty) 'tableId': tableId,
      'lines': lines.map((line) => <String, dynamic>{
        'itemId': line.item.id,
        if (line.selectedVariant != null) 'variantName': line.selectedVariant!.name,
        'addOnNames': line.selectedAddOns.map((e) => e.name).toList(),
        'quantity': line.quantity,
      }).toList(),
      'discount': discount,
      'tipCents': tipPaise,
      if (packagingPaise != null) 'packagingCents': packagingPaise,
      'paymentMethod': paymentMethod,
      if (paymentSplits != null) 'paymentSplits': paymentSplits,
      if (settledPaise != null) 'settledCents': settledPaise,
    };
  }

  static String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');
}
