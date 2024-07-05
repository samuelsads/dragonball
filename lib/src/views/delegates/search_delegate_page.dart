import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/utils/global.dart';
import 'package:dragonball/src/views/blocs/dragonball/dragonball_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchDelegatePage extends SearchDelegate<Character?> {
  Timer? timer;

  @override
  String get searchFieldLabel => 'Buscar por nombre';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
          animate: query.isNotEmpty,
          child: IconButton(
              onPressed: () {
                query = '';
                //context.read<DragonballBloc>().cleanData();
              },
              icon: const Icon(Icons.clear)))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          //context.read<DragonballBloc>().cleanData();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("buildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<DragonballBloc>().getBySearch(query);
      }
    });

    return Container(
      decoration: Global.BackgroundDecoration(),
      child: BlocBuilder<DragonballBloc, DragonballState>(
        builder: (context, state) {
          if (state.loadingCharacterBySearch && (state.search ?? []).isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.errorCharacterBySearch) {
            return Center(
              child: Container(
                child: const Text("ERROR AL CARGAR LA INFORMACIÓN"),
              ),
            );
          }

          if (state.successCharacterBySearch ||
              (state.lastSearch ?? []).isNotEmpty) {
            final items = (state.search ?? []);

            if (items.isEmpty) {
              return const Center(
                child: Text("Sin información"),
              );
            }
            return Container(
              margin: const EdgeInsets.only(top: 10, left: 24, right: 24),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final data = state.search!;
                  return GestureDetector(
                    onTap: () {
                      close(context, data[index]);
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: data[index].image,
                              width: 40,
                              height: 40,
                              progressIndicatorBuilder:
                                  (context, url, progress) => const Center(
                                child: SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator()),
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              height: 40,
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                data[index].name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return SizedBox.fromSize();
        },
      ),
    );
  }
}
