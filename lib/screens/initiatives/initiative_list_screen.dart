import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiative_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitiativeListScreen extends ConsumerStatefulWidget {
  const InitiativeListScreen({super.key});

  @override
  ConsumerState<InitiativeListScreen> createState() =>
      _InitiativeListScreenState();
}

class _InitiativeListScreenState extends ConsumerState<InitiativeListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final double cardPaddingHeight = isMobile ? 8 : 12;
    final double cardPaddingWidth = isMobile ? 12 : 16;
    final double containerPadding = isMobile ? 12 : 18;
    final double containerPaddingTop = 4;
    final double titleFontSize = isMobile ? 16 : 20;
    final double descFontSize = isMobile ? 12 : 14;
    final double progressHeight = isMobile ? 18 : 26;
    final double progressFontSize = isMobile ? 11 : 15;
    final double spacing = isMobile ? 10 : 16;
    final double itemMinHeight = isMobile ? 100 : 140;
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

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.trending_up,
                      color: Theme.of(context).colorScheme.primary,
                      size: isMobile ? 28 : 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Initiatives',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Builder(
                          builder: (context) {
                            final initiativesAsync = ref.watch(
                              activeInitiativeProvider,
                            );
                            return initiativesAsync.when(
                              loading: () => const SizedBox.shrink(),
                              error: (_, _) => const SizedBox.shrink(),
                              data: (initiatives) =>
                                  SummaryCount(count: initiatives.length),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 20 : 28),
              // Initiatives List/Grid
              Expanded(
                child: Builder(
                  builder: (context) {
                    final initiativesAsync = ref.watch(
                      activeInitiativeProvider,
                    );
                    final previousData = initiativesAsync.asData?.value;
                    return initiativesAsync.when(
                      loading: () {
                        if (previousData != null) {
                          if (previousData.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('No initiatives found.'),
                                const SizedBox(height: 8),
                                SummaryCount(count: previousData.length),
                              ],
                            );
                          }
                          return _buildInitiativesList(
                            context: context,
                            initiatives: previousData,
                            isMobile: isMobile,
                            palette: palette,
                            titleFontSize: titleFontSize,
                            descFontSize: descFontSize,
                            progressHeight: progressHeight,
                            progressFontSize: progressFontSize,
                            spacing: spacing,
                            itemMinHeight: itemMinHeight,
                            containerPadding: containerPadding,
                            containerPaddingTop: containerPaddingTop,
                            cardPaddingHeight: cardPaddingHeight,
                            cardPaddingWidth: cardPaddingWidth,
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                      error: (err, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load initiatives',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              err.toString(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(activeInitiativeProvider.notifier)
                                    .refresh();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                      data: (initiatives) {
                        if (initiatives.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No initiatives found',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Check back later for new initiatives',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildInitiativesList(
                          context: context,
                          initiatives: initiatives,
                          isMobile: isMobile,
                          palette: palette,
                          titleFontSize: titleFontSize,
                          descFontSize: descFontSize,
                          progressHeight: progressHeight,
                          progressFontSize: progressFontSize,
                          spacing: spacing,
                          itemMinHeight: itemMinHeight,
                          containerPadding: containerPadding,
                          containerPaddingTop: containerPaddingTop,
                          cardPaddingHeight: cardPaddingHeight,
                          cardPaddingWidth: cardPaddingWidth,
                        );
                      },
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

  Widget _buildInitiativesList({
    required BuildContext context,
    required List initiatives,
    required bool isMobile,
    required List<Color> palette,
    required double titleFontSize,
    required double descFontSize,
    required double progressHeight,
    required double progressFontSize,
    required double spacing,
    required double itemMinHeight,
    required double containerPadding,
    required double containerPaddingTop,
    required double cardPaddingHeight,
    required double cardPaddingWidth,
  }) {
    return Scrollbar(
      controller: _scrollController,
      thickness: isMobile ? 6 : 8,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: initiatives.length,
        separatorBuilder: (context, idx) => SizedBox(height: spacing),
        itemBuilder: (context, idx) {
          final initiative = initiatives[idx];
          final cardColor = palette[idx % palette.length];
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: itemMinHeight),
            child: InitiativeCard(
              initiative: initiative,
              cardColor: cardColor,
              isMobile: isMobile,
              titleFontSize: titleFontSize,
              descFontSize: descFontSize,
              progressHeight: progressHeight,
              progressFontSize: progressFontSize,
              spacing: spacing,
              containerPadding: containerPadding,
              containerPaddingTop: containerPaddingTop,
            ),
          );
        },
      ),
    );
  }
}
