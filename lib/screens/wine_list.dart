import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shazam_vin/screens/wine_details.dart';
import 'package:shazam_vin/models/wine_details.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shazam_vin/models/GlobalData.dart';

class WineListPage extends StatefulWidget {
  @override
  _WineListPageState createState() => _WineListPageState();
}

class _WineListPageState extends State<WineListPage> {
  List<WineDetails> wines = []; // Liste de vins
  String searchTerm = "";
  String sortField = "";
  bool sortOrderDesc = false;

  @override
  void initState() {
    super.initState();
    fetchWines();
  }

  // Fonction pour effectuer une requête HTTP et récupérer la liste triée de vins
  Future<void> fetchWines() async {

    final response = await http.get(
      Uri.parse('${GlobalData.server}/wine/loads?sortField=$sortField&sortOrder=${sortOrderDesc ? 'desc' : 'asc'}&searchTerm=$searchTerm'),
      headers: {
        'Cookie': GlobalData.cookie ?? '',
      },
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

  Future<void> _refreshWines() async {
    await Future.delayed(const Duration(seconds: 1));
    fetchWines();
  }

  void sortByName(bool sortOrderDesc) {
    sortField = 'nom';
    this.sortOrderDesc = sortOrderDesc;
    fetchWines();
  }

  void sortByPrice(bool sortOrderDesc) {
    sortField = 'prix';
    this.sortOrderDesc = sortOrderDesc;
    fetchWines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des vins',
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Vigne.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Input field for searching by name
            TextField(
              onChanged: (value) {
                searchTerm = value;
                fetchWines();
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: '  Recherche par nom', labelStyle: TextStyle(color: Colors.white)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => sortByPrice(true),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: const Text('prix (ascendant)'),
                ),
                ElevatedButton(
                  onPressed: () => sortByPrice(false),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: const Text('prix (descendant)'),
                ),
              ],
            ),
            // List of wines
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshWines,
                child: ListView.builder(
                  itemCount: wines.length,
                  itemBuilder: (context, index) {
                    final wine = wines[index];
                    return Card(
                      elevation: 5.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: ListTile(
                        // Moving the price to the top left corner with a badge effect
                        leading: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Colors.blue, // Adjust the color as needed
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            '${wine.prix} €',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(wine.nom ?? ''), // Displaying the cepage
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(wine.chateau ?? ''), // Displaying the chateau
                            Text(wine.cepage ?? ''), // Second subtitle
                          ],
                        ),                        onTap: () async {
                          // Navigate to the wine details page when the wine is clicked
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WineDetailsPage(barcode: wine.id),
                            ),
                          );
                          fetchWines();
                        },
                      ),
                    );
                    },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
