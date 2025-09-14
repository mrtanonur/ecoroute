import 'dart:io';

import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/main_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EcorouteBottomNavigationBar extends StatefulWidget {
  const EcorouteBottomNavigationBar({super.key});

  @override
  State<EcorouteBottomNavigationBar> createState() =>
      _EcorouteBottomNavigationBarState();
}

class _EcorouteBottomNavigationBarState
    extends State<EcorouteBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomNavigationBar(
        currentIndex: context.watch<MainViewModel>().navigationIndex,
        onTap: (index) {
          context.read<MainViewModel>().changeNavigationIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.maps,
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.favorites,
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
            icon: Icon(Icons.settings),
          ),
        ],
      );
    } else {
      return CupertinoTabBar(
        currentIndex: context.watch<MainViewModel>().navigationIndex,
        onTap: (index) {
          context.read<MainViewModel>().changeNavigationIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.maps,
            icon: Icon(Icons.map),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.favorites,
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
            icon: Icon(Icons.settings),
          ),
        ],
      );
    }
  }
}
