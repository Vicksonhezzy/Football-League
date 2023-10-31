class TableModel {
  final int position;
  final String club;
  final String logo;
  int mp;
  int w;
  int d;
  int l;
  int pts;
  int gf;
  int ga;
  int gd;
  List last5;

  TableModel({
    required this.position,
    required this.club,
    required this.mp,
    required this.w,
    required this.d,
    required this.l,
    required this.pts,
    required this.gf,
    required this.ga,
    required this.gd,
    required this.last5,
    required this.logo,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      position: json["position"],
      club: json["club"],
      mp: json["matchPlayed"],
      w: json["wins"],
      d: json["draws"],
      l: json["loss"],
      pts: json["points"],
      gf: json["goalFor"],
      ga: json["goalAgainst"],
      gd: json["goalDiff"],
      last5: json["last5"],
      logo: json["logo"],
    );
  }

  Map<String, dynamic> toJson() => {
        "position": position,
        "club": club,
        "matchPlayed": mp,
        "wins": w,
        "draws": d,
        "loss": l,
        "points": pts,
        "goalFor": gf,
        "goalAgainst": ga,
        "goalDiff": gd,
        "last5": last5,
        "logo": logo,
      };
}
