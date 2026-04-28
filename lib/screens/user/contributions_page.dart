import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/models/connection_model.dart';
import 'package:collective_action_frontend/models/user_stats_model.dart';
import 'package:collective_action_frontend/providers/connection_provider.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/providers/map_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/providers/user_stats_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// ── Palette ────────────────────────────────────────────────────────────────

class _PageColors {
  const _PageColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
  });

  final Color bg;
  final Color surface;
  final Color surface2;
  final Color border;
  final Color textPrimary;
  final Color textMuted;

  factory _PageColors.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _PageColors(
      bg: isDark ? const Color(0xFF0D1117) : const Color(0xFFF4F7FB),
      surface: isDark ? const Color(0xFF161B22) : Colors.white,
      surface2: isDark ? const Color(0xFF21262D) : const Color(0xFFEFF3F8),
      border: isDark ? const Color(0xFF30363D) : const Color(0xFFD8E0EA),
      textPrimary: isDark ? const Color(0xFFE6EDF3) : const Color(0xFF0F172A),
      textMuted: isDark ? const Color(0xFF8B949E) : const Color(0xFF5B6B80),
    );
  }
}

const _kBlue   = Color(0xFF58A6FF);
const _kOrange = Color(0xFFF0883E);

// ── Page ───────────────────────────────────────────────────────────────────

class ContributionsPage extends ConsumerWidget {
  const ContributionsPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = _PageColors.of(context);
    final isMobile = AppConstants.isMobile(context);
    final statsAsync = ref.watch(userStatsProvider(userId));
    final userAsync  = ref.watch(userProvider(userId));
    final actionsAsync = ref.watch(userRecentActionsProvider(userId));
    final conns     = ref.watch(myConnectionsProvider).value ?? [];
    final dogs      = ref.watch(directoryOfGoodEntriesProvider).value ?? [];
    final inits     = ref.watch(activeInitiativeProvider).value ?? [];
    final campaigns = ref.watch(activeMapCampaignsProvider).value ?? [];

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: const CustomAppBar(),
      body: statsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: _kBlue),
        ),
        error: (e, _) => Center(
          child: Text('Could not load stats: $e',
              style: TextStyle(color: colors.textMuted)),
        ),
        data: (stats) => _PageBody(
          userId: userId,
          stats: stats,
          user: userAsync.value,
          actions: actionsAsync.value ?? [],
          conns: conns,
          dogs: dogs,
          inits: inits,
          campaigns: campaigns,
          isMobile: isMobile,
        ),
      ),
    );
  }
}

// ── Body ───────────────────────────────────────────────────────────────────

class _PageBody extends StatelessWidget {
  const _PageBody({
    required this.userId,
    required this.stats,
    required this.user,
    required this.actions,
    required this.conns,
    required this.dogs,
    required this.inits,
    required this.campaigns,
    required this.isMobile,
  });

  final String userId;
  final UserStatsModel stats;
  final UserSchema? user;
  final List<ActionSchema> actions;
  final List<ConnectionModel> conns;
  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> inits;
  final List<MapCampaignSchema> campaigns;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(userId: userId, stats: stats, user: user),
          _TwoCardHero(stats: stats, isMobile: isMobile),
          isMobile
              ? _MobileBody(
                  stats: stats, actions: actions,
                  conns: conns, dogs: dogs, inits: inits,
                  campaigns: campaigns)
              : _DesktopBody(
                  stats: stats, actions: actions,
                  conns: conns, dogs: dogs, inits: inits,
                  campaigns: campaigns),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.userId,
    required this.stats,
    required this.user,
  });

  final String userId;
  final UserStatsModel stats;
  final UserSchema? user;

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    final name = user?.name ?? '';
    final loc = user?.location;
    final locStr = [loc?.city, loc?.state, loc?.country]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(', ');

    return Container(
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with glow
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _kBlue.withAlpha(60),
                      blurRadius: 20, spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              UserAvatar(userId: userId, radius: 34, enableHero: false,
                  borderWidth: 2, accentColorOverride: _kBlue),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty)
                  Text(name,
                      style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5)),
                if (locStr.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.location_on_outlined,
                        size: 13, color: colors.textMuted),
                    const SizedBox(width: 4),
                    Text(locStr,
                        style: TextStyle(
                            color: colors.textMuted, fontSize: 13)),
                  ]),
                ],
                if (stats.hasOrg) ...[
                  const SizedBox(height: 6),
                  _OrgBadge(name: stats.orgName ?? ''),
                ],
                if (stats.firstActionDate != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Active since ${DateFormat('MMM yyyy').format(stats.firstActionDate!)} · '
                    '${stats.totalActions} actions',
                    style: TextStyle(
                        color: colors.textMuted, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 14),
                Row(children: [
                  _HeaderBtn(
                    icon: Icons.link_outlined,
                    label: 'Copy link',
                    onTap: () {
                      final b = Uri.base;
                      final origin = '${b.scheme}://${b.host}'
                          '${b.port != 0 && b.port != 80 && b.port != 443 ? ":${b.port}" : ""}';
                      Clipboard.setData(
                          ClipboardData(text: '$origin/profile/$userId'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Link copied'),
                            duration: Duration(seconds: 2)),
                      );
                    },
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrgBadge extends StatelessWidget {
  const _OrgBadge({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF0D9488).withAlpha(25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color(0xFF0D9488).withAlpha(80)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.people_outline,
              size: 11, color: Color(0xFF0D9488)),
          const SizedBox(width: 5),
          Text(name,
              style: const TextStyle(
                  color: Color(0xFF0D9488),
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ]),
      );
}

class _HeaderBtn extends StatelessWidget {
  const _HeaderBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.border),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 13, color: colors.textMuted),
              const SizedBox(width: 5),
              Text(label,
                  style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
      );
  }
}

// ── Hero metric row ────────────────────────────────────────────────────────

// Dashboard-matching accent colours.
const _kMapColor  = Color(0xFF16A34A); // AppColors.successGreen
const _kInitColor = Color(0xFF3B82F6); // AppColors.lightBlue

class _TwoCardHero extends StatelessWidget {
  const _TwoCardHero({required this.stats, required this.isMobile});
  final UserStatsModel stats;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    final hasMap  = stats.mapSubmissionCount > 0;
    final hasInit = stats.initiativesParticipated > 0 ||
        stats.initiativeActionCount > 0;
    if (!hasMap && !hasInit) return const SizedBox.shrink();

    final cards = <Widget>[
      if (hasInit)
        _ContribCard(
          color: _kInitColor,
          icon: Icons.trending_up,
          title: 'Initiatives',
          bigNumber: '${stats.initiativeActionCount}',
          bigLabel: 'contribution${stats.initiativeActionCount == 1 ? '' : 's'}',
          details: [
            if (stats.initiativesParticipated > 0)
              _Detail('${stats.initiativesParticipated}',
                  'initiative${stats.initiativesParticipated == 1 ? '' : 's'} participated in'),
          ],
        ),
      if (hasMap)
        _MapContribCard(stats: stats),
    ];

    return Container(
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: colors.border, height: 1),
          const SizedBox(height: 16),
          _Section(
            label: 'Actions taken',
            icon: Icons.bolt_outlined,
            color: _kOrange,
          ),
          const SizedBox(height: 16),
          isMobile
              ? Column(
                  children: cards
                      .map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: c,
                          ))
                      .toList(),
                )
              : IntrinsicHeight(
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: cards
                      .map((c) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: c,
                            ),
                          ))
                      .toList(),
                )),
        ],
      ),
    );
  }
}

class _Detail {
  const _Detail(this.value, this.label);
  final String value;
  final String label;
}

// ── Map contributions card (per-campaign breakdown) ───────────────────────

class _MapContribCard extends StatelessWidget {
  const _MapContribCard({required this.stats});
  final UserStatsModel stats;

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    final campaigns = stats.mapCampaignBreakdown;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kMapColor.withAlpha(50)),
        boxShadow: [
          BoxShadow(
              color: _kMapColor.withAlpha(18),
              blurRadius: 18,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card title
          Row(children: [
            const Icon(Icons.map_outlined, size: 13, color: _kMapColor),
            const SizedBox(width: 6),
            const Text('Map Contributions',
                style: TextStyle(
                    color: _kMapColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6)),
          ]),
          const SizedBox(height: 12),
          // Big number
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${stats.mapSubmissionCount}',
                  style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                      height: 1)),
              const SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text('submissions',
                    style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          // Per-campaign tiles
          if (campaigns.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(height: 1, color: _kMapColor.withAlpha(25)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: campaigns
                  .map((c) => _CampaignTile(campaign: c))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _CampaignTile extends StatelessWidget {
  const _CampaignTile({required this.campaign});
  final MapCampaignStats campaign;

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    final details = <String>[
      if (campaign.cleanupCount > 0)
        '${campaign.cleanupCount} cleanup${campaign.cleanupCount == 1 ? '' : 's'}',
      if (campaign.trashReportCount > 0)
        '${campaign.trashReportCount} trash report${campaign.trashReportCount == 1 ? '' : 's'}',
      if (campaign.totalBags > 0)
        '${campaign.totalBags} bag${campaign.totalBags == 1 ? '' : 's'}',
      if (campaign.totalPounds > 0)
        '${campaign.totalPounds >= 1000 ? "${(campaign.totalPounds / 1000).toStringAsFixed(1)}k" : campaign.totalPounds.toStringAsFixed(0)} lbs',
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _kMapColor.withAlpha(14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kMapColor.withAlpha(45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.map_outlined, size: 13, color: _kMapColor.withAlpha(180)),
          const SizedBox(height: 6),
          Text('${campaign.submissionCount}',
              style: const TextStyle(
                  color: _kMapColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          const SizedBox(height: 3),
          Text(campaign.campaignName,
              style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          if (details.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(details.join(' · '),
                style: TextStyle(color: colors.textMuted, fontSize: 10)),
          ],
        ],
      ),
    );
  }
}

class _ContribCard extends StatelessWidget {
  const _ContribCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.bigNumber,
    required this.bigLabel,
    required this.details,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String bigNumber;
  final String bigLabel;
  final List<_Detail> details;

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(50)),
        boxShadow: [
          BoxShadow(
              color: color.withAlpha(18),
              blurRadius: 18,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card title
          Row(children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6)),
          ]),
          const SizedBox(height: 12),
          // Big number + label
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(bigNumber,
                  style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                      height: 1)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(bigLabel,
                    style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          // Detail breakdown
          if (details.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(height: 1, color: color.withAlpha(25)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: details.map((d) => RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '${d.value} ',
                    style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: d.label,
                    style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 12),
                  ),
                ]),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Desktop body ───────────────────────────────────────────────────────────

class _DesktopBody extends StatelessWidget {
  const _DesktopBody({
    required this.stats,
    required this.actions,
    required this.conns,
    required this.dogs,
    required this.inits,
    required this.campaigns,
  });

  final UserStatsModel stats;
  final List<ActionSchema> actions;
  final List<ConnectionModel> conns;
  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> inits;
  final List<MapCampaignSchema> campaigns;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (stats.hasOrg) ...[
                  _Section(label: 'Organization', color: const Color(0xFF0D9488),
                      icon: Icons.people_outline),
                  const SizedBox(height: 12),
                  _OrgStatsCard(stats: stats),
                  const SizedBox(height: 28),
                ],
                _Section(label: 'Connections', color: _kBlue,
                    icon: Icons.hub_outlined),
                const SizedBox(height: 12),
                _ConnectionsList(
                    conns: conns, dogs: dogs, inits: inits),
              ],
            ),
          ),
          const SizedBox(width: 28),
          // Right column
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (actions.isNotEmpty) ...[
                  _Section(label: 'Activity', color: _kOrange,
                      icon: Icons.history_outlined),
                  const SizedBox(height: 12),
                  _Timeline(actions: actions, inits: inits,
                      campaigns: campaigns),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mobile body ────────────────────────────────────────────────────────────

class _MobileBody extends StatelessWidget {
  const _MobileBody({
    required this.stats,
    required this.actions,
    required this.conns,
    required this.dogs,
    required this.inits,
    required this.campaigns,
  });

  final UserStatsModel stats;
  final List<ActionSchema> actions;
  final List<ConnectionModel> conns;
  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> inits;
  final List<MapCampaignSchema> campaigns;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stats.hasOrg) ...[
            _Section(label: 'Organization', color: const Color(0xFF0D9488),
                icon: Icons.people_outline),
            const SizedBox(height: 12),
            _OrgStatsCard(stats: stats),
            const SizedBox(height: 24),
          ],
          _Section(label: 'Connections', color: _kBlue,
              icon: Icons.hub_outlined),
          const SizedBox(height: 12),
          _ConnectionsList(conns: conns, dogs: dogs, inits: inits),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 24),
            _Section(label: 'Activity', color: _kOrange,
                icon: Icons.history_outlined),
            const SizedBox(height: 12),
            _Timeline(actions: actions, inits: inits,
                campaigns: campaigns),
          ],
        ],
      ),
    );
  }
}

// ── Section label ──────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.color,
    required this.icon,
  });
  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 7),
        Text(label.toUpperCase(),
            style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: color.withAlpha(30))),
      ]);
}


// ── Org stats card ─────────────────────────────────────────────────────────

class _OrgStatsCard extends StatelessWidget {
  const _OrgStatsCard({required this.stats});
  final UserStatsModel stats;

  @override
  Widget build(BuildContext context) {
    const c = Color(0xFF0D9488);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.withAlpha(10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withAlpha(40)),
      ),
      child: Row(
        children: [
          _OrgStat('${stats.orgFollowersCount}', 'followers', c),
          if (stats.orgPartnershipsCount > 0) ...[
            _vDiv(),
            _OrgStat('${stats.orgPartnershipsCount}', 'partners', c),
          ],
          if (stats.orgInitiativeConnections > 0) ...[
            _vDiv(),
            _OrgStat(
                '${stats.orgInitiativeConnections}', 'initiatives', c),
          ],
        ],
      ),
    );
  }

  Widget _vDiv() => Container(
      width: 1, height: 32, margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF0D9488).withAlpha(30));
}

class _OrgStat extends StatelessWidget {
  const _OrgStat(this.value, this.label, this.color);
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: colors.textMuted, fontSize: 11)),
        ],
      );
  }
}

// ── Connections list ───────────────────────────────────────────────────────

class _ConnectionsList extends StatelessWidget {
  const _ConnectionsList({
    required this.conns,
    required this.dogs,
    required this.inits,
  });

  final List<ConnectionModel> conns;
  final List<DirectoryOfGoodSchema> dogs;
  final List<InitiativeSchema> inits;

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    final dogById  = {for (final d in dogs) (d.id ?? d.name): d};
    final initById = {for (final i in inits) i.id: i};

    final follows = conns
        .where((c) => c.isFollow && c.fromType == 'user')
        .toList();
    final contribs = conns
        .where((c) => c.isContribution && c.fromType == 'user')
        .toList();

    if (follows.isEmpty && contribs.isEmpty) {
      return Text('No connections yet.',
          style: TextStyle(color: colors.textMuted, fontSize: 13));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (follows.isNotEmpty) ...[
          Text('${follows.length} org${follows.length == 1 ? '' : 's'} followed',
              style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: follows.map((c) {
              final name = dogById[c.toId]?.name ?? c.toId;
              return _Tag(name, _kBlue, Icons.people_outline);
            }).toList(),
          ),
        ],
        if (follows.isNotEmpty && contribs.isNotEmpty)
          const SizedBox(height: 14),
        if (contribs.isNotEmpty) ...[
          Text(
              '${contribs.length} initiative${contribs.length == 1 ? '' : 's'} connected',
              style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: contribs.map((c) {
              final name = initById[c.toId]?.title ?? c.toId;
              return _Tag(name, _kOrange, Icons.trending_up);
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
        decoration: BoxDecoration(
          color: color.withAlpha(14),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 11, color: color.withAlpha(180)),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ]),
      );
}

// ── Activity timeline ──────────────────────────────────────────────────────

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.actions,
    required this.inits,
    required this.campaigns,
  });

  final List<ActionSchema> actions;
  final List<InitiativeSchema> inits;
  final List<MapCampaignSchema> campaigns;

  Color _dotColor(ActionSchema a, _PageColors colors) {
    final t = a.actionType.toLowerCase();
    if (t.contains('map')) return _kMapColor;
    if (t.contains('initiative')) return _kInitColor;
    return colors.textMuted;
  }

  String _label(ActionSchema a) {
    final t = a.actionType.toLowerCase();
    if (t.contains('map')) {
      final ed = a.eventData ?? {};
      final type = ed['type'] as String? ?? '';
      if (type == 'cleanup') return 'Cleanup';
      if (type.toLowerCase().contains('trash')) return 'Trash report';
      return 'Map contribution';
    }
    if (t.contains('initiative')) return 'Initiative contribution';
    return a.actionType;
  }

  /// Resolves the linked entity name, e.g. "Cleanup Map · Miami Beach"
  /// or "Initiative · Remove 1M Bags".
  String? _entityName(ActionSchema a) {
    final linked = a.linkedId;
    if (linked == null) return null;
    final t = a.actionType.toLowerCase();
    if (t.contains('initiative')) {
      final init = inits.firstWhere(
        (i) => i.id == linked,
        orElse: () => InitiativeSchema(
            id: linked, title: '', action: '', createdBy: ''),
      );
      if (init.title.isNotEmpty) return init.title;
    }
    if (t.contains('map')) {
      try {
        final c = campaigns.firstWhere((c) => c.id == linked);
        if (c.title.isNotEmpty) return c.title;
      } catch (_) {}
    }
    return null;
  }

  static String _detail(ActionSchema a) {
    final ed = a.eventData ?? {};
    final bags = ((ed['small_bags'] as num?)?.toInt() ?? 0) +
        ((ed['large_bags'] as num?)?.toInt() ?? 0);
    final lbs = (ed['pounds'] as num?)?.toDouble() ?? 0;
    if (bags > 0 && lbs > 0) {
      return '$bags bag${bags == 1 ? '' : 's'} · ${lbs.toStringAsFixed(1)} lbs';
    }
    if (bags > 0) return '$bags bag${bags == 1 ? '' : 's'}';
    if (lbs > 0) return '${lbs.toStringAsFixed(1)} lbs';
    if ((a.amount ?? 0) > 0) return '+${a.amount!.toStringAsFixed(0)}';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = _PageColors.of(context);
    final shown = actions.take(20).toList();
    return Column(
      children: List.generate(shown.length, (i) {
        final a = shown[i];
        final isLast = i == shown.length - 1;
        final dot = _dotColor(a, colors);
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dot,
                        boxShadow: [
                          BoxShadow(
                              color: dot.withAlpha(80),
                              blurRadius: 6,
                              spreadRadius: 1),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1,
                          color: colors.border,
                          margin: const EdgeInsets.only(top: 4),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: isLast ? 0 : 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _label(a),
                              style: TextStyle(
                                  color: dot,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            if (_entityName(a) != null)
                              Text(
                                _entityName(a)!,
                                style: TextStyle(
                                    color: colors.textMuted,
                                    fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      if (_detail(a).isNotEmpty)
                        Text(_detail(a),
                            style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 12)),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMM d').format(a.date),
                        style: TextStyle(
                            color: colors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
