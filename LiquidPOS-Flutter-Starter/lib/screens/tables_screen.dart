import 'package:flutter/material.dart';
import '../backend/liquid_pos_repository.dart';

/// Live table floor list. Inject a repository created with a signed-in session.
class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key, required this.repository});
  final LiquidPosRepository repository;
  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late Future<List<Map<String, dynamic>>> _future;
  final Set<String> _busy = {};
  @override
  void initState() { super.initState(); _future = widget.repository.tables(); }
  void _reload() => setState(() => _future = widget.repository.tables());
  String _id(Map<String, dynamic> row) => (row['_id'] ?? row['id'] ?? '').toString();

  Future<void> _toggleReserved(Map<String, dynamic> table) async {
    final id = _id(table);
    if (id.isEmpty) return;
    setState(() => _busy.add(id));
    try {
      await widget.repository.setTableReserved(id, !(table['isReserved'] == true));
      if (!mounted) return;
      _reload();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Table updated.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not update table: $e')));
    } finally { if (mounted) setState(() => _busy.remove(id)); }
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async => _reload(),
    child: FutureBuilder<List<Map<String, dynamic>>>(future: _future, builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
      if (snapshot.hasError) return _ErrorState(message: snapshot.error.toString(), onRetry: _reload);
      final tables = snapshot.data ?? const [];
      if (tables.isEmpty) return ListView(children: const [SizedBox(height: 110), Icon(Icons.table_restaurant_outlined, size: 52), SizedBox(height: 12), Center(child: Text('No tables returned by the backend.'))]);
      return GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.sizeOf(context).width > 900 ? 4 : MediaQuery.sizeOf(context).width > 560 ? 2 : 1, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.55), itemCount: tables.length, itemBuilder: (context, index) {
        final table = tables[index]; final id = _id(table); final draft = table['draft'] is Map ? Map<String,dynamic>.from(table['draft'] as Map) : null;
        final reserved = table['isReserved'] == true; final occupied = draft != null;
        final lines = draft?['lines'] is List ? (draft!['lines'] as List).length : 0;
        return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text((table['name'] ?? 'Table').toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), Icon(occupied ? Icons.people_alt : reserved ? Icons.event_seat : Icons.table_restaurant, color: occupied ? Colors.orange : reserved ? Colors.blueGrey : Colors.green)]),
          const SizedBox(height: 8), Text('${table['seats'] ?? '?'} seats • ${occupied ? 'Occupied' : reserved ? 'Reserved' : 'Available'}'),
          if (occupied) Text('$lines order line(s)${draft?['customerName'] == null ? '' : ' • ${draft!['customerName']}'}', maxLines: 1, overflow: TextOverflow.ellipsis),
          const Spacer(), Align(alignment: Alignment.centerRight, child: OutlinedButton(onPressed: occupied || id.isEmpty || _busy.contains(id) ? null : () => _toggleReserved(table), child: _busy.contains(id) ? const SizedBox(width: 16,height:16,child:CircularProgressIndicator(strokeWidth:2)) : Text(reserved ? 'Unreserve' : 'Reserve'))),
        ])));
      });
    }),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message; final VoidCallback onRetry;
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: [const Icon(Icons.cloud_off_outlined, size: 48), const SizedBox(height: 12), const Text('Could not load live tables', textAlign: TextAlign.center, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center), const SizedBox(height: 12), Center(child: OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')))]);
}
