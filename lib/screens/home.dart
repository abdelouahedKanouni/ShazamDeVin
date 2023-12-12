import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shazam_vin/screens/wine_details.dart';
import 'session_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accueil',
          style: GoogleFonts.pacifico(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Déconnexion'),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
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
                onPressed: () => _showWineList(context),
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

        Fluttertoast.showToast(
          msg: 'Affichage du vin n°${result.rawContent}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 18.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineDetailsPage(barcode: result.rawContent),
          ),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erreur de scan : $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    }
  }


  void _showWineList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WineListPage()),
    );
  }

  void _logout(BuildContext context) async {
    // Envoyer une requête POST à l'API pour supprimer la session
    final response = await http.post(
      Uri.parse('http://192.168.1.27:8080/logout'),
      headers: {'Content-Type': 'application/json'},
    );
    // Nettoyer la session localement
    await clearSession();
    if (response.statusCode==200) {
      Fluttertoast.showToast(
        msg: 'Déconnexion réussie au revoir 👋',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0,
      );

      // Naviguer vers la page de connexion
      Navigator.pushReplacementNamed(context, '/login');
    }

  }
}
