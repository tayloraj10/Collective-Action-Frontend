import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/components/leaderboard_dialog.dart';
import 'package:collective_action_frontend/components/stats_dialog.dart';
import 'package:collective_action_frontend/providers/map_provider.dart';
import 'package:collective_action_frontend/providers/map_zoom_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/maps/components/campaign_info_sheet.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_map_widget.dart';
// import 'package:collective_action_frontend/screens/maps/components/zip_code_map_widget.dart'; // restore when re-enabling zip code map
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _controller;
  MapCampaignTypeEnum _selectedCampaignType = MapCampaignTypeEnum.cleanupMap;
  // String? _selectedPurpose; // For zip code maps - uncomment when re-enabling

  bool _showCampaignDrawer = false;
  late final ScrollController _campaignDrawerScrollController;

  @override
  void initState() {
    super.initState();
    _campaignDrawerScrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _campaignDrawerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(campaignDrawerOpenProvider, (prev, next) {
      if (mounted) setState(() => _showCampaignDrawer = next);
    });
    // Watch active campaigns and filter by selected type
    final activeCampaignsAsync = ref.watch(activeMapCampaignsProvider);
    final isLoading = activeCampaignsAsync is AsyncLoading;
    final hasError = activeCampaignsAsync is AsyncError;
    final errorMessage = activeCampaignsAsync.whenOrNull(
      error: (e, _) => e.toString(),
    );
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

    // Show loading, error, or empty state when no campaign is available
    if (selectedCampaign == null) {
      return Scaffold(
        appBar: const CustomAppBar(),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      hasError ? Icons.error_outline : Icons.map_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(100),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hasError
                          ? 'Could not load map campaigns'
                          : 'No active map campaigns',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(180),
                      ),
                    ),
                    if (hasError && errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          errorMessage,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(activeMapCampaignsProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
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
          // Controls overlay (PointerInterceptor so first tap hits buttons, not map, on web)
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: PointerInterceptor(
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
                                      type != MapCampaignTypeEnum.zipCodeMap,
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
                                // Update URL; always use /maps/cleanup to avoid
                                // router redirect (/maps -> /maps/cleanup) which
                                // can trigger double navigation and refresh on mobile web.
                                safeGo(context, '/maps/cleanup');
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
                      //                         ),
                      // Row: Campaign info, Stats, Leaderboard
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (filteredCampaigns.isNotEmpty) ...[
                              Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.surface,
                                child: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    final open = !_showCampaignDrawer;
                                    ref
                                        .read(
                                          campaignDrawerOpenProvider.notifier,
                                        )
                                        .setOpen(open);
                                    setState(() => _showCampaignDrawer = open);
                                  },
                                  tooltip: _showCampaignDrawer
                                      ? 'Close map info'
                                      : 'Map Info',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.surface,
                              child: IconButton(
                                icon: const Icon(Icons.bar_chart_rounded),
                                onPressed: () => scheduleAfterTap(
                                  context,
                                  () => StatsDialog.show(context),
                                ),
                                tooltip: 'Cleanup & trash stats',
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.surface,
                              child: IconButton(
                                icon: const Icon(Icons.emoji_events_outlined),
                                onPressed: () => scheduleAfterTap(
                                  context,
                                  () => LeaderboardDialog.show(context),
                                ),
                                tooltip: 'Leaderboard (bags cleaned)',
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // My pins only filter (below icon row, when logged in)
                      if (ref.watch(currentUserProvider).value != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Tooltip(
                            message:
                                ref.watch(mapFilterMySubmissionsOnlyProvider)
                                ? 'Show all pins on the map'
                                : 'Show only my cleanup & trash report pins',
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.surface,
                              child: InkWell(
                                onTap: () {
                                  final notifier = ref.read(
                                    mapFilterMySubmissionsOnlyProvider.notifier,
                                  );
                                  notifier.setFilter(
                                    !ref.read(
                                      mapFilterMySubmissionsOnlyProvider,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        ref.watch(
                                              mapFilterMySubmissionsOnlyProvider,
                                            )
                                            ? Icons.filter_alt
                                            : Icons.filter_alt_outlined,
                                        size: 22,
                                        color:
                                            ref.watch(
                                              mapFilterMySubmissionsOnlyProvider,
                                            )
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : null,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'My pins only',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              fontWeight:
                                                  ref.watch(
                                                    mapFilterMySubmissionsOnlyProvider,
                                                  )
                                                  ? FontWeight.w600
                                                  : null,
                                              color:
                                                  ref.watch(
                                                    mapFilterMySubmissionsOnlyProvider,
                                                  )
                                                  ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                  : null,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_showCampaignDrawer && filteredCampaigns.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              child: PointerInterceptor(
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  child: Material(
                    elevation: 16,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: CampaignInfoSheet(
                        campaigns: filteredCampaigns,
                        scrollController: _campaignDrawerScrollController,
                        onClose: () {
                          ref
                              .read(campaignDrawerOpenProvider.notifier)
                              .setOpen(false);
                          setState(() => _showCampaignDrawer = false);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
