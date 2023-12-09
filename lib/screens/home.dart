import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Rediriger vers la page de scanner
                Navigator.pushNamed(context, '/scanner');
              },
              child: Text('Scanner'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Rediriger vers la page de liste de vins
                Navigator.pushNamed(context, '/liste_vins');
              },
              child: Text('Liste de Vins'),
            ),
          ],
        ),
      ),
    );
  }
}
