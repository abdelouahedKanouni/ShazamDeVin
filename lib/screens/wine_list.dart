import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shazam_vin/screens/wine_details.dart';
import 'package:shazam_vin/models/wine_details.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WineListPage extends StatefulWidget {
  @override
  _WineListPageState createState() => _WineListPageState();
}

class _WineListPageState extends State<WineListPage> {
  List<WineDetails> wines = []; // Liste de vins

  @override
  void initState() {
    super.initState();
    // Chargement initial des vins triés
    fetchWines();
  }

  // Fonction pour effectuer une requête HTTP et récupérer la liste triée de vins
  Future<void> fetchWines({String? sortField, bool sortOrderDesc = false, String? searchTerm}) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.27:8080/wine/loads?sortField=$sortField&sortOrder=${sortOrderDesc ? 'desc' : 'asc'}&searchTerm=$searchTerm'),
    );

    if (response.statusCode == 200) {
      final List<WineDetails> fetchedWines = (json.decode(response.body) as List)
          .map((data) => WineDetails.fromJson(data))
          .toList();

      setState(() {
        wines = fetchedWines;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur de scan : ${response.body}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0,
      );

    }
  }


  void sortByName(bool sortOrderDesc) {
    fetchWines(sortField: 'nom', sortOrderDesc: sortOrderDesc);
  }

  void sortByPrice(bool sortOrderDesc) {
    fetchWines(sortField: 'prix', sortOrderDesc: sortOrderDesc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des vins'),
      ),
      body: Column(
        children: [
          // Input field for searching by name
          TextField(
            onChanged: (value) {
              fetchWines(searchTerm: value);
            },
            decoration: InputDecoration(labelText: 'Recherche par nom'),
          ),
          // Buttons for sorting
          ElevatedButton(
            onPressed: () => sortByPrice(true),
            child: Text('Tri par prix (ascendant)'),
          ),
          ElevatedButton(
            onPressed: () => sortByPrice(false),
            child: Text('Tri par prix (descendant)'),
          ),
          // List of wines
          Expanded(
            child: ListView.builder(
              itemCount: wines.length,
              itemBuilder: (context, index) {
                final wine = wines[index];
                return ListTile(
                  title: Text(wine.nom ?? 'Unknown'),
                  subtitle: Text('Prix: ${wine.prix}'),
                  onTap: () {
                    // Navigate to the wine details page when the wine is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WineDetailsPage(barcode: wine.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
