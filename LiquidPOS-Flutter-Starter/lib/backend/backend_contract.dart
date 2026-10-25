/// Backend operation map derived from the supplied Liquid POS Convex source.
///
/// This file deliberately does not pretend to connect yet. Convex functions
/// require the real deployment URL plus a compatible client/auth transport.
/// The original app uses Convex JS reactive queries and Hercules OIDC; do not
/// replace it with guessed HTTP endpoints or an unauthenticated REST client.
class BackendContract {
  const BackendContract._();

  static const menu = <String>[
    'menu/items:list',
    'menu/categories:list',
    'menu/settings:get',
  ];

  static const orders = <String>[
    'orders/open:list',
    'orders/queries:*',
    'orders/mutations:*',
    'orders/payments:*',
    'orders/history:*',
  ];

  static const tables = <String>[
    'tables/tables:list',
    'tables/tables:getForRegister',
    'tables/tables:saveDraft',
    'tables/tables:sendTableOrder',
    'tables/tables:setReserved',
  ];

  static const kitchen = <String>[
    'kitchen/tickets:board',
    'kitchen/tickets:setStatus',
  ];

  static const inventory = <String>[
    'inventory/catalog:list',
    'inventory/levels:*',
    'inventory/materials:*',
    'inventory/purchases:*',
    'inventory/recipes:*',
    'inventory/usage:*',
    'inventory/waste:*',
    'inventory/summary:summary',
    'inventory/report:report',
  ];

  static const printing = <String>[
    'printing/printers:*',
    'printing/assignments:*',
    'printing/settings:get/save',
    'printing/jobs:*',
  ];

  static const other = <String>[
    'staff/members:*',
    'staff/access:me',
    'reports/sales:*',
    'reports/aggregate:*',
    'dues/dues:*',
  ];
}
