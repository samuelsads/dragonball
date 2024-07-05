class Character {
  int id;
  String name;
  String ki;
  String maxKi;
  String race;
  String gender;
  String description;
  String image;
  String afilliations;
  OriginPlanet? originPlanet;
  List<Transformation>? transformations;
  Character(
      {required this.id,
      required this.name,
      required this.ki,
      required this.maxKi,
      required this.race,
      required this.gender,
      required this.description,
      required this.image,
      required this.afilliations,
      this.originPlanet,
      this.transformations});
}

class OriginPlanet {
  int id;
  String name;
  bool isDestroyed;
  String description;
  String image;

  OriginPlanet(
      {required this.id,
      required this.name,
      required this.isDestroyed,
      required this.description,
      required this.image});
}

class Transformation {
  int id;
  String name;
  String image;
  String ki;
  Transformation(
      {required this.id,
      required this.name,
      required this.image,
      required this.ki});
}
