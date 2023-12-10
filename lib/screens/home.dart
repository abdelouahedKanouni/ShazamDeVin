import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shazam_vin/screens/wine_details.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accueil',
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Vin.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _scanBarcode(context),
                child: Text('Scanner Code Barre'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showWineList(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                child: Text('Afficher Liste Vins'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logout(),
        tooltip: 'Déconnexion',
        child: Icon(Icons.logout),
      ),
    );
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Résultat du scan'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _scanBarcode(BuildContext context) async {
    try {
      var result = await BarcodeScanner.scan();
      if (result != null) {
        final response = await http.post(
          Uri.parse('http://192.168.1.27:8080/verifyWine'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'barcode': result.rawContent}),
        );
        final message = json.decode(response.body)['message'] as String;

        if (message.startsWith('Code-barres')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WineDetailsPage(barcode: result.rawContent),
            ),
          );
        } else {
          _showAlert(context, message);
        }
      }
    } catch (e) {
      _showAlert(context, 'Erreur de scan : $e');
    }
  }


  void _showWineList() {
    // Afficher Liste Vins
  }

  void _logout() {
    // Déconnexion
  }
}
