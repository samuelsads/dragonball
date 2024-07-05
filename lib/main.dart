import 'package:dragonball/src/data/remotes/http_dragonball/http_dragonball_impl.dart';
import 'package:dragonball/src/data/repositories/dragonball/dragonball_repository_impl.dart';
import 'package:dragonball/src/views/blocs/dragonball/dragonball_bloc.dart';
import 'package:dragonball/src/views/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//**https://web.dragonball-api.com/documentation */
void main() => runApp(MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => DragonballBloc(
            DragonballRepositoryImpl(httpDragonball: HttpDragonballImpl())),
      )
    ], child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
