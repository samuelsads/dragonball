import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/utils/global.dart';
import 'package:dragonball/src/views/blocs/dragonball/dragonball_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterPage extends StatefulWidget {
  CharacterPage({required this.characterId, super.key});
  int characterId;
  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<DragonballBloc>().getCharacterById(widget.characterId);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DragonballBloc, DragonballState>(
        builder: (context, state) {
          if (state.errorCharacter) {
            return const Center(
              child: Text("Error, contacte con el administrador!"),
            );
          }

          if (state.successCharacter) {
            final size = MediaQuery.of(context).size;
            final data = state.character!;
            return Container(
              decoration: Global.BackgroundDecoration(),
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _customAppbar(size, data),
                    CachedNetworkImage(
                      imageUrl: data.image,
                      height: 200,
                      width: 100,
                    ),
                    _moreDescription(context, size, data),
                    if ((data.transformations ?? []).isNotEmpty)
                      Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: _genericText(size, "Transformaciones")),
                    if ((data.transformations ?? []).isNotEmpty)
                      _transformations(data, size),
                    Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: _genericText(size, "Planeta de origen")),
                    GestureDetector(
                      onTap: () {
                        _showModalDescription(
                            context,
                            size,
                            data.originPlanet?.description ?? "",
                            true,
                            data.originPlanet?.isDestroyed ?? false);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 24, right: 24, top: 8),
                        decoration: Global.CardDecoration(),
                        child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    child: _genericText(
                                        size, data.originPlanet?.name ?? "")),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: CachedNetworkImage(
                                    imageUrl: data.originPlanet?.image ?? "",
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 24),
                                  child: _genericText(
                                    size,
                                    data.originPlanet?.description ?? "",
                                    12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<dynamic> _showModalDescription(
      BuildContext context, Size size, String description,
      [bool isPlanet = false, bool isDestroyed = false]) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: Global.BackgroundDecoration().copyWith(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close))
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    child:
                        _genericText(size, "Descripción detallada", 20, true),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: SingleChildScrollView(
                        child: _genericText(size, description, 12, true)),
                  ),
                  if (isPlanet)
                    Container(
                      margin: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 12,
                      ),
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (isDestroyed) ? Colors.red : Colors.green,
                      ),
                      width: double.infinity,
                      child: _genericText(
                          size,
                          (isDestroyed)
                              ? "Planeta destruido"
                              : "Planeta intacto",
                          18,
                          false,
                          Colors.white),
                    ),
                  Container(
                    height: 20,
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Container _transformations(Character data, Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: CarouselSlider(
        options: CarouselOptions(height: 200.0, autoPlay: true),
        items: (data.transformations ?? []).map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  decoration: Global.CardDecoration(),
                  child: Column(
                    children: [
                      _genericText(size, i.name, 12),
                      CachedNetworkImage(
                        imageUrl: i.image,
                        height: 150,
                        errorWidget: (context, url, error) {
                          return const Center(child: Icon(Icons.image));
                        },
                      ),
                      _genericText(size, "KI: ${i.ki}", 12),
                    ],
                  ));
            },
          );
        }).toList(),
      ),
    );
  }

  Center _notTransformations(Size size) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24),
        height: 200,
        width: double.infinity,
        child: Card(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: const Icon(
                  Icons.face_retouching_off_sharp,
                  size: 70,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: _genericText(
                    size,
                    "Este personaje no cuenta con transformaciones conocidas",
                    18,
                    false),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _moreDescription(
      BuildContext context, Size size, Character data) {
    return GestureDetector(
      onTap: () {
        _showModalDescription(context, size, data.description);
      },
      child: SizedBox(
          height: 120, child: _genericText(size, data.description, 12, false)),
    );
  }

  Widget _customAppbar(Size size, Character data) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          Expanded(child: Container(child: _genericText(size, data.name))),
          Container(
              margin: const EdgeInsets.only(right: 12),
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            decoration: Global.BackgroundDecoration().copyWith(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.close))
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 24, right: 24, top: 24),
                                  alignment: Alignment.centerLeft,
                                  width: double.infinity,
                                  child: _genericText(size,
                                      "Más detalles sobre ${data.name}", 20),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 24, right: 24, top: 12),
                                  alignment: Alignment.centerLeft,
                                  width: double.infinity,
                                  child: _genericText(size, "Ki: ${data.ki}"),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 24, right: 24, top: 12),
                                  width: double.infinity,
                                  child: _genericText(
                                      size, "Max ki: ${data.maxKi}"),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 24, right: 24, top: 12),
                                  width: double.infinity,
                                  child:
                                      _genericText(size, "Raza: ${data.race}"),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 24, right: 24, top: 12),
                                  width: double.infinity,
                                  child: _genericText(
                                      size, "Género: ${data.gender}"),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 24, right: 24, top: 12),
                                  width: double.infinity,
                                  child: _genericText(
                                      size, "Grupo: ${data.afilliations}"),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.info)))
        ],
      ),
    );
  }

  Container _genericText(Size size, String title,
      [double fontSize = 18,
      bool maxLine = false,
      Color color = Colors.black]) {
    return Container(
        margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
        width: size.width,
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.justify,
          overflow: (maxLine) ? null : TextOverflow.ellipsis,
          maxLines: (maxLine) ? null : 4,
          style: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.w700, color: color),
        ));
  }
}
