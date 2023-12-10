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

}
