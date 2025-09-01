import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Horana';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Weather App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: Icon(
                Icons.refresh_rounded,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            final data = snapshot.data!;
            final currentWeather = data['list'][0];
            final currentTemp = currentWeather['main']['temp'];
            final currentSky = currentWeather['weather'][0]['main'];
            final currentPusure = currentWeather['main']['pressure'];
            final currentWindSpeed = currentWeather['wind']['speed'];
            final currentHumidity = currentWeather['main']['humidity'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //main card
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    '$currentTemp °K',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Icon(
                                    currentSky == 'Clouds' ||
                                            currentSky == 'Rain'
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    size: 64,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    currentSky,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //weather forcast cards
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Hourly forcast',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       for (int i = 0; i < 39; i++)
                    //         HourlyForcastItem(
                    //           time: data['list'][i + 1]['dt'].toString(),
                    //           temprature: data['list'][i + 1]['main']['temp']
                    //               .toString(),
                    //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                    //                       'Clouds' ||
                    //                   data['list'][i + 1]['weather'][0]
                    //                           ['main'] ==
                    //                       'Rain'
                    //               ? Icons.cloud
                    //               : Icons.sunny,
                    //         ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          final hourlyForcast = data['list'][index + 1];
                          final hourlySky = hourlyForcast['weather'][0]['main'];
                          final time = DateTime.parse(hourlyForcast['dt_txt']);
                          return HourlyForcastItem(
                              time: DateFormat.Hm().format(time),
                              temprature:
                                  hourlyForcast['main']['temp'].toString(),
                              icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Additional Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    //additional information
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInforItem(
                          icon: Icons.water_drop,
                          lable: 'Humidity',
                          value: currentHumidity.toString(),
                        ),
                        AdditionalInforItem(
                          icon: Icons.air,
                          lable: 'Wind Speed',
                          value: currentWindSpeed.toString(),
                        ),
                        AdditionalInforItem(
                          icon: Icons.beach_access,
                          lable: 'Presure',
                          value: currentPusure.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
