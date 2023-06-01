import 'package:flutter/material.dart';
import 'Search.dart';
import 'description.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  AccueilState createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
  final List<Map<String, dynamic>> _cities = [];
  String _searchText = '';

  _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Search(
          searchText: '',
          onCitySelected: (city) {
            setState(() {
              _cities.add(city);
            });
          },
        ),
      ),
    );
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(   
            color: Colors.white)),
        backgroundColor: const Color(0xFF1E262C),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: _navigateToSearchPage,
          ),
        ],
        centerTitle: true,
      ),
      body: _cities.isEmpty
          ? const Center(child: Text('No cities added yet!'))
          : ListView.builder(
        itemCount: _cities.length,
        itemBuilder: (BuildContext context, int index) {
          final city = _cities[index];
          return _buildCard(city);
        },
      ),
    );
  }
  _navigateToCityDetailsPage(Map<String, dynamic> city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetailsPage(city: city),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> city) {
    return GestureDetector(
      onTap: () {
        _navigateToCityDetailsPage(city);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding:
                      const EdgeInsets.only(top: 7, left: 10, bottom: 7),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${city['name']}, ${city['country']}', // Afficher la ville à côté du pays
                                    style: const TextStyle(
                                     
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${city['weatherData']['current_weather']['temperature']}°C', // Afficher la température maximale du jour
                                  style: const TextStyle(
                            
                                    fontSize: 33,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${getWeatherDescription(city['weatherData']['current_weather']['weathercode'])}', // Afficher la description du temps
                                  style: const TextStyle(
                                   
                                    fontSize: 19,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              getWeatherIcon(city['weatherData']['current_weather']['weathercode']),
                              color: Colors.purple,
                              size: 44,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}