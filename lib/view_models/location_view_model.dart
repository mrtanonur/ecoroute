import 'package:ecoroute/dependency_injection.dart';
import 'package:ecoroute/models/park_model.dart';
import 'package:ecoroute/services/googlemaps_service.dart';
import 'package:ecoroute/services/open_weather_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum LocationStatus {
  initial,
  loading,
  locationPermissionAllowed,
  locationLoaded,
  parksLoaded,
  routeLoaded,
  failure,
}

class LocationViewModel extends ChangeNotifier {
  final GoogleMapsService _googleMapsService = sl.get<GoogleMapsService>();
  final OpenWeatherService _openWeatherSevice = sl.get<OpenWeatherService>();

  List<ParkModel> parks = [];
  Position? position;
  LocationStatus status = LocationStatus.initial;
  int parkNavigationIndex = 0;
  GoogleMapController? _mapController;
  String? error;
  bool shouldUpdateCamera = false;
  Map<String, List<LatLng>> routeCoordinates = {
    "walking": [],
    "cycling": [],
    "driving": [],
  };

  // Polylines for each mode
  Map<String, Set<Polyline>> routePolylines = {
    "walking": {},
    "cycling": {},
    "driving": {},
  };

  Set<Polyline> activePolylines = {};

  String currentRouteTab = "walking";
  Map<LatLng, int> routePollution = {};
  int? destinationAqi;

  String? selectedParkId;

  void setSelectedPark(String id) {
    selectedParkId = id;
  }

  // fetch air pollution data
  Future fetchAirPollutionForDestination(String mode) async {
    if (routeCoordinates[mode] == null || routeCoordinates[mode]!.isEmpty) {
      return;
    }
    routePollution.clear();

    final destination = routeCoordinates[mode]!.last;
    final response = await _openWeatherSevice.getAirPollutionData(
      destination.latitude,
      destination.longitude,
    );
    response.fold(
      (String errorMessage) {
        error = errorMessage;
      },
      (int aqi) {
        destinationAqi = aqi;
      },
    );

    notifyListeners();
  }

  // Add method to set map controller
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // set navigationIndex
  void setNavigationIndex(index) {
    parkNavigationIndex = index;
    notifyListeners();
  }

  // set location status
  void setStatus(LocationStatus newStatus) {
    status = newStatus;
    notifyListeners();
  }

  // request permission access
  Future requestPermissionAccess() async {
    status = LocationStatus.loading;
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) {
      final permissionResult = await Geolocator.requestPermission();
      if (permissionResult == LocationPermission.whileInUse ||
          permissionResult == LocationPermission.always) {
        status = LocationStatus.locationPermissionAllowed;
      }
    }
    notifyListeners();
  }

  // get user location
  Future getUserLocation() async {
    status = LocationStatus.loading;
    position = await Geolocator.getCurrentPosition();
    status = LocationStatus.locationLoaded;
    notifyListeners();
  }

  // get nearby parks
  Future getNearbyParks() async {
    final response = await _googleMapsService.getNearbyParks(
      position!.latitude,
      position!.longitude,
    );
    response.fold((Object errorMessage) {}, (List<ParkModel> list) {
      parks = list;
      status = LocationStatus.parksLoaded;
    });
    notifyListeners();
  }

  // fetching the route
  Future fetchRoute(String mode) async {
    if (position == null || parks.isEmpty) {
      return;
    }

    status = LocationStatus.loading;
    notifyListeners();

    final points = await _googleMapsService.getRoute(
      LatLng(position!.latitude, position!.longitude),
      LatLng(
        parks[parkNavigationIndex].latitude,
        parks[parkNavigationIndex].longitude,
      ),
      mode,
    );

    if (points.isEmpty) {
      return;
    }

    // Save coordinates
    routeCoordinates[mode] = points;

    // Clear old polyline for this mode
    routePolylines[mode] = {};

    // Animate polyline drawing
    List<LatLng> animatedPoints = [];
    for (int i = 0; i < points.length; i++) {
      animatedPoints.add(points[i]);

      routePolylines[mode] = {
        Polyline(
          patterns: mode == "walking"
              ? [PatternItem.dash(15), PatternItem.gap(5)]
              : [],
          polylineId: PolylineId(mode),
          points: List.from(animatedPoints), // clone so it updates
          color: mode == "walking"
              ? Colors.blue
              : mode == "cycling"
              ? Colors.orange
              : Colors.green,
          width: 10,
        ),
      };

      if (currentRouteTab == mode) {
        activePolylines = routePolylines[mode]!;
        status = LocationStatus.routeLoaded;
        shouldUpdateCamera = true;

        // fetch pollution data
      }

      notifyListeners();

      // Small delay for animation effect (tweak this value)
      await Future.delayed(const Duration(milliseconds: 150));
    }

    await fetchAirPollutionForDestination(mode);
  }

  // Add method to fit camera to route
  Future<void> fitCameraToRoute() async {
    if (_mapController == null || activePolylines.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 500));
    // Get all points from active polylines
    List<LatLng> allPoints = [];
    for (var polyline in activePolylines) {
      allPoints.addAll(polyline.points);
    }

    if (allPoints.isEmpty) return;

    // Calculate bounds
    double minLat = allPoints
        .map((p) => p.latitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLat = allPoints
        .map((p) => p.latitude)
        .reduce((a, b) => a > b ? a : b);
    double minLng = allPoints
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLng = allPoints
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // Animate camera to fit bounds
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0), // 100.0 is padding
    );

    shouldUpdateCamera = false;
    notifyListeners();
  }

  Future<void> setActiveRoute(String mode, {bool force = false}) async {
    currentRouteTab = mode;

    if (!force && routePolylines[mode]!.isNotEmpty) {
      activePolylines = routePolylines[mode]!;
      status = LocationStatus.routeLoaded;
      notifyListeners();
    } else {
      // Otherwise fetch route
      await fetchRoute(mode);
    }
    notifyListeners();
  }

  void clearAllRoutes() {
    routeCoordinates = {"walking": [], "cycling": [], "driving": []};

    routePolylines = {"walking": {}, "cycling": {}, "driving": {}};

    activePolylines = {};
    notifyListeners();
  }
}
