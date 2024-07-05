part of 'dragonball_bloc.dart';

abstract class DragonballEvent extends Equatable {
  const DragonballEvent();

  @override
  List<Object> get props => [
        const GetCharactersEvent(),
        const GetCharacterById(),
        const SaveQueryEvent()
      ];
}

class SaveQueryEvent extends DragonballEvent {
  final String? query;
  final List<Character>? lastSearch;
  const SaveQueryEvent({this.query, this.lastSearch});
}

class GetCharactersQueryEvent extends DragonballEvent {
  final List<Character>? search;
  final CharacterByQuery? statusByQuery;
  const GetCharactersQueryEvent({this.search, this.statusByQuery});
}

class GetCharacterById extends DragonballEvent {
  final Character? character;
  final CharacterByIdStatus? characterByIdStatus;

  const GetCharacterById({this.character, this.characterByIdStatus});
}

class GetCharactersEvent extends DragonballEvent {
  final List<Character>? characters;
  final DragonballStatus? status;
  const GetCharactersEvent({this.characters, this.status});
}
