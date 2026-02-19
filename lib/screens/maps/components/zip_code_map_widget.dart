// import 'package:collective_action_frontend/api/lib/api.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// /// Widget for zip code map type - displays zip codes and allows claiming
// class ZipCodeMapWidget extends ConsumerStatefulWidget {
//   final MapCampaignSchema campaign;
//   final GoogleMapController? mapController;
//   final String? selectedPurpose; // Purpose selected in parent dropdown

//   const ZipCodeMapWidget({
//     super.key,
//     required this.campaign,
//     this.mapController,
//     this.selectedPurpose,
//   });

//   @override
//   ConsumerState<ZipCodeMapWidget> createState() => _ZipCodeMapWidgetState();
// }

// class _ZipCodeMapWidgetState extends ConsumerState<ZipCodeMapWidget> {
//   Set<Polygon> _zipCodePolygons = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadZipCodeData();
//   }

//   @override
//   void didUpdateWidget(ZipCodeMapWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.selectedPurpose != widget.selectedPurpose) {
//       _loadZipCodeData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final purpose = widget.selectedPurpose ?? widget.campaign.purpose ?? '';

//     return GoogleMap(
//       initialCameraPosition: const CameraPosition(
//         target: LatLng(40.7128, -74.0060),
//         zoom: 11.0,
//       ),
//       onMapCreated: (GoogleMapController c) {
//         // Controller managed by parent
//       },
//       polygons: _zipCodePolygons,
//       // onTap: _handleZipCodeTap,
//       mapType: MapType.normal,
//       zoomControlsEnabled: false,
//       myLocationButtonEnabled: true,
//       myLocationEnabled: true,
//     );
//   }

//   void _handleZipCodeTap(LatLng position) {
//     // TODO: Determine which zip code was tapped
//     // Show claim dialog if not already claimed
//     _showClaimDialog(position);
//   }

//   void _loadZipCodeData() {
//     // TODO: Load zip code polygons from JSON data using zipCodeDataProvider
//     // TODO: Load user claims for this purpose using zipCodeClaimsByPurposeProvider
//     // This will be implemented when backend endpoints are available
//   }

//   void _showClaimDialog(LatLng position) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Claim Zip Code'),
//         content: const Text('Claim this zip code after completing a cleanup?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               // TODO: Submit zip code claim
//               Navigator.of(context).pop();
//             },
//             child: const Text('Claim'),
//           ),
//         ],
//       ),
//     );
//   }
// }
