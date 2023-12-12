import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shazam_vin/models/wine_details.dart';
import 'package:http/http.dart' as http;
import 'package:shazam_vin/models/GlobalData.dart';

class WineDetailsPage extends StatefulWidget {
  final String barcode;

  WineDetailsPage({required this.barcode});

  @override
  _WineDetailsPageState createState() => _WineDetailsPageState();
}

class _WineDetailsPageState extends State<WineDetailsPage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController descriptifController = TextEditingController();
  final TextEditingController embouteillageController = TextEditingController();
  final TextEditingController cepageController = TextEditingController();
  final TextEditingController chateauController = TextEditingController();
  final TextEditingController prixController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails du Vin',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Code-barres: ${widget.barcode}',
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: nomController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nom du Vin',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              // Champ de description avec plusieurs lignes
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: descriptifController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Descriptif',
                    labelStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                  ),
                  minLines: 2,
                  maxLines: null,
                ),
              ),
              TextField(
                controller: embouteillageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Embouteillage',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: cepageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Cepage',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: chateauController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Chateau',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: prixController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Prix (€)',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveWineDetails(context);
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadWineDetails();
  }

  Future<void> _loadWineDetails() async {
    try {
      var response = await http.post(
        Uri.parse('${GlobalData.server}/wine/loadDetails'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'barcode': widget.barcode}),
      );

      if (response.statusCode == 200 || response.statusCode == 404) {
        // Convertir la réponse JSON en Map
        Map<String, dynamic> wineData = json.decode(response.body);

        // Remplir les champs avec les données existantes
        setState(() {
          nomController.text = wineData['nom'] ?? '';
          descriptifController.text = wineData['descriptif'] ?? '';
          embouteillageController.text = wineData['embouteillage'] ?? '';
          cepageController.text = wineData['cepage'] ?? '';
          chateauController.text = wineData['chateau'] ?? '';
          prixController.text = wineData['prix']?.toString() ?? '';
        });
      } else {
        _showAlert(context,'Erreur lors du chargement des détails du vin: ${response.body}', false);
      }
    } catch (e) {
      _showAlert(context,'Erreur lors du chargement des détails du vin: $e', false);
    }
  }

  void _showAlert(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: success ? Colors.blue : Colors.red,
      ),
    );
  }

  Future<void> _saveWineDetails(BuildContext context) async {

    try {
      String nom = nomController.text;
      String descriptif = descriptifController.text;
      String embouteillage = embouteillageController.text;
      String cepage = cepageController.text;
      String chateau = chateauController.text;
      double prix = double.tryParse(prixController.text) ?? 0.0;

      WineDetails wineDetails = WineDetails(
        id: widget.barcode,
        nom: nom,
        descriptif: descriptif,
        embouteillage: embouteillage,
        cepage: cepage,
        chateau: chateau,
        prix: prix,
      );

      BuildContext currentContext = context;

      var response = await http.post(
        Uri.parse('${GlobalData.server}/wine/saveDetails'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(wineDetails.toMap()),
      );

      if (response.statusCode == 200) {
        _showAlert(currentContext, 'Détails du vin enregistrés avec succès', true);
      } else {
        _showAlert(currentContext, 'Erreur lors de l\'enregistrement des détails du vin', false);
      }
      Navigator.pop(context);
    } catch (e) {
    _showAlert(context, 'Erreur : $e', false);
    }
  }

}
