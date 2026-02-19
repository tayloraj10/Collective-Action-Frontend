// import 'package:collective_action_frontend/api/lib/api.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// /// Dialog to capture route event data when finishing a drawn route.
// class RouteEventDialog extends StatefulWidget {
//   final List<LatLng> waypoints;

//   const RouteEventDialog({super.key, required this.waypoints});

//   @override
//   State<RouteEventDialog> createState() => _RouteEventDialogState();
// }

// class _RouteEventDialogState extends State<RouteEventDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _routeNameController = TextEditingController();
//   final _bagsController = TextEditingController();
//   final _weightController = TextEditingController();

//   @override
//   void dispose() {
//     _routeNameController.dispose();
//     _bagsController.dispose();
//     _weightController.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     if (!_formKey.currentState!.validate()) return;
//     final waypoints = widget.waypoints.asMap().entries.map((e) {
//       return CleanupWaypoint(
//         lat: e.value.latitude,
//         lng: e.value.longitude,
//         number: e.key + 1,
//       );
//     }).toList();
//     final eventData = CleanupRouteEventData(
//       name: '',
//       routeName: _routeNameController.text.trim().isEmpty
//           ? 'Route'
//           : _routeNameController.text.trim(),
//       waypoints: waypoints,
//     );
//     Navigator.of(context).pop(eventData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     final maxH = (size.height * 0.6).clamp(200.0, 450.0);
//     final maxW = (size.width * 0.95).clamp(280.0, 400.0);
//     return Dialog(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: maxW,
//           maxHeight: maxH,
//           minWidth: 280,
//           minHeight: 200,
//         ),
//         child: Material(
//           borderRadius: BorderRadius.circular(28),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Save Route',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Flexible(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           TextFormField(
//                             controller: _routeNameController,
//                             decoration: const InputDecoration(
//                               labelText: 'Route name',
//                               border: OutlineInputBorder(),
//                             ),
//                             validator: (v) => (v == null || v.trim().isEmpty)
//                                 ? 'Enter a route name'
//                                 : null,
//                           ),
//                           const SizedBox(height: 12),
//                           TextFormField(
//                             controller: _bagsController,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: '# of bags (optional)',
//                               border: OutlineInputBorder(),
//                             ),
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(
//                                 RegExp(r'[\d.]'),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                           TextFormField(
//                             controller: _weightController,
//                             keyboardType: const TextInputType.numberWithOptions(
//                               decimal: true,
//                             ),
//                             decoration: const InputDecoration(
//                               labelText: 'Pounds of trash (optional)',
//                               border: OutlineInputBorder(),
//                             ),
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(
//                                 RegExp(r'[\d.]'),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '${widget.waypoints.length} points',
//                             style: Theme.of(context).textTheme.bodySmall,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: const Text('Cancel'),
//                       ),
//                       const SizedBox(width: 8),
//                       FilledButton(
//                         onPressed: _submit,
//                         child: const Text('Submit'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
