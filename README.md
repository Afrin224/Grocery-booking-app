# FreshMart - Grocery Booking & Delivery App 🛒🥦

A modern, responsive, full-featured Grocery Booking & Delivery application built with Flutter and Firebase, with web deployment support for Vercel and local hosting via NPM.

---

## 🌟 Features

- **Store & Catalog**: Farm-fresh groceries categorized into Vegetables, Fruits, Dairy, Meats, Carbs, Sweets, Spices, Convenience, and Hygiene products.
- **Search & Filtering**: Real-time keyword search and category chip filtering.
- **Cart & Dynamic Pricing**: Quantity steppers, dynamic subtotal calculations, and free delivery on orders over \$30.
- **Slot & Payment Booking**: Select delivery time windows (e.g., Express 30-Min Delivery, Evening Slots) and payment methods (Cash on Delivery, UPI, Cards).
- **Order Tracking & History**: Track booking status from "Confirmed" to "Packing Groceries" and "Delivered".
- **Custom Shopping List**: Add personal grocery checklist items with custom names, quantities, and categories.
- **User Authentication**: Secure Login & Sign Up powered by Firebase Authentication with cross-platform profile photo upload support.
- **Customer Support Chat**: Live messaging with FreshMart Customer Support via Cloud Firestore.
- **Cross-Platform**: Supports Web, Android, iOS, macOS, Windows, and Linux.

---

## 🚀 Quick Start with NPM

Install dependencies and launch the web version of the grocery booking app:

```bash
# 1. Install npm packages
npm install

# 2. Build the Flutter Web application
npm run build

# 3. Launch the local web server
npm start
# App will be live at: http://localhost:3000
```

### Additional NPM Scripts:
- `npm run serve` — Serves `build/web` on port 3000
- `npm run launch` — Launches the app directly in Google Chrome via Flutter
- `npm run launch:web` — Launches the web server on port 8080
- `npm test` — Runs Flutter unit and widget tests

---

## 📱 Quick Start with Flutter CLI

```bash
# 1. Get dependencies
flutter pub get

# 2. Run static analysis
flutter analyze

# 3. Run test suite
flutter test

# 4. Run on Chrome
flutter run -d chrome
```

---

## 🌐 Vercel Deployment Setup

Public Vercel URL: `https://grocery-booking-order-flutter-01-ap.vercel.app/`

### Why Vercel Showed `NOT_FOUND (404)`
Previously, the repository lacked a `package.json` and `vercel.json`. Vercel looked for files at the root directory where no `index.html` existed, returning a 404 NOT_FOUND error.

### Solution Configured:
1. **`package.json`** includes a build script to compile the Flutter web app:
   ```json
   "build": "flutter build web --release"
   ```
2. **`vercel.json`** directs Vercel to serve from `build/web` and rewrites all routes to `/index.html`:
   ```json
   {
     "outputDirectory": "build/web",
     "cleanUrls": true,
     "rewrites": [
       { "source": "/(.*)", "destination": "/index.html" }
     ]
   }
   ```
3. When pushed to GitHub, Vercel will trigger a deployment and serve the built Flutter web app properly at `https://grocery-booking-order-flutter-01-ap.vercel.app/`.
