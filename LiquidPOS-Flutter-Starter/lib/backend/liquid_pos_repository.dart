import 'convex_http_client.dart';
import '../models/place_order_request.dart';

/// Function paths and arguments are taken from the supplied Liquid POS Convex source.
/// Backend authorization checks remain enforced by Convex for the signed-in user.
class LiquidPosRepository {
  LiquidPosRepository(this.client);
  final ConvexHttpClient client;

  Future<List<Map<String, dynamic>>> menuItems() async => _mapList(
      await client.query('menu/items:list'));

  /// Places a paid order through the existing backend. Convex re-reads menu
  /// prices and validates stock/choices server-side. Returns the order ID.
  Future<String> placeOrder(PlaceOrderRequest request) async {
    final result = await client.mutation('orders/mutations:place', request.toConvexArgs());
    if (result is String && result.isNotEmpty) return result;
    throw const ConvexClientException('Order was not confirmed by the backend.');
  }
  Future<List<Map<String, dynamic>>> menuCategories() async => _mapList(
      await client.query('menu/categories:list'));
  Future<List<Map<String, dynamic>>> tables() async => _mapList(
      await client.query('tables/tables:list'));
  Future<Map<String, List<Map<String, dynamic>>>> kitchenBoard() async {
    final value = await client.query('kitchen/tickets:board');
    if (value is! Map) throw const ConvexClientException('Expected a kitchen board from the backend.');
    List<Map<String, dynamic>> readColumn(String key) {
      final column = value[key];
      if (column is! List) return const [];
      return column.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return {'new': readColumn('new'), 'preparing': readColumn('preparing'), 'ready': readColumn('ready')};
  }

  Future<void> setKitchenTicketStatus(String ticketId, String status) async {
    await client.mutation('kitchen/tickets:setStatus', {'ticketId': ticketId, 'status': status});
  }

  Future<void> setTableReserved(String tableId, bool isReserved) async {
    await client.mutation('tables/tables:setReserved', {'tableId': tableId, 'isReserved': isReserved});
  }
  Future<List<Map<String, dynamic>>> recentOrders() async => _mapList(
      await client.query('orders/queries:listRecent'));
  Future<List<Map<String, dynamic>>> openOrders() async => _mapList(
      await client.query('orders/open:list'));
  Future<dynamic> inventorySummary() => client.query('inventory/summary:summary');
  Future<dynamic> salesReport(Map<String, dynamic> args) =>
      client.query('reports/sales:summary', args);

  static List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) throw const ConvexClientException('Expected a list from the Liquid POS backend.');
    return value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
