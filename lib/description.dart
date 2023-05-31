import 'package:flutter/material.dart';

class CityDetailsPage extends StatelessWidget {
  final Map<String, dynamic> city;

  const CityDetailsPage({Key? key, required this.city}) : super(key: key);

  String extractWeekday(String dateString) {
    DateTime date = DateTime.parse(dateString);
    List<String> weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    String weekday = weekdays[date.weekday - 1];
    return weekday;
  }

  @override
  Widget build(BuildContext context) {
    List<String> hourlyTimes =
    List<String>.from(city['weatherData']['hourly']['time']);
    List<double> temperatureValues =
    List<double>.from(city['weatherData']['hourly']['temperature_2m']);
    DateTime currentTime = DateTime.now();

    List<String> dailyTimes =
    List<String>.from(city['weatherData']['daily']['time']);
    List<double> dailyTemperatureMax =
    List<double>.from(city['weatherData']['daily']['temperature_2m_max']);
    List<double> dailyTemperatureMin =
    List<double>.from(city['weatherData']['daily']['temperature_2m_min']);

    int startIndex = -1;
    for (int i = 0; i < hourlyTimes.length; i++) {
      DateTime currentHour = DateTime.parse(hourlyTimes[i]);
      if (currentHour.isAfter(currentTime)) {
        startIndex = i;
        break;
      }
    }

    List<String> selectedHours = [];
    List<double> selectedTemperatures = [];
    if (startIndex != -1) {
      for (int i = startIndex;
      i < startIndex + 20 && i < hourlyTimes.length;
      i++) {
        selectedHours.add(hourlyTimes[i]);
        selectedTemperatures.add(temperatureValues[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails de la ville',
          style: TextStyle( color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E262C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${city['name']}, ${city['country']}',
              style: TextStyle(
              
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${extractWeekday(city['weatherData']['current_weather']['time'])}',
                  style: TextStyle(
                    
                    fontSize: 25,
                  ),
                ),
                Text(
                  '${city['weatherData']['daily']['temperature_2m_max'][0]}°',
                  style: TextStyle(
                   
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${city['weatherData']['daily']['temperature_2m_min'][0]}°',
                  style: TextStyle(
                   
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedHours.length,
                itemBuilder: (context, index) {
                  String hour = selectedHours[index];
                  double temperature = selectedTemperatures[index];
                  IconData weatherIcon =
                      Icons.cloud; // Remplacez l'icône par celle correspondante aux conditions météorologiques

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              hour.substring(11, 16),
                              style: TextStyle(
                               
                                fontSize: 18,
                              ),
                            ),
                            Icon(
                              weatherIcon,
                              size: 40,
                            ),
                            Text(
                              '${temperature.toStringAsFixed(1)}°C',
                              style: TextStyle(
                                
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              children: List.generate(
                dailyTimes.length >= 4 ? 4 : dailyTimes.length,
                    (index) {
                  String time = dailyTimes[index + 1];
                  double temperatureMax = dailyTemperatureMax[index + 1];
                  double temperatureMin = dailyTemperatureMin[index + 1];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${extractWeekday(time)}',
                          style: TextStyle(
                           
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${temperatureMin.toStringAsFixed(1)}°',
                          style: TextStyle(
                            
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${temperatureMax.toStringAsFixed(1)}°',
                          style: TextStyle(
                            
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
