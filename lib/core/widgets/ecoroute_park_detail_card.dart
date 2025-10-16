import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/models/park_model.dart';
import 'package:ecoroute/view_models/favorite_view_model.dart';
import 'package:ecoroute/view_models/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants/constants.dart';

class EcorouteParkDetailCard extends StatelessWidget {
  const EcorouteParkDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    LocationViewModel viewModel = context.read<LocationViewModel>();
    String? selectedParkId = viewModel.selectedParkId;
    ParkModel park = viewModel.parks.firstWhere(
      (park) => park.id == selectedParkId,
    );
    return DraggableScrollableSheet(
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(SizeConstants.s20),
              topRight: Radius.circular(SizeConstants.s20),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConstants.s12,
            vertical: SizeConstants.s12,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            controller: scrollController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            'parkListPage',
                          );
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          size: SizeConstants.s30,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          park.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: SizeConstants.s18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          context.read<FavoriteViewModel>().favorite(park);
                        },
                        icon:
                            context.watch<FavoriteViewModel>().isFavorite(park)
                            ? const Icon(Icons.bookmark)
                            : const Icon(Icons.bookmark_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeConstants.s4),

                  Text(park.address),
                  const SizedBox(height: SizeConstants.s4),
                  GestureDetector(
                    onTap: () {
                      int index = viewModel.parks.indexWhere(
                        (park) => park.id == selectedParkId,
                      );
                      if (index != -1) {
                        viewModel.parkNavigationIndex = index;
                      }
                      viewModel.clearAllRoutes(); // Clear all cached routes
                      viewModel.setStatus(LocationStatus.routeLoaded);
                      viewModel.setActiveRoute(
                        viewModel.currentRouteTab,
                        force: true,
                      );
                    },
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
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
