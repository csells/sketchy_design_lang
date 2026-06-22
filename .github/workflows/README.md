# GitHub Actions Workflows

## Deploy Example Web App

The `deploy-web.yml` workflow automatically deploys the example web app to Firebase Hosting when:
- A new release is published on GitHub
- Manually triggered via the "Actions" tab (workflow_dispatch)

### Setup Instructions

#### 1. Create Firebase Service Account

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Project Settings** (gear icon) → **Service Accounts**
4. Click **Generate New Private Key**
5. Save the JSON file securely

#### 2. Add GitHub Secrets

Navigate to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**, then add:

**`FIREBASE_SERVICE_ACCOUNT`** (Required)
- Paste the entire contents of the service account JSON file

**`FIREBASE_PROJECT_ID`** (Required)
- Your Firebase project ID (e.g., `sketchy-design-lang`)
- Find this in Firebase Console → Project Settings

#### 3. Initialize Firebase in Example Directory

If not already done, ensure Firebase is initialized in the `example/` directory:

```bash
cd example
firebase init hosting
# Select your project
# Set public directory to: build/web
# Configure as single-page app: Yes
# Set up automatic builds: No
```

The `.firebaserc` file should be created in the `example/` directory with your project ID.

#### 4. Test the Workflow

You can test the deployment in two ways:

**Option A: Create a GitHub Release**
1. Go to your repository → **Releases** → **Draft a new release**
2. Create a tag (e.g., `v0.2.1`)
3. Publish the release
4. The workflow will trigger automatically

**Option B: Manual Trigger**
1. Go to **Actions** tab in your repository
2. Select "Deploy Example Web App"
3. Click **Run workflow**
4. Select the branch and click **Run workflow**

### Workflow Details

- **Trigger**: New release published or manual dispatch
- **Runner**: Ubuntu latest
- **Flutter Version**: latest stable (channel: stable)
- **GitHub Actions Used**:
  - `actions/checkout@v6`
  - `subosito/flutter-action@v2`
  - `FirebaseExtended/action-hosting-deploy@v0.10.0`
- **Build Command**: `flutter build web --wasm --release`
- **Deploy Target**: Firebase Hosting (live channel)

### Troubleshooting

**Build fails with dependency errors:**
- Ensure all dependencies in `example/pubspec.yaml` are up to date
- Check that the Flutter version supports WASM builds

**Deployment fails with authentication errors:**
- Verify `FIREBASE_SERVICE_ACCOUNT` secret contains valid JSON
- Ensure the service account has "Firebase Hosting Admin" role

**Web app not updating:**
- Check Firebase Hosting deployment in Firebase Console
- Clear browser cache and hard reload (Ctrl+Shift+R)
- Verify the correct Firebase project ID is used

### Manual Deployment

If you prefer to deploy manually, use the existing script:

```bash
cd example
./deploy.sh
```

This requires Firebase CLI installed and authenticated locally.