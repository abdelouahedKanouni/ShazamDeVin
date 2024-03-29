import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shazam_vin/models/wine_details.dart';
import 'package:http/http.dart' as http;
import 'package:shazam_vin/models/Commentaire.dart';
import 'package:shazam_vin/models/GlobalData.dart';
import 'package:shazam_vin/screens/session_utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  bool isAdmin = false;
  String idUser = '';
  double initialRating = 0.0;
  double currentRating = 0.0;
  List<Commentaire> commentaires = [];

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
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
              TextField(
                controller: nomController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                decoration: InputDecoration(
                  labelText: 'Nom du Vin',
                  labelStyle: GoogleFonts.pacifico(fontSize: 22.0, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.45),
                ),
                enabled: isAdmin,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: descriptifController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                decoration:  InputDecoration(
                  labelText: 'Descriptif',
                  labelStyle: GoogleFonts.pacifico(fontSize: 22.0, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.45),
                ),
                enabled: isAdmin,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: embouteillageController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                decoration:  InputDecoration(
                  labelText: 'Embouteillage',
                  labelStyle: GoogleFonts.pacifico(fontSize: 22.0, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.45),
                ),
                enabled: isAdmin,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: cepageController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                decoration:  InputDecoration(
                  labelText: 'Cépage',
                  labelStyle: GoogleFonts.pacifico(fontSize: 22.0, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.45),
                ),
                enabled: isAdmin,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: chateauController,
                style:  const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                decoration:  InputDecoration(
                  labelText: 'Château',
                  labelStyle: GoogleFonts.pacifico(fontSize: 22.0, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.45),
                ),
                enabled: isAdmin,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: prixController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                decoration:  InputDecoration(
                  labelText: 'Prix €',
                  labelStyle: GoogleFonts.pacifico(fontSize: 22.0, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.45),
                ),
                enabled: isAdmin,
              ),
              const SizedBox(height: 20),
              if (isAdmin) ... [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveWineDetails(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const Text(
                        'Enregistrer',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _deleteWine();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        child: const Text(
                          'Supprimer',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ] else ... [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                        child: const Text(
                          'Retour',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
              ],
              const SizedBox(height: 10.0),
              TextButton.icon(
                onPressed: () {
                  _showComments();
                },
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                icon: const Icon(
                  Icons.comment,
                  color: Colors.black,
                ),
                label: const Text(
                  'Commentaires',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
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
    _checkAdminStatus();
    _getIdUser();
    _loadWineDetails();
  }

  void _showComments() {
    List<Widget> userSections = [];

    for (var commentaire in commentaires) {
      Widget userSection = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: FutureBuilder(
              future: _getUserIdentifiant(commentaire.createdBy),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    children: [
                      Text(
                        '${snapshot.data} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RatingBarIndicator(
                        rating: commentaire.note.toDouble(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  );
                } else {
                  return const Text(
                    'Chargement...',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 12.0,
                    ),
                  );
                }
              },
            ),
          ),
          ListTile(
            title: Text(
              commentaire.commentaire,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 12.0,
              ),
            ),
          ),
          if (isAdmin || idUser == commentaire.createdBy ) ... [
            ElevatedButton(
              onPressed: () {
                _deleteComment(commentaire.commentId);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.white),
                ),
              ),
              child: const Text(
                'Supprimer',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12.0,
                ),
              ),

            ),
          ],
          const Divider(color: Colors.black),
        ],
      );

      userSections.add(userSection);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(16.0),
          backgroundColor: Colors.white,
          children: [
            if (commentaires.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Aucun commentaire disponible',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: userSections, // Afficher les sections des utilisateurs
              ),
            TextButton.icon(
              onPressed: () {
                _addComment();
              },
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(color: Colors.black),
                ),
                fixedSize: const Size(10.0, 30.0),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 20.0,
              ),
              label: const Text(
                'Ajouter un commentaire',
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Fermer',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: 'Pacifico',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> _getUserIdentifiant(String userId) async {
    try {
      var response = await http.post(
        Uri.parse('${GlobalData.server}/wine/getIdentifiant'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': GlobalData.cookie ?? '',
        },
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['identifiant'];
      } else {
        return 'Utilisateur inconnu';
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'identifiant de l\'utilisateur : $e');
      return 'Erreur';
    }
  }

  void _addComment() {
    TextEditingController commentController = TextEditingController();
    double newRating = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5.0),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15.0),
              Row(
                children: [
                  const Text('', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10.0),
                  RatingBar.builder(
                    initialRating: newRating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      newRating = rating;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              TextField(
                controller: commentController,
                style: const TextStyle(color: Colors.black),
                decoration:  InputDecoration(
                  labelText: 'Commentaire',
                  labelStyle: const TextStyle(fontSize: 12.0, color: Colors.black),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                ),
                minLines: 2,
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: 'Pacifico'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _saveComment(commentController.text, newRating);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              child: const Text(
                'Ajouter',
                style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Pacifico'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveComment(String commentaire, double note) async {
    final userSession = await getSession();
    if (userSession != null) {
      setState(() {
        idUser = userSession['userId'] ?? '';
      });
    }

    try {
      var response = await http.post(
        Uri.parse('${GlobalData.server}/wine/addComment'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': GlobalData.cookie ?? '',
        },
        body: jsonEncode({
          'wineId': widget.barcode,
          'commentaire': commentaire,
          'note': note,
          'createdBy': idUser,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Commentaire ajouté avec succès',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );
        await _loadWineDetails();
        Navigator.of(context).pop();
        _showComments();
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du commentaire : $e');
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      var response = await http.post(
        Uri.parse('${GlobalData.server}/wine/deleteComment'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': GlobalData.cookie ?? '',
      },
        body: jsonEncode({
          'wineId': widget.barcode,
          'commentId': commentId,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Commentaire supprimé avec succès',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );
        await _loadWineDetails();
        Navigator.of(context).pop();
        _showComments();
      }
    } catch (e) {
      print('Erreur lors de la suppression du commentaire : $e');
    }
  }



  Future<void> _checkAdminStatus() async {
    final session = await getSession();
    if (session != null) {
      setState(() {
        isAdmin = session['isAdmin'] ?? false;
      });
    }
  }

  Future<void> _getIdUser() async {
    final session = await getSession();
    if (session != null) {
      setState(() {
        idUser = session['userId'] ?? false;
      });
    }
  }

  Future<void> _loadWineDetails() async {
    try {
      var response = await http.post(
        Uri.parse('${GlobalData.server}/wine/loadDetails'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': GlobalData.cookie ?? '',
          },
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
          commentaires = (wineData['commentaires'] != null && wineData['commentaires'] is List)
              ? (wineData['commentaires'] as List).map((c) => Commentaire.fromJson(c)).toList()
              : [];
        });
      } else {
        _showAlert(context,'Erreur lors du chargement des détails du vin: ${response.body}', false);
      }
    } catch (e) {
      _showAlert(context, 'Erreur lors du chargement des détails du vin: $e', false);
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
        headers: {
          'Content-Type': 'application/json',
          'Cookie': GlobalData.cookie ?? '',
        },
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

  Future<void> _deleteWine() async {
    try {
      var response = await http.post(
        Uri.parse('${GlobalData.server}/wine/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': GlobalData.cookie ?? '',
        },
        body: jsonEncode({'barcode': widget.barcode}),
      );

      if (response.statusCode == 200) {
        _showAlert(context, 'Vin supprimé avec succès', true);
        Navigator.pop(context);
      } else {
        _showAlert(context, 'Erreur lors de la suppression du vin', false);
      }
    } catch (e) {
      _showAlert(context, 'Erreur : $e', false);
    }
  }


}
