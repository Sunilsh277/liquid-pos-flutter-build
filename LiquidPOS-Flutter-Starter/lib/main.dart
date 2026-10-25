import 'package:flutter/material.dart';

void main() => runApp(const LiquidPosApp());

const ink = Color(0xFF17211D);
const green = Color(0xFF167A55);
const canvas = Color(0xFFF5F7F5);

class LiquidPosApp extends StatelessWidget {
  const LiquidPosApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Liquid POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(seedColor: green),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: ink),
          cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE5EAE6)))),
        ),
        home: const PosShell(),
      );
}

class PosShell extends StatefulWidget {
  const PosShell({super.key});
  @override
  State<PosShell> createState() => _PosShellState();
}

class _PosShellState extends State<PosShell> {
  int selected = 0;
  final pages = const [DashboardScreen(), RegisterScreen(), SimpleScreen(title: 'Tables', subtitle: 'Table management'), SimpleScreen(title: 'Kitchen', subtitle: 'Kitchen order queue'), SimpleScreen(title: 'Inventory', subtitle: 'Stock and ingredients'), SimpleScreen(title: 'Staff', subtitle: 'Team and permissions'), SimpleScreen(title: 'Settings', subtitle: 'Printers and app settings')];
  final labels = const ['Dashboard', 'POS Register', 'Tables', 'Kitchen', 'Inventory', 'Staff', 'Settings'];
  final icons = const [Icons.dashboard_outlined, Icons.point_of_sale, Icons.table_restaurant_outlined, Icons.soup_kitchen_outlined, Icons.inventory_2_outlined, Icons.groups_outlined, Icons.settings_outlined];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 850;
    return Scaffold(
      body: Row(children: [
        if (wide) _Sidebar(selected: selected, labels: labels, icons: icons, onSelect: (i) => setState(() => selected = i)),
        Expanded(child: Column(children: [
          _TopBar(title: labels[selected]),
          Expanded(child: IndexedStack(index: selected, children: pages)),
          if (!wide) NavigationBar(selectedIndex: selected, onDestinationSelected: (i) => setState(() => selected = i), destinations: const [NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'), NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'POS'), NavigationDestination(icon: Icon(Icons.table_restaurant_outlined), label: 'Tables'), NavigationDestination(icon: Icon(Icons.soup_kitchen_outlined), label: 'Kitchen'), NavigationDestination(icon: Icon(Icons.menu), label: 'More')]),
        ])),
      ]),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selected, required this.labels, required this.icons, required this.onSelect});
  final int selected; final List<String> labels; final List<IconData> icons; final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) => Container(width: 236, color: Colors.white, padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Padding(padding: EdgeInsets.fromLTRB(8, 12, 8, 28), child: Row(children: [Icon(Icons.local_cafe, color: green, size: 30), SizedBox(width: 10), Text('Liquid POS', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: ink))])),
    for (var i = 0; i < labels.length; i++) Padding(padding: const EdgeInsets.only(bottom: 6), child: ListTile(selected: selected == i, selectedTileColor: const Color(0xFFE8F4ED), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: Icon(icons[i], color: selected == i ? green : Colors.black54), title: Text(labels[i], style: TextStyle(fontWeight: selected == i ? FontWeight.w700 : FontWeight.w500)), onTap: () => onSelect(i))),
    const Spacer(), const Divider(), const ListTile(leading: Icon(Icons.cloud_outlined), title: Text('Backend setup pending', style: TextStyle(fontSize: 12))),
  ]));
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title}); final String title;
  @override
  Widget build(BuildContext context) => Container(height: 72, padding: const EdgeInsets.symmetric(horizontal: 24), color: Colors.white, child: Row(children: [Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ink)), const Spacer(), const Icon(Icons.circle, color: Color(0xFF30A46C), size: 10), const SizedBox(width: 8), const Text('Native Flutter preview', style: TextStyle(color: Colors.black54)), const SizedBox(width: 14), const CircleAvatar(backgroundColor: Color(0xFFE8F4ED), child: Text('LP', style: TextStyle(color: green, fontWeight: FontWeight.bold)))]));
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Good day 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ink)),
    const SizedBox(height: 6), const Text('Your restaurant at a glance', style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 22),
    LayoutBuilder(builder: (context, c) { final cols = c.maxWidth > 900 ? 4 : c.maxWidth > 540 ? 2 : 1; final stats = const [('Today sales', '₹0.00', Icons.currency_rupee), ('Orders today', '0', Icons.receipt_long_outlined), ('Open tables', '0', Icons.table_restaurant_outlined), ('Kitchen queue', '0', Icons.soup_kitchen_outlined)]; return GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: cols, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: cols == 1 ? 3.3 : 1.65, children: [for (final s in stats) Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(s.$3, color: green, size: 25), Text(s.$1, style: const TextStyle(color: Colors.black54)), Text(s.$2, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink))])))]); }),
    const SizedBox(height: 22),
    Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Native rebuild starter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('This is the first Flutter UI scaffold. It is not connected to your live Convex backend yet, and the sample metrics are placeholders.'), const SizedBox(height: 16), Wrap(spacing: 10, runSpacing: 10, children: [FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Register screen scaffold is ready for implementation.'))), icon: const Icon(Icons.point_of_sale), label: const Text('Open POS register')), OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backend connection is the next integration task.'))), icon: const Icon(Icons.cloud_sync_outlined), label: const Text('Backend integration'))])]))),
    const SizedBox(height: 20), const Text('Next build milestones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 10),
    const _Milestone(icon: Icons.restaurant_menu, title: 'Menu and cart', subtitle: 'Load menu categories and calculate order totals'), const _Milestone(icon: Icons.receipt_long, title: 'Order lifecycle', subtitle: 'Create orders and route them to kitchen/handover'), const _Milestone(icon: Icons.print_outlined, title: 'Native printer bridge', subtitle: 'Port the tested Android Bluetooth and USB implementation'),
  ]));
}

class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState() => _RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen> {
  int count = 0; final items = const [('Masala Dosa', 90.0), ('Idli (2 pcs)', 50.0), ('Paneer Wrap', 140.0), ('Filter Coffee', 35.0), ('Veg Fried Rice', 160.0), ('Fresh Lime Soda', 60.0)];
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) => Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Register preview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 5), const Text('Sample items only — live menu connection not implemented.', style: TextStyle(color: Colors.black54)), const SizedBox(height: 16), Expanded(child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: c.maxWidth > 950 ? 3 : c.maxWidth > 560 ? 2 : 1, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.6), itemCount: items.length, itemBuilder: (context, i) => Card(child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () => setState(() => count++), child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFE8F4ED), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.restaurant, color: green)), const SizedBox(width: 12), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(items[i].$1, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text('₹${items[i].$2.toStringAsFixed(2)}', style: const TextStyle(color: green, fontWeight: FontWeight.w800))])), const Icon(Icons.add_circle_outline, color: green)]))))), const SizedBox(height: 12), Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Expanded(child: Text('Sample cart items: $count', style: const TextStyle(fontWeight: FontWeight.w700))), FilledButton(onPressed: count == 0 ? null : () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order creation will be connected to Convex in the next stage.'))), child: const Text('Create order'))])))])));
}

class SimpleScreen extends StatelessWidget { const SimpleScreen({super.key, required this.title, required this.subtitle}); final String title, subtitle;
  @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Card(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.construction_outlined, size: 44, color: green), const SizedBox(height: 14), Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text('$subtitle screen scaffold. We will port the real screen and Convex operations from the source archive.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)), const SizedBox(height: 14), const Chip(label: Text('Implementation pending'))])))));
}

class _Milestone extends StatelessWidget { const _Milestone({required this.icon, required this.title, required this.subtitle}); final IconData icon; final String title, subtitle;
  @override Widget build(BuildContext context) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFFE8F4ED), child: Icon(icon, color: green)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(subtitle)));
}
