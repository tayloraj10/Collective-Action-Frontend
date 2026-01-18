// Widget to fetch and display initiatives count
import 'package:collective_action_frontend/screens/dashboard/components/initiave_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;
        final double cardPadding = isMobile ? 10 : 20;
        final double containerPadding = isMobile ? 8 : 14;
        final double containerPaddingTop = isMobile ? 8 : 14;
        final double titleFontSize = isMobile ? 14 : 18;
        final double descFontSize = isMobile ? 11 : 13;
        final double progressHeight = isMobile ? 16 : 24;
        final double progressFontSize = isMobile ? 10 : 14;
        final double spacing = isMobile ? 8 : 14;
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
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 7 : 12),
                      decoration: BoxDecoration(
                        color: widget.color.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: isMobile ? 22 : 28,
                      ),
                    ),
                    SizedBox(width: isMobile ? 7 : 12),
                    Expanded(
                      child: Text(
                        'Initiatives',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 15 : 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 8 : 16),
                // Riverpod AsyncNotifierProvider usage
                Builder(
                  builder: (context) {
                    final initiativesAsync = ref.watch(
                      activeInitiativeProvider,
                    );
                    return initiativesAsync.when(
                      loading: () => const Text(
                        'Loading...',
                        style: TextStyle(color: Colors.grey),
                      ),
                      error: (err, stack) => Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                      data: (initiatives) {
                        final countWidget = InitiativeCount(
                          count: initiatives.length,
                        );
                        if (initiatives.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('No initiatives found.'),
                              const SizedBox(height: 8),
                              countWidget,
                            ],
                          );
                        }
                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: _scrollController,
                                  child: isMobile
                                      ? ListView.separated(
                                          controller: _scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemCount: initiatives.length,
                                          separatorBuilder: (context, idx) =>
                                              SizedBox(height: 12),
                                          itemBuilder: (context, idx) {
                                            final initiative = initiatives[idx];
                                            final cardColor =
                                                palette[idx % palette.length];
                                            return InitiativeCard(
                                              initiative: initiative,
                                              cardColor: cardColor,
                                              isMobile: isMobile,
                                              titleFontSize: titleFontSize,
                                              descFontSize: descFontSize,
                                              progressHeight: progressHeight,
                                              progressFontSize:
                                                  progressFontSize,
                                              spacing: spacing,
                                              containerPadding:
                                                  containerPadding,
                                              containerPaddingTop:
                                                  containerPaddingTop,
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
                                                    ((constraints.maxHeight -
                                                            60) /
                                                        2),
                                              ),
                                          itemCount: initiatives.length,
                                          itemBuilder: (context, idx) {
                                            final initiative = initiatives[idx];
                                            final cardColor =
                                                palette[idx % palette.length];
                                            return InitiativeCard(
                                              initiative: initiative,
                                              cardColor: cardColor,
                                              isMobile: isMobile,
                                              titleFontSize: titleFontSize,
                                              descFontSize: descFontSize,
                                              progressHeight: progressHeight,
                                              progressFontSize:
                                                  progressFontSize,
                                              spacing: spacing,
                                              containerPadding:
                                                  containerPadding,
                                              containerPaddingTop:
                                                  containerPaddingTop,
                                            );
                                          },
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              countWidget,
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
