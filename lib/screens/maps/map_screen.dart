import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/map_provider.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_map_widget.dart';
// import 'package:collective_action_frontend/screens/maps/components/zip_code_map_widget.dart'; // restore when re-enabling zip code map
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _controller;
  MapCampaignTypeEnum _selectedCampaignType = MapCampaignTypeEnum.cleanupMap;
  // String? _selectedPurpose; // For zip code maps - uncomment when re-enabling

  @override
  void initState() {
    super.initState();
    // Update URL to /maps/cleanup if cleanup is selected and we're on /maps
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentPath = GoRouterState.of(context).uri.path;
      if (_selectedCampaignType == MapCampaignTypeEnum.cleanupMap &&
          currentPath == '/maps') {
        context.go('/maps/cleanup');
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showInfoPanel(BuildContext context, List<MapCampaignSchema> campaigns) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (campaigns.isNotEmpty) ...[
                            Text(
                              campaigns.first.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (campaigns.first.description != null &&
                                campaigns.first.description!.isNotEmpty) ...[
                              Text(
                                campaigns.first.description!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                            ],
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Campaign list items can be added here later
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch active campaigns and filter by selected type
    final activeCampaignsAsync = ref.watch(activeMapCampaignsProvider);
    final filteredCampaigns = activeCampaignsAsync.when(
      data: (campaigns) => campaigns.where((campaign) {
        // Compare campaign type string with enum value
        return campaign.mapCampaignType == _selectedCampaignType.value;
      }).toList(),
      loading: () => <MapCampaignSchema>[],
      error: (_, _) => <MapCampaignSchema>[],
    );

    // Get the selected campaign
    final selectedCampaign = filteredCampaigns.isNotEmpty
        ? filteredCampaigns.first
        : null;

    // Zip code map (restore later): unique purposes for purpose dropdown
    // final zipCodePurposes = filteredCampaigns
    //     .where((c) => c.purpose != null && c.purpose!.isNotEmpty)
    //     .map((c) => c.purpose!)
    //     .toSet()
    //     .toList();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: selectedCampaign != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                // Map widget: zip code branch commented out until we re-enable
                if (_selectedCampaignType == MapCampaignTypeEnum.cleanupMap)
                  CleanupMapWidget(
                    campaign: selectedCampaign,
                    mapController: _controller,
                  ),
                // else if (_selectedCampaignType == MapCampaignTypeEnum.zipCodeMap)
                //   ZipCodeMapWidget(
                //     campaign: selectedCampaign,
                //     mapController: _controller,
                //     selectedPurpose: _selectedPurpose,
                //   ),
                // Controls overlay
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Map type selector
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: DropdownButton<MapCampaignTypeEnum>(
                                value: _selectedCampaignType,
                                underline: const SizedBox.shrink(),
                                isDense: true,
                                // Hide zip code map for now; remove .where to show all types
                                items: MapCampaignTypeEnum.values
                                    .where(
                                      (type) =>
                                          type !=
                                          MapCampaignTypeEnum.zipCodeMap,
                                    )
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type.value),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (MapCampaignTypeEnum? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedCampaignType = value;
                                      // _selectedPurpose = null; // uncomment when re-enabling zip code map
                                    });
                                    // Update URL when cleanup is selected
                                    if (value ==
                                        MapCampaignTypeEnum.cleanupMap) {
                                      context.go('/maps/cleanup');
                                    } else {
                                      // For other types, go back to /maps
                                      context.go('/maps');
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          // Purpose selector for zip code maps (restore when re-enabling)
                          // if (_selectedCampaignType == MapCampaignTypeEnum.zipCodeMap && zipCodePurposes.length > 1)
                          //   Padding(
                          //     padding: const EdgeInsets.only(top: 8),
                          //     child: Material(
                          //       elevation: 2,
                          //       borderRadius: BorderRadius.circular(8),
                          //       color: Theme.of(context).colorScheme.surface,
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          //         child: DropdownButton<String>(
                          //           value: _selectedPurpose ?? zipCodePurposes.first,
                          //           underline: const SizedBox.shrink(),
                          //           isDense: true,
                          //           items: zipCodePurposes.map((purpose) => DropdownMenuItem(value: purpose, child: Text(purpose))).toList(),
                          //           onChanged: (String? value) { if (value != null) setState(() => _selectedPurpose = value); },
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // Info button
                          if (filteredCampaigns.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.surface,
                                child: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () => _showInfoPanel(
                                    context,
                                    filteredCampaigns,
                                  ),
                                  tooltip: 'Campaign info',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
