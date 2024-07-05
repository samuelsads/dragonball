import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/data/mappers/transformation_mapper.dart';
import 'package:dragonball/src/data/models/character_model.dart' as CMO;
import 'package:dragonball/src/data/models/characters_model.dart' as CM;

class CharacterMapper {
  static Character character(CMO.CharacterModel c) => Character(
      id: c.id ?? 0,
      name: c.name ?? "",
      ki: c.ki ?? "",
      maxKi: c.maxKi ?? "",
      race: c.race ?? "",
      afilliations: c.affiliation ?? "",
      gender: (c.gender == "Male") ? "Masculino" : "Femenino",
      description: c.description ?? "",
      image: c.image ?? "",
      originPlanet: (c.originPlanet == null)
          ? null
          : OriginPlanet(
              id: c.originPlanet?.id ?? 0,
              name: c.originPlanet?.name ?? "",
              isDestroyed: c.originPlanet?.isDestroyed ?? false,
              description: c.originPlanet?.description ?? "",
              image: c.originPlanet?.image ?? ""),
      transformations: (c.transformations ?? [])
          .map((e) => TransformationMapper.transformationById(e))
          .toList());

  static Character characters(CM.Item c) => Character(
      id: c.id,
      name: c.name,
      ki: c.ki,
      maxKi: c.maxKi,
      race: c.race,
      gender: (c.gender == "Male") ? "Masculino" : "Femenino",
      description: c.description,
      afilliations: c.affiliation,
      image: c.image,
      originPlanet: (c.originPlanet == null)
          ? null
          : OriginPlanet(
              id: c.originPlanet!.id,
              name: c.originPlanet!.name,
              isDestroyed: c.originPlanet!.isDestroyed,
              description: c.originPlanet!.description,
              image: c.originPlanet!.image),
      transformations: (c.transformations ?? [])
          .map((e) => TransformationMapper.transformation(e))
          .toList());
}
