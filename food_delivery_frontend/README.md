# food_delivery_frontend

Cross-platform Flutter app for a food delivery experience:
- Browse restaurants
- View menus
- Add to cart and checkout
- Track order status
- Manage account and payments (placeholder)

This app uses a clean Provider-based state management and a mock ApiService for data. Replace ApiService with real HTTP calls later.

## Run

- Flutter 3.29+ and Dart 3.7+ recommended
- From this directory:

```bash
flutter pub get
flutter run
```

## Structure

- lib/
  - main.dart: Entry, providers, theme, routing
  - src/
    - app_theme.dart: Theming
    - navigation/app_router.dart: Routes
    - models/: Plain models
    - providers/: Business/state logic (Auth, Restaurants, Menu, Cart, Order)
    - services/: ApiService (mock), StorageService
    - screens/
      - onboarding/
      - auth/
      - home/
      - restaurant/
      - cart/
      - order/
      - profile/

## API Integration

Edit `src/services/api_service.dart` to connect to your backend. Current methods:
- getRestaurants
- getMenuForRestaurant
- login / register
- placeOrder
- getOrderStatus

Use environment variables via `.env` (already whitelisted in pubspec assets).

## Notes

- Payments are placeholders on the UI; integrate actual provider (e.g., Stripe) on backend and expose to mobile via APIs/SDKs.
- Order tracking uses a timer to poll the mock service.
