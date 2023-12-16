class Commentaire {
  String commentId;
  String createdBy;
  String commentaire;
  double note;

  Commentaire({
    required this.commentId,
    required this.createdBy,
    required this.commentaire,
    required this.note,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      commentId: json['_id'],
      createdBy: json['createdBy'],
      commentaire: json['commentaire'],
      note: json['note'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': commentId,
      'createdBy': createdBy,
      'commentaire': commentaire,
      'note': note,
    };
  }
}
