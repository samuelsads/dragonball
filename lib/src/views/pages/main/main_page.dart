import 'package:cached_network_image/cached_network_image.dart';
import 'package:dragonball/src/data/entities/character.dart';
import 'package:dragonball/src/utils/global.dart';
import 'package:dragonball/src/views/blocs/dragonball/dragonball_bloc.dart';
import 'package:dragonball/src/views/delegates/search_delegate_page.dart';
import 'package:dragonball/src/views/pages/character/character_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

late ScrollController _controller;
bool hasNextPage = true;
bool isFirstLoadingRunning = false;
bool isLoadMoreRunning = false;
bool wait = false;
int page = 1;
int limit = 10;
FocusNode _focusNode = FocusNode();
bool _viewSearch = true;
late AnimationController _animationController;
late Animation<double> _fadeAnimation;
late Animation<double> _sizeAnimation;

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _controller = ScrollController()..addListener(_loadMore);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _sizeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<DragonballBloc>().getCharacters();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    _controller.dispose();
    _animationController.dispose();

    super.dispose();
  }

  void _loadMore() async {
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      //context.read<>().downOrUp = false;
      setState(() {
        _viewSearch = true;
        _animationController.reverse();
      });
    } else if (_controller.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _viewSearch = false;
        _animationController.forward();
      });
    }
    if (hasNextPage &&
        !isFirstLoadingRunning &&
        !isLoadMoreRunning &&
        !wait &&
        _controller.position.extentAfter < 200) {
      isLoadMoreRunning = true;
      wait = true;
      page += 1;
      final response = await context
          .read<DragonballBloc>()
          .getCharacters(page, limit, false);
      wait = false;

      if (!response) {
        hasNextPage = false;
      }

      if (hasNextPage) {
        setState(() {});
      }

      isLoadMoreRunning = false;
    }
  }

  void _showSearch() async {
    final data = await showSearch(
        query: context.read<DragonballBloc>().state.query ?? "",
        context: context,
        delegate: SearchDelegatePage());
    _focusNode.unfocus();
    if (data != null) {
      if (mounted) {
        context.read<DragonballBloc>().cleanData();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CharacterPage(
                      characterId: data.id,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Global.BackgroundDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<DragonballBloc, DragonballState>(
          builder: (context, state) {
            if (state.errorCharacters) {
              return const Center(
                child: Text("Error, contacte con el administrador!"),
              );
            }

            if (state.successCharacters) {
              List<Character> data = (state.characters ?? []);
              final size = MediaQuery.of(context).size;

              return Stack(
                children: [
                  Column(
                    children: [
                      SizeTransition(
                        sizeFactor: _sizeAnimation,
                        axisAlignment: -1.0,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SafeArea(
                            child: GestureDetector(
                              onTap: _showSearch,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 24, right: 24, top: 24),
                                child: TextFormField(
                                  enabled: false,
                                  focusNode: _focusNode,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      hintText: "Buscar personaje",
                                      suffixIcon: const Icon(Icons.search)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return _Item(size, data[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isLoadMoreRunning)
                    Positioned(
                        left: (MediaQuery.of(context).size.width / 2) - 20,
                        bottom: 5,
                        child: const Center(child: CircularProgressIndicator()))
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _Item(Size size, Character data) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CharacterPage(
                    characterId: data.id,
                  ))),
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey,
                  Colors.yellow,
                ]),
            borderRadius: BorderRadius.all(Radius.circular(24))),
        child: SizedBox(
          width: size.width,
          height: size.height * 0.74,
          child: Column(
            children: [
              Hero(
                tag: data.id,
                child: CachedNetworkImage(
                  imageUrl: data.image,
                  width: size.width * 0.3,
                  height: size.height * 0.5,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              _genericText(size, "Nombre: ${data.name}"),
              _genericText(size, "Raza: ${data.race}"),
              _genericText(size, "Base Ki: ${data.ki}"),
              _genericText(size, "Total Ki: ${data.ki}"),
            ],
          ),
        ),
      ),
    );
  }

  Container _genericText(Size size, String title) {
    return Container(
        margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
        width: size.width,
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ));
  }
}
