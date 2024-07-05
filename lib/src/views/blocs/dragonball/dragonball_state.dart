part of 'dragonball_bloc.dart';

enum DragonballStatus { initial, loading, success, error, done }

enum CharacterByIdStatus { initial, loading, success, error, done }

enum CharacterByQuery { initial, loading, success, error, done }

class DragonballState extends Equatable {
  final List<Character>? characters;
  final DragonballStatus? status;

  final Character? character;
  final CharacterByIdStatus? characterByIdStatus;
  final String? query;
  final List<Character>? lastSearch;
  final List<Character>? search;
  final CharacterByQuery? statusByQuery;
  const DragonballState(
      {this.characters,
      this.status,
      this.character,
      this.characterByIdStatus,
      this.search,
      this.statusByQuery,
      this.query,
      this.lastSearch});

  DragonballState copyWith(
          {List<Character>? characters,
          DragonballStatus? status,
          Character? character,
          CharacterByIdStatus? characterByIdStatus,
          List<Character>? search,
          CharacterByQuery? statusByQuery,
          String? query,
          List<Character>? lastSearch}) =>
      DragonballState(
          characters: characters ?? this.characters,
          status: status ?? this.status,
          character: character ?? this.character,
          characterByIdStatus: characterByIdStatus ?? this.characterByIdStatus,
          search: search ?? this.search,
          statusByQuery: statusByQuery ?? this.statusByQuery,
          query: query ?? this.query,
          lastSearch: lastSearch ?? this.lastSearch);
  @override
  List<Object?> get props => [
        characters,
        status,
        character,
        characterByIdStatus,
        search,
        statusByQuery,
        query,
        lastSearch
      ];
}

extension DragonballStateX on DragonballState {
  bool get errorCharacters => status == DragonballStatus.error;
  bool get initialCharacters => status == DragonballStatus.initial;
  bool get successCharacters => status == DragonballStatus.success;
  bool get loadingCharacters => status == DragonballStatus.loading;
  bool get doneCharacters => status == DragonballStatus.done;

  bool get errorCharacter => characterByIdStatus == CharacterByIdStatus.error;
  bool get initialCharacter =>
      characterByIdStatus == CharacterByIdStatus.initial;
  bool get successCharacter =>
      characterByIdStatus == CharacterByIdStatus.success;
  bool get loadingCharacter =>
      characterByIdStatus == CharacterByIdStatus.loading;
  bool get doneCharacter => characterByIdStatus == CharacterByIdStatus.done;

  bool get errorCharacterBySearch => statusByQuery == CharacterByQuery.error;
  bool get initialCharacterBySearch =>
      statusByQuery == CharacterByQuery.initial;
  bool get successCharacterBySearch =>
      statusByQuery == CharacterByQuery.success;
  bool get loadingCharacterBySearch =>
      statusByQuery == CharacterByQuery.loading;
  bool get doneCharacterBySearch => statusByQuery == CharacterByQuery.done;
}
