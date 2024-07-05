import 'package:dragonball/src/data/entities/character.dart';

abstract class DragonballRepository {
  Future<List<Character>> getCharacters(int page, int limit);

  Future<Character> getCharacterById(int characterId);

  Future<List<Character>> getCharactersByQuery(String query);
}
