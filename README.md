EcoRoute is a Flutter-based mobile application that helps users discover nearby parks and choose eco-friendly routes with real-time air quality information. Make informed decisions about your travel while considering 

environmental impact.

✨ Key Features

🗺️ Interactive Maps - Discover parks near your location with real-time navigation

🚶 Multi-Modal Routes - Choose between walking, cycling, or driving routes

🌤️ Air Quality Index - View destination AQI to make healthier travel choices

⭐ Favorites - Save your favorite parks for quick access

🔐 Authentication - Secure sign-in with email, Google, or Apple

🌓 Theme Support - Light and dark mode for comfortable viewing

🌍 Multi-Language - Currently supports English and Turkish


🛠️ Tech Stack

Frontend

Flutter - Cross-platform mobile framework

Provider - State management

Google Maps Flutter - Interactive map integration

Backend & Services

Firebase Authentication - User authentication

Cloud Firestore - Database for user data and favorites

Firebase Analytics - Usage analytics

Sentry - Error tracking and monitoring

APIs

Google Maps API - Places and Directions

OpenWeather API - Air quality data

Local Storage

Hive - Lightweight NoSQL database for offline favorites

🔑 Key Architecture Patterns

MVVM Architecture

State Management

Provider pattern for reactive state updates

Separation of UI and business logic through ViewModels

Listener-based architecture for status changes

Data Layer

Service-Repository pattern for API interactions

Local caching with Hive for offline support

Firebase for cloud synchronization

UI Components

Reusable widget components following DRY principles

Custom themed widgets for consistent design

Platform-specific adaptations (Material/Cupertino)
