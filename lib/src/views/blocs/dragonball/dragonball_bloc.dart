import 'package:bloc/bloc.dart';
import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/data/repositories/dragonball/dragonball_repository.dart';
import 'package:equatable/equatable.dart';

part 'dragonball_event.dart';
part 'dragonball_state.dart';

class DragonballBloc extends Bloc<DragonballEvent, DragonballState> {
  final DragonballRepository _repository;

  DragonballBloc(this._repository) : super(const DragonballState()) {
    on<GetCharactersEvent>(
      (event, emit) => emit(
          state.copyWith(characters: event.characters, status: event.status)),
    );

    on<GetCharacterById>(
      (event, emit) => emit(state.copyWith(
          character: event.character,
          characterByIdStatus: event.characterByIdStatus)),
    );

    on<GetCharactersQueryEvent>(
      (event, emit) => emit(state.copyWith(
          search: event.search, statusByQuery: event.statusByQuery)),
    );

    on<SaveQueryEvent>(
      (event, emit) => emit(
          state.copyWith(query: event.query, lastSearch: event.lastSearch)),
    );
  }

  Future<void> cleanData() async {
    add(const GetCharactersQueryEvent(
        statusByQuery: CharacterByQuery.initial, search: []));
  }

  Future<void> getBySearch(String query) async {
    add(const GetCharactersQueryEvent(statusByQuery: CharacterByQuery.loading));
    try {
      final data = await _repository.getCharactersByQuery(query);
      add(GetCharactersQueryEvent(
          search: data, statusByQuery: CharacterByQuery.success));
      List<Character> lastSearch = [...data];
      add(SaveQueryEvent(query: query, lastSearch: lastSearch));
    } catch (e) {
      add(const GetCharactersQueryEvent(statusByQuery: CharacterByQuery.error));
    }
  }

  Future<void> getCharacterById(int characterId) async {
    add(const GetCharacterById(
        characterByIdStatus: CharacterByIdStatus.loading));

    try {
      final data = await _repository.getCharacterById(characterId);
      add(GetCharacterById(
          character: data, characterByIdStatus: CharacterByIdStatus.success));
    } catch (e) {
      add(const GetCharacterById(
          characterByIdStatus: CharacterByIdStatus.error));
    }
  }

  Future<bool> getCharacters(
      [int page = 1, int limit = 10, bool reloadStatus = true]) async {
    if (reloadStatus) {
      add(const GetCharactersEvent(status: DragonballStatus.loading));
    }

    try {
      final response = await _repository.getCharacters(page, limit);
      if (response.isEmpty) {
        return false;
      }
      List<Character> totalCharacters = [
        ...state.characters ?? [],
        ...response
      ];
      add(GetCharactersEvent(
          characters: totalCharacters, status: DragonballStatus.success));
    } catch (e) {
      add(const GetCharactersEvent(status: DragonballStatus.error));
      return false;
    }
    return true;
  }
}
