// Widget to fetch and display initiatives count
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiative_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';

/// On mobile web we delay watching the provider to stagger dashboard load.
const Duration _kMobileWebInitiativesDelay = Duration(milliseconds: 80);

class InitiativesSummary extends ConsumerStatefulWidget {
  final IconData icon;
  final Color color;
  const InitiativesSummary({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  ConsumerState<InitiativesSummary> createState() => _InitiativesSummaryState();
}

class _InitiativesSummaryState extends ConsumerState<InitiativesSummary> {
  final ScrollController _scrollController = ScrollController();
  bool _canLoadData = true;
  bool _didScheduleDelay = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didScheduleDelay) return;
    if (kIsWeb && AppConstants.isMobile(context)) {
      _didScheduleDelay = true;
      // Skip delay if data is already cached (navigating back, not first load).
      final alreadyCached = ref.read(featuredInitiativeProvider).hasValue;
      if (alreadyCached) return;
      _canLoadData = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Future.delayed(_kMobileWebInitiativesDelay, () {
          if (mounted) setState(() => _canLoadData = true);
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildGradientHeader(BuildContext context, bool isMobile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradStart = isDark
        ? Color.lerp(widget.color, Colors.black, 0.45)!
        : const Color(0xFF1E3A8A);
    final gradEnd = isDark
        ? Color.lerp(widget.color, Colors.black, 0.15)!
        : widget.color;

    return InkWell(
      onTap: () => safeGo(context, '/initiatives'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14, isMobile ? 9 : 12, 14, isMobile ? 9 : 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradStart, gradEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 5 : 7),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: isMobile ? 17 : 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Initiatives',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: isMobile ? 14 : 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (!isMobile)
                    Text(
                      'Community driven goals',
                      style: TextStyle(
                        color: Colors.white.withAlpha(210),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withAlpha(200),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, bool isMobile) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildGradientHeader(context, isMobile),
          const Expanded(
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppConstants.isMobile(context);
        if (!_canLoadData) {
          return _buildPlaceholder(context, isMobile);
        }
        final double titleFontSize = isMobile ? 14 : 18;
        final double descFontSize = isMobile ? 11 : 13;
        final double progressHeight = isMobile ? 16 : 24;
        final double progressFontSize = isMobile ? 10 : 14;
        final double spacing = isMobile ? 8 : 14;
        final double containerPadding = isMobile ? 8 : 14;
        const double containerPaddingTop = 2;
        // Approximate header + content padding height for grid aspect ratio.
        const double reservedHeight = 85.0;
        final List<Color> palette = [
          Colors.green,
          Colors.blue,
          Colors.orange,
          Colors.purple,
          Colors.teal,
          Colors.red,
          Colors.indigo,
          Colors.cyan,
          Colors.amber,
          Colors.deepPurple,
        ];

        Widget buildList(List initiatives) {
          if (initiatives.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('No initiatives found.'),
                const SizedBox(height: 8),
                SummaryCount(count: initiatives.length),
              ],
            );
          }
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thickness: isMobile ? 4 : 6,
                    child: isMobile
                        ? ListView.separated(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            itemCount: initiatives.length,
                            separatorBuilder: (context, idx) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, idx) {
                              final initiative = initiatives[idx];
                              final cardColor = palette[idx % palette.length];
                              return InitiativeCard(
                                initiative: initiative,
                                cardColor: cardColor,
                                isMobile: isMobile,
                                showCreatedBy: false,
                                titleFontSize: titleFontSize,
                                descFontSize: descFontSize,
                                progressHeight: progressHeight,
                                progressFontSize: progressFontSize,
                                spacing: spacing,
                                containerPadding: containerPadding,
                                containerPaddingTop: containerPaddingTop,
                              );
                            },
                          )
                        : GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio:
                                      (constraints.maxWidth / 2) /
                                      ((constraints.maxHeight - reservedHeight) /
                                          2),
                                ),
                            itemCount: initiatives.length,
                            itemBuilder: (context, idx) {
                              final initiative = initiatives[idx];
                              final cardColor = palette[idx % palette.length];
                              return InitiativeCard(
                                initiative: initiative,
                                cardColor: cardColor,
                                isMobile: isMobile,
                                showCreatedBy: false,
                                titleFontSize: titleFontSize,
                                descFontSize: descFontSize,
                                progressHeight: progressHeight,
                                progressFontSize: progressFontSize,
                                spacing: spacing,
                                containerPadding: containerPadding,
                                containerPaddingTop: containerPaddingTop,
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Builder(
                  builder: (context) {
                    final count = initiatives.length;
                    return SummaryCount(count: count);
                  },
                ),
              ],
            ),
          );
        }

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _buildGradientHeader(context, isMobile),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 8 : 12,
                    isMobile ? 6 : 8,
                    isMobile ? 8 : 12,
                    isMobile ? 4 : 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          final initiativesAsync =
                              ref.watch(featuredInitiativeProvider);
                          final previousData = initiativesAsync.asData?.value;
                          return initiativesAsync.when(
                            loading: () {
                              if (previousData != null) {
                                return buildList(previousData);
                              }
                              return const Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            error: (err, stack) => const Expanded(
                              child: Center(
                                child: Text(
                                  'Failed to load initiatives',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            data: (initiatives) => buildList(initiatives),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
