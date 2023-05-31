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
                                      fontFamily: 'ProximaNova',
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${city['weatherData']['current_weather']['temperature']}°C', // Afficher la température maximale du jour
                                  style: const TextStyle(
                                    fontFamily: 'ProximaNova',
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
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