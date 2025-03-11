# Budget Tracker

A full-stack budget tracking application with a Flutter mobile app frontend and Laravel backend.

## Project Structure

```
budget_tracker/
├── mobile/           # Flutter mobile application
│   ├── lib/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── theme/
│   └── ...
└── backend/         # Laravel backend application
    ├── app/
    ├── config/
    ├── database/
    └── ...
```

## Features

- 📊 Track income and expenses
- 💰 Real-time balance updates
- 📱 Modern and intuitive mobile interface
- 🔒 Secure data storage
- 📈 Financial analytics and reporting
- 🎨 Customizable categories
- 🔄 Data synchronization

## Tech Stack

### Mobile App (Flutter)
- Flutter SDK
- Provider for state management
- SharedPreferences for local storage
- Google Fonts for typography
- FL Chart for data visualization
- Firebase integration for authentication

### Backend (Laravel)
- Laravel 10.x
- MySQL database
- RESTful API architecture
- JWT authentication
- Eloquent ORM

## Getting Started

### Prerequisites
- Flutter SDK
- PHP 8.1 or higher
- Composer
- MySQL

### Mobile App Setup
1. Navigate to the mobile directory:
   ```bash
   cd mobile
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   composer install
   ```
3. Set up environment variables:
   ```bash
   cp .env.example .env
   ```
4. Generate application key:
   ```bash
   php artisan key:generate
   ```
5. Run migrations:
   ```bash
   php artisan migrate
   ```
6. Start the server:
   ```bash
   php artisan serve
   ```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 