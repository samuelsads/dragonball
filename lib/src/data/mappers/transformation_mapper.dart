import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/data/models/characters_model.dart' as CM;

import 'package:dragonball/src/data/models/character_model.dart' as CMO;
class TransformationMapper{

  static Transformation transformationById(CMO.Transformation t)=> 
  Transformation(id: t.id??0, name: t.name??"", image: t.image??"", ki: t.ki??"");

  static Transformation transformation(CM.Transformation t)=> 
  Transformation(id: t.id, name: t.name, image: t.image, ki: t.ki);
}