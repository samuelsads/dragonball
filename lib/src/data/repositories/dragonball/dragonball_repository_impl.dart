import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/data/remotes/http_dragonball/http_dragonball.dart';
import 'package:dragonball/src/data/repositories/dragonball/dragonball_repository.dart';

class DragonballRepositoryImpl extends DragonballRepository {
  final HttpDragonball httpDragonball;

  DragonballRepositoryImpl({required this.httpDragonball});

  @override
  Future<List<Character>> getCharacters(int page, int limit) async =>
      await httpDragonball.getCharacters(page, limit);

  @override
  Future<Character> getCharacterById(int characterId) async =>
      await httpDragonball.getCharacterById(characterId);

  @override
  Future<List<Character>> getCharactersByQuery(String query) async =>
      await httpDragonball.getCharactersByQuery(query);
}
