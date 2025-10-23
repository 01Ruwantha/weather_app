import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forcast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  final TextEditingController _cityController = TextEditingController();
  String _currentCity = 'Horana';
  bool _isLoadingCity = true;

  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  // Initialize weather data after loading saved city
  Future<void> _initializeWeather() async {
    await _loadSavedCity();
    setState(() {
      weather = getCurrentWeather(_currentCity);
    });
  }

  // Load saved city from shared preferences
  Future<void> _loadSavedCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCity = prefs.getString('saved_city');

      if (kDebugMode) {
        print('=== SHARED PREFERENCES DEBUG ===');
        print('Loaded saved city from storage: "$savedCity"');
      }

      if (savedCity != null && savedCity.isNotEmpty) {
        if (kDebugMode) {
          print('✅ Using saved city: "$savedCity"');
        }
        setState(() {
          _currentCity = savedCity;
        });
      } else {
        if (kDebugMode) {
          print('❌ No saved city found, using default: "$_currentCity"');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading saved city: $e');
      }
    } finally {
      setState(() {
        _isLoadingCity = false;
      });
    }
  }

  // Save city to shared preferences
  Future<void> _saveCity(String city) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_city', city);
      if (kDebugMode) {
        print('=== CITY SAVED SUCCESSFULLY ===');
        print('Saved city: "$city"');
        print('===============================');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving city: $e');
      }
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
    try {
      final apiKey = dotenv.env['WEATHER_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw 'API key is missing. Please check your .env file';
      }

      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric',
        ),
      );

      if (response.statusCode != 200) {
        throw 'Failed to load weather data. Status: ${response.statusCode}';
      }

      final data = jsonDecode(response.body);

      if (data['cod'] != '200') {
        throw data['message'] ?? 'An unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw 'Failed to get weather data: $e';
    }
  }

  void _refresh() {
    setState(() {
      weather = getCurrentWeather(_currentCity);
    });
  }

  void _searchCity() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      setState(() {
        _currentCity = city;
        weather = getCurrentWeather(city);
      });
      _saveCity(city); // Save the new city
      _cityController.clear();
      FocusScope.of(context).unfocus(); // Close keyboard
    }
  }

  IconData _getWeatherIcon(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'clear':
        return Icons.wb_sunny;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'drizzle':
        return Icons.grain;
      default:
        return Icons.wb_sunny;
    }
  }

  String _getWeatherDescription(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clouds':
        return 'Cloudy';
      case 'rain':
        return 'Rainy';
      case 'clear':
        return 'Clear';
      case 'thunderstorm':
        return 'Thunderstorm';
      case 'snow':
        return 'Snowy';
      case 'drizzle':
        return 'Drizzle';
      default:
        return weatherCondition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          hintText: 'Enter city name...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.blue),
                        ),
                        onSubmitted: (_) => _searchCity(),
                      ),
                    ),
                    IconButton(
                      onPressed: _searchCity,
                      icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                      tooltip: 'Search',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Weather Data
            _isLoadingCity
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading your saved city...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : FutureBuilder(
                    future: weather,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Loading weather data...',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Error',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[300],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  snapshot.error.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: _refresh,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Try Again'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            'No weather data available',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      final data = snapshot.data!;
                      final currentWeather = data['list'][0];
                      final currentTemp =
                          currentWeather['main']['temp']?.toDouble() ?? 0.0;
                      final currentSky =
                          currentWeather['weather'][0]['main'] ?? 'Unknown';
                      final currentPressure =
                          currentWeather['main']['pressure']?.toString() ??
                              'N/A';
                      final currentWindSpeed =
                          currentWeather['wind']['speed']?.toString() ?? 'N/A';
                      final currentHumidity =
                          currentWeather['main']['humidity']?.toString() ??
                              'N/A';
                      final cityName = data['city']['name'] ?? _currentCity;
                      final country = data['city']['country'] ?? '';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main Weather Card
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.shade800,
                                    Colors.blue.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${currentTemp.toStringAsFixed(1)}°C',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Icon(
                                    _getWeatherIcon(currentSky),
                                    size: 80,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _getWeatherDescription(currentSky),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$cityName, $country',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Last searched city saved',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(255, 255, 255, 0.6),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Hourly Forecast Section
                          const Text(
                            'Hourly Forecast',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                final hourlyForecast = data['list'][index + 1];
                                final hourlySky = hourlyForecast['weather'][0]
                                        ['main'] ??
                                    'Unknown';
                                final hourlyTemp = hourlyForecast['main']
                                            ['temp']
                                        ?.toDouble() ??
                                    0.0;
                                final time =
                                    DateTime.parse(hourlyForecast['dt_txt']);

                                return HourlyForecastItem(
                                  time: DateFormat.Hm().format(time),
                                  temperature: hourlyTemp.toStringAsFixed(1),
                                  icon: _getWeatherIcon(hourlySky),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Additional Information Section
                          const Text(
                            'Additional Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            children: [
                              AdditionalInfoItem(
                                icon: Icons.water_drop,
                                label: 'Humidity',
                                value: '$currentHumidity%',
                              ),
                              const SizedBox(height: 8),
                              AdditionalInfoItem(
                                icon: Icons.air,
                                label: 'Wind Speed',
                                value: '${currentWindSpeed}m/s',
                              ),
                              const SizedBox(height: 8),
                              AdditionalInfoItem(
                                icon: Icons.compress,
                                label: 'Pressure',
                                value: '${currentPressure}hPa',
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
