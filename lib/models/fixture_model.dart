class FixtureModel {
  final String homeClub;
  final String awayClub;
  final String awayLogo;
  final String homeLogo;
  int homeScore;
  int awayScore;
  bool played;
  final DateTime dateTime;

  FixtureModel({
    required this.homeClub,
    required this.awayClub,
    required this.homeScore,
    required this.awayScore,
    required this.dateTime,
    required this.played,
    required this.awayLogo,
    required this.homeLogo,
  });

  factory FixtureModel.fromJson(Map<String, dynamic> json) {
    return FixtureModel(
      homeClub: json['homeClub'],
      awayClub: json['awayClub'],
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
      played: json['played'],
      dateTime: DateTime.parse(json['dateTime']),
      awayLogo: json['awayLogo'],
      homeLogo: json['homeLogo'],
    );
  }

  Map<String, dynamic> toJson() => {
        "homeClub": homeClub,
        "awayClub": awayClub,
        "homeScore": homeScore,
        "awayScore": awayScore,
        "played": played,
        "dateTime": dateTime.toIso8601String(),
        "homeLogo": homeLogo,
        "awayLogo": awayLogo,
      };
}
