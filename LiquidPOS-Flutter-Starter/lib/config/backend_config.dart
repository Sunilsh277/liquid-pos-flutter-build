/// Public runtime configuration. Values are injected with --dart-define.
/// Never place client secrets, access tokens, or Convex admin keys here.
class BackendConfig {
  const BackendConfig._();
  static const convexUrl = String.fromEnvironment(
    'CONVEX_URL',
    defaultValue: '',
  );
  /// Hercules dashboard showed https://steady-warbler-507.convex.site for HTTP Actions.
  /// The paired .convex.cloud deployment URL must be confirmed in the dashboard.
  static const oidcAuthority = String.fromEnvironment('OIDC_AUTHORITY');
  static const oidcClientId = String.fromEnvironment('OIDC_CLIENT_ID');
  static bool get hasConvexUrl => convexUrl.startsWith('https://') && convexUrl.contains('.convex.cloud');
  static bool get hasOidcConfig => oidcAuthority.startsWith('https://') && oidcClientId.isNotEmpty;
  static String get status {
    if (!hasConvexUrl) return 'Convex deployment URL not configured';
    if (!hasOidcConfig) return 'Authentication configuration incomplete';
    return 'Public configuration present; sign-in and live access must be tested';
  }
}
