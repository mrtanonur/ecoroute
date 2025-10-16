import 'package:ecoroute/dependency_injection.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/models/park_model.dart';
import 'package:ecoroute/view_models/favorite_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants/constants.dart';

class EcorouteParkTile extends StatelessWidget {
  final ParkModel park;
  final Function()? onTap;
  bool showGetDirections;
  EcorouteParkTile({
    super.key,
    required this.park,
    this.onTap,
    this.showGetDirections = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                park.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConstants.s18,
                ),
              ),
            ),

            IconButton(
              onPressed: () async {
                context.read<FavoriteViewModel>().favorite(park);
                await sl.get<FirebaseAnalytics>().logEvent(name: "favorite");
              },
              icon: context.watch<FavoriteViewModel>().isFavorite(park)
                  ? const Icon(Icons.bookmark)
                  : const Icon(Icons.bookmark_outline),
            ),
          ],
        ),
        Text(park.address, style: const TextStyle(fontSize: SizeConstants.s14)),

        const SizedBox(height: SizeConstants.s4),

        showGetDirections
            ? GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(SizeConstants.s8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.getDirections,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Icon(
                        Icons.directions,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ],
                  ),
                ),
              )
            : Text(""),
      ],
    );
  }
}
