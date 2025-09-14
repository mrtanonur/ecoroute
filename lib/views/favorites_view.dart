import 'package:ecoroute/core/widgets/ecoroute_app_bar.dart';
import 'package:ecoroute/core/widgets/ecoroute_park_tile.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/favorite_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  FavoriteViewModel? _favoriteViewModel;

  @override
  void initState() {
    super.initState();
    _favoriteViewModel = context.read<FavoriteViewModel>();
    _favoriteViewModel!.getFavorites();
    _favoriteViewModel!.addListener(favoriteListener);
  }

  @override
  void dispose() {
    _favoriteViewModel!.removeListener(favoriteListener);
    super.dispose();
  }

  void favoriteListener() {
    FavoriteStatus status = _favoriteViewModel!.status;
    if (status == FavoriteStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_favoriteViewModel!.error!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: EcorouteAppBar(
        title: AppLocalizations.of(context)!.favorites,
        color: Theme.of(context).colorScheme.surfaceBright,
        hasLeading: false,
      ),
      body: Consumer<FavoriteViewModel>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
            child: ListView.separated(
              itemCount: provider.favoriteParks.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: SizeConstants.s4);
              },
              itemBuilder: (context, index) {
                return EcorouteParkTile(
                  park: provider.favoriteParks[index]!,
                  showGetDirections: false,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
