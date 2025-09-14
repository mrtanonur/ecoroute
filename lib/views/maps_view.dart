import 'package:ecoroute/core/widgets/ecoroute_park_detail_card.dart';
import 'package:ecoroute/core/widgets/ecoroute_park_tile.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<_ParkListPageState> parkListKey =
      GlobalKey<_ParkListPageState>();
  LocationViewModel? _locationViewModel;
  late TabController _tabController;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging)
        return; // wait for animation to finish
      // Update the active polyline based on selected tab
      String mode;
      switch (_tabController.index) {
        case 0:
          mode = AppLocalizations.of(context)!.walking;
          break;
        case 1:
          mode = AppLocalizations.of(context)!.cycling;
          break;
        case 2:
          mode = AppLocalizations.of(context)!.driving;
          break;
        default:
          mode = AppLocalizations.of(context)!.walking;
      }
      _locationViewModel!.setActiveRoute(mode);
    });

    _locationViewModel = context.read<LocationViewModel>();
    _locationViewModel!.addListener(locationListener);
    checkPermission();
  }

  Future checkPermission() async {
    await context.read<LocationViewModel>().requestPermissionAccess();
  }

  void locationListener() {
    LocationStatus status = _locationViewModel!.status;
    if (status == LocationStatus.locationPermissionAllowed) {
      _locationViewModel!.getUserLocation();
    } else if (status == LocationStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.somethingWentWrong),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }

    // 🎯 ADD THIS: Fit camera when route is loaded
    if (status == LocationStatus.routeLoaded &&
        _locationViewModel!.shouldUpdateCamera) {
      // Use addPostFrameCallback to ensure the map is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _locationViewModel!.fitCameraToRoute();
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _locationViewModel!.setMapController(controller); // 🎯 ADD THIS
  }

  @override
  void dispose() {
    _locationViewModel!.removeListener(locationListener);
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        Set<Marker> markers = {};
        Set<Polyline> polylines = {};

        if (markers.isEmpty &&
            (viewModel.status == LocationStatus.parksLoaded ||
                viewModel.status == LocationStatus.routeLoaded)) {
          markers = viewModel.parks
              .map(
                (park) => Marker(
                  markerId: MarkerId(park.name),
                  position: LatLng(park.latitude, park.longitude),

                  onTap: () {
                    viewModel.setSelectedPark(park.id);
                    parkListKey.currentState?.openDetail();
                  },
                ),
              )
              .toSet();
        }
        switch (viewModel.status) {
          case LocationStatus.loading:
            return const Center(child: CircularProgressIndicator());
          default:
            return Scaffold(
              appBar: viewModel.status == LocationStatus.routeLoaded
                  ? AppBar(
                      leading: null,
                      bottom: TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: AppLocalizations.of(context)!.walking),
                          Tab(text: AppLocalizations.of(context)!.cycling),
                          Tab(text: AppLocalizations.of(context)!.driving),
                        ],
                      ),
                    )
                  : null,
              floatingActionButton:
                  (viewModel.status != LocationStatus.parksLoaded &&
                      viewModel.status != LocationStatus.routeLoaded)
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: SizeConstants.s60),
                      child: FloatingActionButton(
                        child: const Icon(Icons.search),
                        onPressed: () async {
                          await viewModel.getNearbyParks();
                        },
                      ),
                    )
                  : null,
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: markers,
                    polylines: viewModel.activePolylines,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        viewModel.position!.latitude,
                        viewModel.position!.longitude,
                      ),

                      zoom: 18,
                    ),
                  ),
                  if (viewModel.destinationAqi != null)
                    Positioned(
                      bottom: SizeConstants.s300,
                      right: SizeConstants.s20,
                      child: Container(
                        width: SizeConstants.s120,
                        padding: const EdgeInsets.all(SizeConstants.s12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceBright,
                          borderRadius: BorderRadius.circular(
                            SizeConstants.s12,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: SizeConstants.s8),
                            Text(
                              "${AppLocalizations.of(context)!.destinationAqi} ${viewModel.destinationAqi}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: SizeConstants.s16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (viewModel.status == LocationStatus.routeLoaded)
                    Positioned(
                      bottom: SizeConstants.s0,
                      left: SizeConstants.s0,
                      right: SizeConstants.s0,
                      height: SizeConstants.s100, // give it space!
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SizedBox.shrink(),
                          SizedBox.shrink(),
                          SizedBox.shrink(),
                        ],
                      ),
                    ),

                  if (viewModel.status == LocationStatus.parksLoaded ||
                      viewModel.status == LocationStatus.routeLoaded)
                    ParkListPage(key: parkListKey),
                ],
              ),
            );
        }
      },
    );
  }
}

class ParkListPage extends StatefulWidget {
  const ParkListPage({super.key});

  @override
  State<ParkListPage> createState() => _ParkListPageState();
}

class _ParkListPageState extends State<ParkListPage> {
  final GlobalKey<NavigatorState> _innerNavigatorKey =
      GlobalKey<NavigatorState>();

  void openDetail() {
    _innerNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const EcorouteParkDetailCard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    LocationViewModel viewModel = context.read<LocationViewModel>();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.05,
      maxChildSize: 0.9,
      expand: false,

      builder: (context, scrollController) {
        return Navigator(
          key: _innerNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(SizeConstants.s20),
                    topRight: Radius.circular(SizeConstants.s20),
                  ),
                ),
                padding: const EdgeInsets.all(SizeConstants.s8),
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: viewModel.parks.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: SizeConstants.s12);
                  },
                  itemBuilder: (context, index) {
                    return EcorouteParkTile(
                      park: viewModel.parks[index],
                      onTap: () async {
                        viewModel.parkNavigationIndex = index;
                        viewModel.clearAllRoutes(); // Clear all cached routes
                        viewModel.setStatus(LocationStatus.routeLoaded);
                        viewModel.setActiveRoute(
                          viewModel.currentRouteTab,
                          force: true,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
