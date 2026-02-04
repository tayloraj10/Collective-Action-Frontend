import 'dart:convert';

import 'package:http/http.dart' as http;

/// A suggested location from search, with parsed city, state, and country.
class LocationSuggestion {
  const LocationSuggestion({
    required this.displayName,
    this.city,
    this.state,
    this.country,
  });

  final String displayName;
  final String? city;
  final String? state;
  final String? country;
}

/// Searches for places using OpenStreetMap Nominatim (free, no API key)
/// and returns results with parsed city, state, and country.
///
/// **Google Places:** Google Place Autocomplete and Place Details require an
/// API key and are paid (free tier available). To use Google instead, you would
/// need to add a backend or use a key in the app (e.g. from config/env), enable
/// "Places API" in Google Cloud, and call the Autocomplete + Place Details APIs.
class LocationSearchService {
  LocationSearchService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = 'https://nominatim.openstreetmap.org';
  static const _limit = 8;

  /// Search for places by query (e.g. city name or "City, Country").
  /// Returns suggestions with [displayName], [city], [state], [country].
  Future<List<LocationSuggestion>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(
      path: 'search',
      queryParameters: {
        'q': trimmed,
        'format': 'json',
        'addressdetails': '1',
        'limit': _limit.toString(),
        'featureType': 'city', // Only cities (not streets, POIs, etc.)
      },
    );

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'CollectiveActionApp/1.0',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final list = json.decode(response.body) as List<dynamic>?;
      if (list == null || list.isEmpty) return [];

      return list.map((e) => _parseResult(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  static LocationSuggestion _parseResult(Map<String, dynamic> json) {
    final displayName = json['display_name'] as String? ?? '';
    final address = json['address'] as Map<String, dynamic>? ?? {};

    final city = _firstOf(
      address,
      ['city', 'town', 'village', 'municipality', 'county', 'locality'],
    );
    final state = _firstOf(
      address,
      ['state', 'state_district', 'region', 'province'],
    );
    final country = address['country'] as String?;

    return LocationSuggestion(
      displayName: displayName,
      city: city,
      state: state,
      country: country,
    );
  }

  static String? _firstOf(Map<String, dynamic> map, List<String> keys) {
    for (final k in keys) {
      final v = map[k];
      if (v is String && v.isNotEmpty) return v;
    }
    return null;
  }
}
