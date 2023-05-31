import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String searchText;
  final Function(Map<String, dynamic>) onCitySelected;

  Search({Key? key, required this.searchText, required this.onCitySelected})
      : super(key: key);

  set _searchText(String _searchText) {}

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  late List<dynamic> _locations = [];

  @override
  void initState() {
    super.initState();
    _performSearch(widget.searchText);
  }

  Future<void> _performSearch(String searchText) async {
    final response = await http.get(Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=${searchText}&count=3&language=fr&format=json'));
    final data = jsonDecode(response.body);
    setState(() {
      _locations = data['results'];
    });
  }

  Future<void> _getWeatherData(dynamic location) async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${location['latitude']}&longitude=${location['longitude']}&hourly=temperature_2m,apparent_temperature,precipitation_probability,weathercode,windspeed_10m,winddirection_10m&daily=temperature_2m_max,temperature_2m_min&current_weather=true&timezone=auto'));
    final data = jsonDecode(response.body);
    location['weatherData'] = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2025),
      appBar: AppBar(
        title: const Text("Recherche", style: TextStyle(
            color: Colors.white)),
        backgroundColor: const Color(0xFF1E262C),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  widget._searchText = text;
                  _performSearch(
                      text); // Appeler la méthode pour effectuer la recherche
                });
              },
              decoration: const InputDecoration(
                hintText: 'Rechercher un ville ...',
                hintStyle: TextStyle(
                    color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Color(0xFF2E3B4E),
              ),
              style: const TextStyle(
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: _locations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _locations.length,
        itemBuilder: (BuildContext context, int index) {
          final location = _locations[index];
          return _buildCard(location);
        },
      ),
    );
  }

  Widget _buildCard(dynamic location) {
    return GestureDetector(
      onTap: () async {
        await _getWeatherData(location);
        widget.onCitySelected({
          'name': location['name'],
          'country': location['country'],
          'weatherData': location['weatherData'], // Ajoutez toutes les données de prévision météo
        });
        Navigator.pop(context); // Revenir à la page précédente
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,  // Changer la valeur pour réduire la hauteur
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Text(
                            location['name'], // Get name from location object
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            location['country'], // Get country from location object
                            style: const TextStyle(
                                fontSize: 16,
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
    );
  }

}