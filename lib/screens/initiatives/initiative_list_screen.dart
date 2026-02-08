import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/user_service.dart';
import 'package:collective_action_frontend/screens/dashboard/components/initiatives/initiative_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/initiative_action_card.dart';
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
  final Set<String> _collapsedInitiatives = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleActions(String initiativeId) {
    setState(() {
      if (_collapsedInitiatives.contains(initiativeId)) {
        _collapsedInitiatives.remove(initiativeId);
      } else {
        _collapsedInitiatives.add(initiativeId);
      }
    });
  }

  bool _isCollapsed(String initiativeId) {
    // Default to collapsed: only expand when the id is in the set.
    return !_collapsedInitiatives.contains(initiativeId);
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

    // Ensure logged-in user data is loaded when landing/refeshing on this page,
    // mirroring the behavior in DashboardScreen.
    final authUser = ref.watch(authStateProvider).value;
    if (authUser != null) {
      final currentUserNotifier = ref.read(currentUserProvider.notifier);
      Future.microtask(() async {
        try {
          final appUser = await UserService().fetchUserByFirebaseID(
            userId: authUser.uid,
          );
          if (appUser != null) {
            await currentUserNotifier.setUser(appUser);
          }
        } catch (_) {
          // Ignore errors if widget is disposed or request fails.
        }
      });
    } else {
      final currentUserNotifier = ref.read(currentUserProvider.notifier);
      Future.microtask(() async {
        try {
          await currentUserNotifier.clearUser();
        } catch (_) {
          // Ignore errors if widget is disposed.
        }
      });
    }

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
                            ref: ref,
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
                          ref: ref,
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
    required WidgetRef ref,
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
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : MediaQuery.sizeOf(context).width;
              return SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: itemMinHeight,
                        maxWidth: width,
                      ),
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
                    ),
                    // Linked actions list
                    Builder(
                      builder: (context) {
                        final actionsAsync = ref.watch(
                          actionsByLinkedProvider((initiative.id, 7)),
                        );
                        return actionsAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                          data: (actions) {
                            if (actions.isEmpty) return const SizedBox.shrink();
                            return Padding(
                              padding: EdgeInsets.only(
                                top: spacing / 2,
                                left: isMobile ? 4 : 8,
                                right: isMobile ? 4 : 8,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardColor.withAlpha(30),
                                  borderRadius: BorderRadius.circular(
                                    isMobile ? 8 : 12,
                                  ),
                                  border: Border.all(
                                    color: cardColor.withAlpha(80),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardColor.withAlpha(40),
                                      blurRadius: isMobile ? 4 : 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(isMobile ? 8 : 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Label/header with toggle button
                                    InkWell(
                                      onTap: () =>
                                          _toggleActions(initiative.id),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: isMobile ? 6 : 8,
                                          left: isMobile ? 4 : 6,
                                          right: isMobile ? 4 : 6,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.article_outlined,
                                              size: isMobile ? 14 : 16,
                                              color: Colors.white.withAlpha(
                                                200,
                                              ),
                                            ),
                                            SizedBox(width: isMobile ? 6 : 8),
                                            Expanded(
                                              child: Text(
                                                'Recent Actions (${actions.length})',
                                                style: TextStyle(
                                                  color: Colors.white.withAlpha(
                                                    220,
                                                  ),
                                                  fontSize: isMobile ? 11 : 12,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ),
                                            AnimatedRotation(
                                              turns: _isCollapsed(initiative.id)
                                                  ? 0.5
                                                  : 0,
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              child: Icon(
                                                Icons.expand_less,
                                                size: isMobile ? 18 : 20,
                                                color: Colors.white.withAlpha(
                                                  200,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Actions scrollable list (collapsible)
                                    AnimatedSize(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeInOut,
                                      clipBehavior: Clip.hardEdge,
                                      child: _isCollapsed(initiative.id)
                                          ? const SizedBox.shrink()
                                          : SizedBox(
                                              height: isMobile ? 150 : 150,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: List.generate(
                                                    actions.length,
                                                    (actionIdx) {
                                                      final action =
                                                          actions[actionIdx];
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                          right:
                                                              actionIdx <
                                                                  actions.length -
                                                                      1
                                                              ? spacing / 2
                                                              : 0,
                                                        ),
                                                        child:
                                                            InitiativeActionCard(
                                                              action: action,
                                                              initiative:
                                                                  initiative,
                                                              expandToFullWidth:
                                                                  false,
                                                            ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
