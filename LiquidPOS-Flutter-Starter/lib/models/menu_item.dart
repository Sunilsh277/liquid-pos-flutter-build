/// Typed menu models matching convex/schema/menu.ts.
/// Convex stores prices as integer paise (despite the legacy `priceCents` name).
class MenuOption {
  const MenuOption({required this.name, required this.pricePaise});

  final String name;
  final int pricePaise;

  factory MenuOption.fromJson(Map<String, dynamic> json) => MenuOption(
        name: json['name'] as String? ?? '',
        pricePaise: _asInt(json['priceCents']),
      );
}

class MenuCategory {
  const MenuCategory({required this.id, required this.name, required this.sortOrder});

  final String id;
  final String name;
  final int sortOrder;

  factory MenuCategory.fromJson(Map<String, dynamic> json) => MenuCategory(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        name: json['name'] as String? ?? 'Unnamed category',
        sortOrder: _asInt(json['sortOrder']),
      );
}

class MenuItem {
  const MenuItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.pricePaise,
    required this.isAvailable,
    this.description,
    this.imageUrl,
    this.variants = const [],
    this.addOns = const [],
    this.packagingChargePaise = 0,
  });

  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final int pricePaise;
  final bool isAvailable;
  final String? imageUrl;
  final List<MenuOption> variants;
  final List<MenuOption> addOns;
  final int packagingChargePaise;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        categoryId: (json['categoryId'] ?? '').toString(),
        name: json['name'] as String? ?? 'Unnamed item',
        description: json['description'] as String?,
        pricePaise: _asInt(json['priceCents']),
        isAvailable: json['isAvailable'] as bool? ?? false,
        imageUrl: json['imageUrl'] as String?,
        variants: _options(json['variants']),
        addOns: _options(json['addOns']),
        packagingChargePaise: _asInt(json['packagingChargeCents']),
      );

  static List<MenuOption> _options(dynamic raw) => raw is List
      ? raw.whereType<Map>().map((e) => MenuOption.fromJson(Map<String, dynamic>.from(e))).toList()
      : const [];
}

int _asInt(dynamic value) => value is num ? value.round() : 0;
