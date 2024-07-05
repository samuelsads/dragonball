// To parse this JSON data, do
//
//     final characters = charactersFromJson(jsonString);

import 'dart:convert';

Characters charactersFromJson(String str) => Characters.fromJson(json.decode(str));

String charactersToJson(Characters data) => json.encode(data.toJson());

class Characters {
    List<Item> items;
    Meta meta;
    Links links;

    Characters({
        required this.items,
        required this.meta,
        required this.links,
    });

    factory Characters.fromJson(Map<String, dynamic> json) => Characters(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
        links: Links.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "meta": meta.toJson(),
        "links": links.toJson(),
    };
}

class Item {
    int id;
    String name;
    String ki;
    String maxKi;
    String race;
    String gender;
    String description;
    String image;
    String affiliation;
    dynamic deletedAt;
    OriginPlanet? originPlanet;
    List<Transformation>? transformations;

    Item({
        required this.id,
        required this.name,
        required this.ki,
        required this.maxKi,
        required this.race,
        required this.gender,
        required this.description,
        required this.image,
        required this.affiliation,
        required this.deletedAt,
        this.originPlanet,
        this.transformations,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        ki: json["ki"],
        maxKi: json["maxKi"],
        race: json["race"],
        gender: json["gender"],
        description: json["description"],
        image: json["image"],
        affiliation: json["affiliation"],
        deletedAt: json["deletedAt"],
       originPlanet: json["originPlanet"] == null ? null : OriginPlanet.fromJson(json["originPlanet"]),
        transformations: json["transformations"] == null ? [] : List<Transformation>.from(json["transformations"]!.map((x) => Transformation.fromJson(x)))
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ki": ki,
        "maxKi": maxKi,
        "race": race,
        "gender": gender,
        "description": description,
        "image": image,
        "affiliation": affiliation,
        "deletedAt": deletedAt,
       "originPlanet": originPlanet?.toJson(),
        "transformations": transformations == null ? [] : List<dynamic>.from(transformations!.map((x) => x.toJson())),
    };
}

class OriginPlanet {
    int id;
    String name;
    bool isDestroyed;
    String description;
    String image;
    dynamic deletedAt;

    OriginPlanet({
        required this.id,
        required this.name,
        required this.isDestroyed,
        required this.description,
        required this.image,
        required this.deletedAt,
    });

    factory OriginPlanet.fromJson(Map<String, dynamic> json) => OriginPlanet(
        id: json["id"],
        name: json["name"],
        isDestroyed: json["isDestroyed"],
        description: json["description"],
        image: json["image"],
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isDestroyed": isDestroyed,
        "description": description,
        "image": image,
        "deletedAt": deletedAt,
    };
}

class Transformation {
    int id;
    String name;
    String image;
    String ki;
    dynamic deletedAt;

    Transformation({
        required this.id,
        required this.name,
        required this.image,
        required this.ki,
        required this.deletedAt,
    });

    factory Transformation.fromJson(Map<String, dynamic> json) => Transformation(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        ki: json["ki"],
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "ki": ki,
        "deletedAt": deletedAt,
    };
}

class Links {
    String first;
    String previous;
    String next;
    String last;

    Links({
        required this.first,
        required this.previous,
        required this.next,
        required this.last,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        previous: json["previous"],
        next: json["next"],
        last: json["last"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "previous": previous,
        "next": next,
        "last": last,
    };
}

class Meta {
    int totalItems;
    int itemCount;
    int itemsPerPage;
    int totalPages;
    int currentPage;

    Meta({
        required this.totalItems,
        required this.itemCount,
        required this.itemsPerPage,
        required this.totalPages,
        required this.currentPage,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalItems: json["totalItems"],
        itemCount: json["itemCount"],
        itemsPerPage: json["itemsPerPage"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
    );

    Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "itemCount": itemCount,
        "itemsPerPage": itemsPerPage,
        "totalPages": totalPages,
        "currentPage": currentPage,
    };
}
