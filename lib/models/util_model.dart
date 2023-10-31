class UtilsModel {
  List users;
  List seasons;
  List<Teams> listOfTeams;

  UtilsModel({
    required this.seasons,
    required this.users,
    required this.listOfTeams,
  });

  factory UtilsModel.fromJson(Map<String, dynamic> json) => UtilsModel(
        seasons: json['seasons'] ?? [],
        users: json['users'] ?? [],
        listOfTeams: (json['listOfTeams'] as List)
            .map((e) => Teams.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "seasons": seasons,
        "users": users,
        "listOfTeams": listOfTeams.map((e) => e.toJson()).toList(),
      };
}

class Teams {
  final String name;
  final String logo;

  Teams(this.logo, this.name);

  factory Teams.fromJson(Map<String, dynamic> json) =>
      Teams(json['logo'], json['name']);

  Map<String, dynamic> toJson() => {
        "logo": logo,
        "name": name,
      };
}

late UtilsModel utilsModel;
