// Widget to fetch and display initiatives count
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiative_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        final isMobile = AppConstants.isMobile(context);
        final double cardPaddingHeight = isMobile ? 4 : 6;
        final double cardPaddingWidth = isMobile ? 6 : 10;
        final double containerPadding = isMobile ? 8 : 14;
        final double containerPaddingTop = 2;
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
            padding: EdgeInsets.symmetric(
              horizontal: cardPaddingWidth,
              vertical: cardPaddingHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => safeGo(context, '/initiatives'),
                      child: Container(
                        padding: EdgeInsets.all(isMobile ? 10 : 12),
                        decoration: BoxDecoration(
                          color: widget.color.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: isMobile ? 2 : 0),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: isMobile ? 20 : 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: isMobile
                            ? () => safeGo(context, '/initiatives')
                            : null,
                        splashColor: isMobile
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(30)
                            : null,
                        highlightColor: isMobile
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(20)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Initiatives',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              if (isMobile) ...[
                                const SizedBox(width: 6),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withAlpha(18),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withAlpha(38),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.open_in_new,
                                      size: 14,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.color
                                          ?.withAlpha(210),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 8 : 8),
                // Riverpod AsyncNotifierProvider usage
                Builder(
                  builder: (context) {
                    final initiativesAsync = ref.watch(
                      featuredInitiativeProvider,
                    );
                    final previousData = initiativesAsync.asData?.value;
                    return initiativesAsync.when(
                      loading: () {
                        if (previousData != null) {
                          final countWidget = SummaryCount(
                            count: previousData.length,
                          );
                          if (previousData.isEmpty) {
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
                                    controller: _scrollController,
                                    thickness: isMobile ? 4 : 6,
                                    child: isMobile
                                        ? ListView.separated(
                                            controller: _scrollController,
                                            scrollDirection: Axis.vertical,
                                            itemCount: previousData.length,
                                            separatorBuilder: (context, idx) =>
                                                SizedBox(height: 12),
                                            itemBuilder: (context, idx) {
                                              final initiative =
                                                  previousData[idx];
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
                                                      (constraints.maxWidth /
                                                          2) /
                                                      ((constraints.maxHeight -
                                                              60) /
                                                          2),
                                                ),
                                            itemCount: previousData.length,
                                            itemBuilder: (context, idx) {
                                              final initiative =
                                                  previousData[idx];
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
                                const SizedBox(height: 4),
                                countWidget,
                              ],
                            ),
                          );
                        }
                        return const Expanded(
                          child: Center(child: CircularProgressIndicator()),
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
                      data: (initiatives) {
                        final countWidget = SummaryCount(
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
                                  controller: _scrollController,
                                  thickness: isMobile ? 4 : 6,
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
                              const SizedBox(height: 4),
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
