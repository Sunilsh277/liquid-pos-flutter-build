# One backend detail to verify

Your screenshot shows `https://steady-warbler-507.convex.site` as the **HTTP Actions URL**. Open the same Production deployment details and find the field labelled **Deployment URL** (not HTTP Actions URL). Copy the exact `*.convex.cloud` value into the build command. This avoids accidentally shipping a guessed URL.

After that, the build must still be compiled and tested. This workspace does not have Flutter/Dart installed, so no APK or successful build is claimed.
