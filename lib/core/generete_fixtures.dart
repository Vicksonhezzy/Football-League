import 'dart:math';

import 'package:sbc_league/core/utils/date_time_utils.dart';
import 'package:sbc_league/models/fixture_model.dart';
import 'package:sbc_league/models/util_model.dart';

String generateSeason([DateTime? date]) {
  String yr = (date ?? DateTime.now()).year.toString();
  return "$yr-${yr.substring(yr.length - 2)}";
}

DateTime generateRandomDate(DateTime startDate, DateTime endDate) {
  final random = Random();

  // Get the difference in days between the start and end dates
  final difference = endDate.difference(startDate).inDays;

  // Generate a random number between 0 and the difference
  final randomDays = random.nextInt(difference + 1);

  // Add the random number of days to the start date
  final randomDate = startDate.add(Duration(days: randomDays));

  String formattedDate = randomDate.format('EEEE');

  // Excluded weekends due to the initial use case of the app
  if (formattedDate.toLowerCase() == 'saturday') {
    return randomDate.add(const Duration(days: 2));
  }
  if (formattedDate.toLowerCase() == 'sunday') {
    return randomDate.add(const Duration(days: 1));
  }

  return randomDate;
}

// Future<List<FixtureModel>> createFixture(
//     {required int startYear,
//     required int startMonth,
//     required int startDay,
//     required int endyear,
//     required int endMonth,
//     required int endDay}) async {
//   List<FixtureModel> matches = [];
//   List<Teams> teams = utilsModel.listOfTeams;
//   final fixtures = _generateFixtures(teams);

//   // List<Teams> secondLeg = [];
//   // final secondFixtures = _generateFixtures(secondLeg.reversed.toList());

//   // create first leg
//   for (var round = 0; round < fixtures.length; round++) {
//     for (var match in fixtures[round]) {
//       matches.add(FixtureModel(
//           homeClub: match[0].name,
//           awayClub: match[1].name,
//           awayLogo: match[1].logo,
//           homeLogo: match[0].logo,
//           homeScore: 0,
//           awayScore: 0,
//           dateTime: generateRandomDate(
//               DateTime(startYear, startMonth, startDay),
//               DateTime(endyear, endMonth, endDay)),
//           played: false));
//     }
//   }

//   // create second leg
//   // for (var round = 0; round < secondFixtures.length; round++) {
//   //   for (var match in secondFixtures[round]) {
//   //     if (!matches.any((element) =>
//   //         element.homeClub == match[0].name &&
//   //         element.awayClub == match[1].name)) {
//   //       matches.add(FixtureModel(
//   //           homeClub: match[0].name,
//   //           awayClub: match[1].name,
//   //           awayLogo: match[1].logo,
//   //           homeLogo: match[0].logo,
//   //           homeScore: 0,
//   //           awayScore: 0,
//   //           dateTime: generateRandomDate(
//   //               DateTime(startYear, startMonth, startDay),
//   //               DateTime(endyear, endMonth, endDay)),
//   //           played: false));
//   //     }
//   //   }
//   // }
//   return matches;
// }

Future<List<FixtureModel>> generateFixtures(
    {required int startYear,
    required int startMonth,
    required int startDay,
    required int endyear,
    required int endMonth,
    required int endDay}) async {
  final List<Teams> teams = utilsModel.listOfTeams;
  final fixtures = <FixtureModel>[];
  final totalRounds = teams.length - 1;
  final matchesPerRound = teams.length ~/ 2;

  final rotatingTeams =
      List<Teams>.from(teams); // Create a rotating list of teams

  for (var round = 0; round < totalRounds; round++) {
    final roundFixtures = <FixtureModel>[];

    for (var match = 0; match < matchesPerRound; match++) {
      final homeTeam = rotatingTeams[match];
      final awayTeam = rotatingTeams[(totalRounds - match)];

      roundFixtures.add(FixtureModel(
          homeClub: homeTeam.name,
          awayClub: awayTeam.name,
          homeScore: 0,
          awayScore: 0,
          dateTime: generateRandomDate(
              DateTime(startYear, startMonth, startDay),
              DateTime(endyear, endMonth, endDay)),
          played: false,
          awayLogo: awayTeam.logo,
          homeLogo: homeTeam.logo));
    }

    fixtures.addAll(roundFixtures);

    // Rotate the teams for the next round
    rotatingTeams.insert(1, rotatingTeams.removeLast());
  }

  return fixtures;
}
