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

  IconData getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny;
      case 1:
        return Icons.wb_sunny_outlined;
      case 2:
        return Icons.wb_cloudy_outlined;
      case 3:
        return Icons.wb_cloudy_sharp;
      case 45:
      case 48:
        return Icons.cloud_queue;
      case 51:
      case 53:
      case 55:
        return Icons.grain;
      case 56:
      case 57:
        return Icons.ac_unit;
      case 61:
      case 63:
      case 65:
        return Icons.beach_access;
      case 66:
      case 67:
        return Icons.ac_unit;
      case 71:
      case 73:
      case 75:
        return Icons.ac_unit;
      case 77:
        return Icons.cloud;
      case 80:
      case 81:
      case 82:
        return Icons.grain;
      case 85:
      case 86:
        return Icons.ac_unit;
      case 95:
        return Icons.flash_on;
      case 96:
      case 99:
        return Icons.grain;
      default:
        return Icons.help_outline;
    }
  }
  String getWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return 'Ensoleillé';
      case 1:
        return 'Partiellement nuageux';
      case 2:
        return 'Nuageux';
      case 3:
        return 'Très nuageux';

      case 45:
      case 48:
        return 'Brouillard et givre';
      case 51:
      case 53:
      case 55:
        return 'Bruine';
      case 56:
      case 57:
        return 'Bruine verglaçante';
      case 61:
      case 63:
      case 65:
        return 'Pluie';
      case 66:
      case 67:
        return 'Pluie verglaçante';
      case 71:
      case 73:
      case 75:
        return 'Chute de neige';
      case 77:
        return 'Grains de neige';
      case 80:
      case 81:
      case 82:
        return 'Averses de pluie';
      case 85:
      case 86:
        return 'Averses de neige';
      case 95:
        return 'Orage';
      case 96:
      case 99:
        return 'Orage avec grêle';
      default:
        return 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> hourlyTimes =
    List<String>.from(city['weatherData']['hourly']['time']);
    List<int> codes =
    List<int>.from(city['weatherData']['hourly']['weathercode']);
    List<double> temperatureValues =
    List<double>.from(city['weatherData']['hourly']['temperature_2m']);
    DateTime currentTime = DateTime.now();

    List<String> dailyTimes =
    List<String>.from(city['weatherData']['daily']['time']);
    List<double> dailyTemperatureMax =
    List<double>.from(city['weatherData']['daily']['temperature_2m_max']);
    List<double> dailyTemperatureMin =
    List<double>.from(city['weatherData']['daily']['temperature_2m_min']);
    List<int> dailycodes =
    List<int>.from(city['weatherData']['daily']['weathercode']);

    List<int> hourlyHumidity =
    List<int>.from(city['weatherData']['hourly']['relativehumidity_2m']);
    List<double> apparent_temperature =
    List<double>.from(city['weatherData']['hourly']['apparent_temperature']);
    List<int> precipitation_probability =
    List<int>.from(city['weatherData']['hourly']['precipitation_probability']);
    List<double> speedee =
    List<double>.from(city['weatherData']['hourly']['windspeed_10m']);
    int startIndex = -1;
    for (int i = 0; i < hourlyTimes.length; i++) {
      DateTime currentHour = DateTime.parse(hourlyTimes[i]);
      if (currentHour.isAfter(currentTime)) {
        startIndex = i;
        break;
      }
    }
    int humidite = hourlyHumidity[startIndex];
    double ressenti = apparent_temperature[startIndex];
    int probabilite = precipitation_probability[startIndex];
    double speed = speedee[startIndex];

    List<String> selectedHours = [];
    List<double> selectedTemperatures = [];
    List<int> selectedCode = [];

    if (startIndex != -1) {
      for (int i = startIndex;
      i < startIndex + 20 && i < hourlyTimes.length;
      i++) {
        selectedHours.add(hourlyTimes[i]);
        selectedTemperatures.add(temperatureValues[i]);
        selectedCode.add(codes[i]);
      }
    }

    double valeurTempMin = dailyTemperatureMin[0];
    double valeurTempMax = dailyTemperatureMax[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails de la ville',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E262C),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${city['weatherData']['current_weather']['temperature']}°C",
                                  style: TextStyle(
                                  
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Aujourd'hui, le temps est ${getWeatherDescription(city['weatherData']['current_weather']['weathercode'])}",
                                  style: TextStyle(
                             
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Il y aura une température minimale de ${valeurTempMin.toStringAsFixed(1)}°C et une température maximale de ${valeurTempMax.toStringAsFixed(1)}°C",
                                  style: TextStyle(
                                   
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            getWeatherIcon(city['weatherData']['current_weather']['weathercode']),
                            size: 80,
                          ),
                        ],
                      ),
                    ),
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
                      int code = selectedCode[index];
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
                                  getWeatherIcon(code),
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
                      int code= dailycodes[index + 1];
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
                            Icon(getWeatherIcon(code)),
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
                SizedBox(height: 16),
                Text(
                  'Plus d\'infos',
                  style: TextStyle(
                 
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 13),
                SizedBox(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InfoCard(
                              icon: Icons.cloud,
                              title: 'Chances de pluie',
                              value: '$probabilite % ',
                            ),
                          ),
                          SizedBox(width: 13),
                          Expanded(
                            child: InfoCard(
                              icon: Icons.opacity,
                              title: 'Taux d\'humidité',
                              value: '$humidite %',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InfoCard(
                              icon: Icons.air,
                              title: 'Vent',
                              value: '$speed km/h',
                            ),
                          ),
                          SizedBox(width: 13),
                          Expanded(
                            child: InfoCard(
                              icon: Icons.thermostat,
                              title: 'Température ressentie',
                              value: '$ressenti °C',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 200),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
               
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
           
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}