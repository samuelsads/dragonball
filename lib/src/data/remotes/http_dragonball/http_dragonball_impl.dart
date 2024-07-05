import 'package:dio/dio.dart';
import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/data/mappers/character_mapper.dart';
import 'package:dragonball/src/data/mappers/search_mapper.dart';
import 'package:dragonball/src/data/models/character_model.dart';
import 'package:dragonball/src/data/models/characters_model.dart' as CM;
import 'package:dragonball/src/data/models/search_model.dart' as SM;
import 'package:dragonball/src/data/remotes/http_dragonball/http_dragonball.dart';

class HttpDragonballImpl extends HttpDragonball {
  final _dio = Dio(BaseOptions(baseUrl: "https://dragonball-api.com/api"));

  @override
  Future<List<Character>> getCharacters(int page, int limit) async {
    List<Character> response;
    CM.Characters characters;

    try {
      final resp = await _dio.get("/characters?page=$page&limit=$limit");
      characters = CM.Characters.fromJson(resp.data);
      response =
          (characters.items).map((e) => CharacterMapper.characters(e)).toList();
    } catch (e) {
      throw Exception(e);
    }

    return response;
  }

  @override
  Future<Character> getCharacterById(int characterId) async {
    Character character;
    CharacterModel item;
    try {
      final resp = await _dio.get("/characters/$characterId");
      item = CharacterModel.fromJson(resp.data);
      character = CharacterMapper.character(item);
    } catch (e) {
      throw Exception(e);
    }

    return character;
  }

  @override
  Future<List<Character>> getCharactersByQuery(String query) async {
    List<Character> response = [];
    SM.SearchModel characters;
    try {
      final resp = await _dio.get("/characters?name=$query");

      final List<dynamic> parsed = resp.data as List<dynamic>;
      final data = parsed
          .map<SM.SearchModel>(
              (json) => SM.SearchModel.fromJson(json as Map<String, dynamic>))
          .toList();
      response = data.map((e) => SearchMapper.search(e)).toList();
    } catch (e) {
      throw Exception(e);
    }

    return response;
  }
}
