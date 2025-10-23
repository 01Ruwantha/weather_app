# <p align="center"><img src="https://raw.githubusercontent.com/your-username/weather_app/main/assets/icon.png?raw=true" alt="App Logo" width="150"/></p><p align="center"><img src="https://github.com/your-username/weather_app/blob/main/assets/branding.png?raw=true" alt="branding png" width="200"/></p> <p align="center">Beautiful & Modern Weather App</p>

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![OpenWeather](https://img.shields.io/badge/OpenWeather-API-orange.svg)](https://openweathermap.org)

*A beautiful and intuitive weather app built with Flutter that provides real-time weather information with stunning visuals!*

</div>

## 🖼️ Design

<p align="center">
  <img 
  src="https://github.com/01Ruwantha/weather_app/blob/main/assets/images/Weather%20App.png?raw=true" 
  alt="Weather App Design" />
</p>

## ✨ Features

### 🌤️ Core Weather Features
- **🌍 Global City Search** - Get weather for any city worldwide
- **📊 Real-time Data** - Live weather updates from OpenWeather API
- **🕒 24-Hour Forecast** - Detailed hourly weather predictions
- **📈 Comprehensive Metrics** - Temperature, humidity, wind speed, and pressure
- **🌡️ Celsius Support** - Temperature in metric units

### 🎨 User Experience
- **📱 Beautiful UI/UX** - Modern, dark theme with Material 3 design
- **🎯 Intuitive Navigation** - Clean and user-friendly interface
- **🔄 Pull to Refresh** - Easy data refresh functionality
- **🔍 Smart Search** - Quick city search with text input
- **📱 Responsive Design** - Optimized for all screen sizes

### 🔄 Real-time Features
- **⚡ Live Updates** - Instant weather data refresh
- **🌤️ Dynamic Icons** - Weather condition-based icons
- **📅 Time-based Forecast** - Organized hourly predictions
- **📍 Location-based** - Default city with search capability

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart (3.0 or higher)
- OpenWeather API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/weather_app.git
   cd weather_app
   ```

2. **Add your API Key**
   - Get your free API key from [OpenWeatherMap](https://openweathermap.org/api)
   - Create a `.env` file in the root directory
   - Add your API key:
     ```
     WEATHER_API_KEY=your_api_key_here
     ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate app icons and splash screen**
   ```bash
   flutter pub run flutter_launcher_icons:main
   flutter pub run flutter_native_splash:create
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
weather_app/
├── 📁 android/                 # Android specific files
├── 📁 assets/                  # App assets
│   ├── icon.png               # App icon
│   ├── splash.png             # Splash screen image
│   └── branding.png           # Branding image
├── 📁 ios/                     # iOS specific files
├── 📁 lib/
│   ├── 📁 widgets/             # Reusable components
│   │   ├── additional_info_item.dart
│   │   └── hourly_forcast_item.dart
│   ├── main.dart               # App entry point
│   └── weather_screen.dart     # Main weather screen
├── 📁 linux/                   # Linux specific files
├── 📁 macos/                   # macOS specific files
├── 📁 test/                    # Test files
├── 📁 web/                     # Web specific files
├── 📁 windows/                 # Windows specific files
├── .env                        # Environment variables
└── pubspec.yaml               # Dependencies configuration
```

## 🎨 UI Components

### Custom Widgets
- **HourlyForecastItem** - Beautiful hourly forecast cards with icons
- **AdditionalInfoItem** - Clean info display for weather metrics
- **WeatherScreen** - Main screen with search and data display

### Features
- **Material 3 Design** - Modern dark theme with transparent app bar
- **Responsive Layout** - Adapts to different screen sizes
- **Smooth Animations** - Elegant transitions and loading states
- **Error Handling** - User-friendly error messages and retry options

## 🌐 API Integration

WeatherApp uses **OpenWeatherMap API** for accurate weather data:

```dart
// API integration example
Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
  final apiKey = dotenv.env['WEATHER_API_KEY'];
  final response = await http.get(
    Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric',
    ),
  );
  return jsonDecode(response.body);
}
```

**API Features:**
- 🌍 Global city coverage
- 📊 5-day weather forecast
- 🌡️ Metric units support
- ⚡ Real-time data updates
- 🔒 Secure API key management

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **OpenWeatherMap API** | Weather data provider |
| **HTTP** | API communication |
| **Intl** | Date/time formatting |
| **flutter_dotenv** | Environment variables |
| **flutter_launcher_icons** | App icon generation |
| **flutter_native_splash** | Splash screen setup |

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0
  intl: ^0.19.0
  flutter_dotenv: ^6.0.0
  flutter_native_splash: ^2.4.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  flutter_launcher_icons: ^0.14.4
```

## 🔧 Configuration

### App Icons
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon.png"
  web:
    generate: true
    image_path: "assets/icon.png"
  windows:
    generate: true
    image_path: "assets/icon.png"
  macos:
    generate: true
    image_path: "assets/icon.png"
```

### Splash Screen
```yaml
flutter_native_splash:
  android: true
  ios: true
  color: "#FFFFFF"
  image: assets/splash.png
  branding: assets/branding.png
  android_12:
    color: "#FFFFFF"
    image: assets/splash.png
    branding: assets/branding.png
```

## 🎯 Key Features Implementation

### Smart City Search
```dart
void _searchCity() {
  final city = _cityController.text.trim();
  if (city.isNotEmpty) {
    setState(() {
      _currentCity = city;
      weather = getCurrentWeather(city);
    });
  }
}
```

### Dynamic Weather Icons
```dart
IconData _getWeatherIcon(String weatherCondition) {
  switch (weatherCondition.toLowerCase()) {
    case 'clouds': return Icons.cloud;
    case 'rain': return Icons.beach_access;
    case 'clear': return Icons.wb_sunny;
    // ... more cases
  }
}
```

### Error Handling
```dart
if (snapshot.hasError) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.red),
        Text('Error', style: TextStyle(...)),
        Text(snapshot.error.toString()),
        ElevatedButton(onPressed: _refresh, child: Text('Try Again')),
      ],
    ),
  );
}
```

## 🚀 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues and pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## 🐛 Bug Reports & Feature Requests

Found a bug or have a feature request? Please let us know!

- 🐛 [Bug Reports](https://github.com/01Ruwantha/weather_app/issues)
- 💡 [Feature Requests](https://github.com/01Ruwantha/weather_app/issues)

## 🙏 Acknowledgments

- **OpenWeatherMap** - For providing reliable weather data API
- **Flutter Team** - For the amazing cross-platform framework
- **Material Design** - For the beautiful design system
- **Weather Icons** - For intuitive weather representation

---

<div align="center">

**Made with ❤️ using Flutter**

*Stay informed about the weather, beautifully!*

</div>
