class WineDetails {
  String id;
  String? nom;
  String? descriptif;
  String? embouteillage;
  String? cepage;
  String? chateau;
  double? prix;


  WineDetails({
    required this.id,
    this.nom,
    this.descriptif,
    this.embouteillage,
    this.cepage,
    this.chateau,
    this.prix,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'descriptif': descriptif,
      'embouteillage': embouteillage,
      'cepage': cepage,
      'chateau': chateau,
      'prix': prix,
    };
  }

  factory WineDetails.fromJson(Map<String, dynamic> json) {
    return WineDetails(
      id: json['_id'],
      nom: json['nom'] == '' ? 'NaN': json['nom'],
      descriptif: json['descriptif'],
      embouteillage: json['embouteillage'],
      cepage: json['cepage'],
      chateau: json['chateau'],
      prix: json['prix'].toDouble() ?? 0.00,
    );
  }

}
