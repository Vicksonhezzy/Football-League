import 'package:sbc_league/core/constants/logos.dart';

class ClubLogoModel {
  final String name;
  final String logo;

  ClubLogoModel(this.name, this.logo);
}

List<ClubLogoModel> listOfClubLogos = [
  ClubLogoModel(getLogoName(ClubLogos.acMilian), ClubLogos.acMilian),
  ClubLogoModel(getLogoName(ClubLogos.arsenal), ClubLogos.arsenal),
  ClubLogoModel(getLogoName(ClubLogos.asRoma), ClubLogos.asRoma),
  ClubLogoModel(getLogoName(ClubLogos.astonVilla), ClubLogos.astonVilla),
  ClubLogoModel(getLogoName(ClubLogos.atlanta), ClubLogos.atlanta),
  ClubLogoModel(
      getLogoName(ClubLogos.atleticoMadrid), ClubLogos.atleticoMadrid),
  ClubLogoModel(getLogoName(ClubLogos.barcelona), ClubLogos.barcelona),
  ClubLogoModel(getLogoName(ClubLogos.brighton), ClubLogos.brighton),
  ClubLogoModel(getLogoName(ClubLogos.chelsea), ClubLogos.chelsea),
  ClubLogoModel(getLogoName(ClubLogos.everton), ClubLogos.everton),
  ClubLogoModel(getLogoName(ClubLogos.interMilan), ClubLogos.interMilan),
  ClubLogoModel(getLogoName(ClubLogos.juventus), ClubLogos.juventus),
  ClubLogoModel(getLogoName(ClubLogos.liverpool), ClubLogos.liverpool),
  ClubLogoModel(getLogoName(ClubLogos.lyon), ClubLogos.lyon),
  ClubLogoModel(getLogoName(ClubLogos.manCity), ClubLogos.manCity),
  ClubLogoModel(getLogoName(ClubLogos.manU), ClubLogos.manU),
  ClubLogoModel(getLogoName(ClubLogos.napoli), ClubLogos.napoli),
  ClubLogoModel(getLogoName(ClubLogos.newcastle), ClubLogos.newcastle),
  ClubLogoModel(getLogoName(ClubLogos.psg), ClubLogos.psg),
  ClubLogoModel(getLogoName(ClubLogos.realMadrid), ClubLogos.realMadrid),
  ClubLogoModel(getLogoName(ClubLogos.sevilla), ClubLogos.sevilla),
  ClubLogoModel(getLogoName(ClubLogos.tottenham), ClubLogos.tottenham),
  ClubLogoModel(getLogoName(ClubLogos.villarreal), ClubLogos.villarreal),
  ClubLogoModel(getLogoName(ClubLogos.wolves), ClubLogos.wolves)
];

String getLogoName(String logo) {
  return logo.replaceAll('assets/club_logos/', '').replaceAll('.png', '');
}
