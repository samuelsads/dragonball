import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/data/models/search_model.dart';

class SearchMapper {
  static Character search(SearchModel c) => Character(
      id: c.id ?? 0,
      name: c.name ?? "",
      ki: c.ki ?? "",
      maxKi: c.maxKi ?? "",
      race: c.race ?? "",
      gender: (c.gender == "Male") ? "Masculino" : "Femenino",
      description: c.description ?? "",
      image: c.image ?? "",
      afilliations: "");
}
