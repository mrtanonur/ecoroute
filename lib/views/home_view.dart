import 'package:ecoroute/core/widgets/ecoroute_bottom_navigation_bar.dart';
import 'package:ecoroute/view_models/main_view_model.dart';
import 'package:ecoroute/views/favorites_view.dart';
import 'package:ecoroute/views/maps_view.dart';
import 'package:ecoroute/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<MainViewModel>().navigationIndex,
        children: [MapsView(), FavoritesView(), SettingsView()],
      ),
      bottomNavigationBar: EcorouteBottomNavigationBar(),
    );
  }
}
