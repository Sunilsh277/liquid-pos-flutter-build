# Liquid POS backend URL configuration

## Confirmed from your Hercules screenshot
The Production HTTP Actions URL is:
`https://steady-warbler-507.convex.site`

This is a Convex HTTP Actions endpoint, not the normal Convex client query/mutation deployment URL. The Flutter HTTP client in this source calls `/api/query` and `/api/mutation` and validates that the configured URL is a `*.convex.cloud` URL. Do not pass the `.convex.site` URL to that client.

## Important: do not guess the client URL
The corresponding `https://steady-warbler-507.convex.cloud` URL is a plausible pairing based on the deployment name, but it has not been directly confirmed from the dashboard or tested. This project therefore leaves `CONVEX_URL` blank by default and fails safely until you provide the confirmed URL.

## Build after confirming the deployment URL
In PowerShell, substitute the exact `Deployment URL` shown in the Production deployment details:
```powershell
flutter build apk --debug --dart-define=CONVEX_URL=https://YOUR-CONFIRMED-DEPLOYMENT.convex.cloud
```

The app also needs a valid signed-in user access token. OIDC authority/client/redirect and token acceptance remain unverified. Never embed a Convex admin key, deploy key, client secret, or user access token in the app.
