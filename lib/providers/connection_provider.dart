import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/connection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _inferConnectionType(String fromType, String toType) {
  if (toType == 'initiative') return 'contribution';
  if (fromType == 'directory_of_good' && toType == 'directory_of_good') {
    return 'partnership';
  }
  return 'follow';
}

final _connectionServiceProvider = Provider((_) => ConnectionService());

// ── Bulk summaries (one request per entity-type) ──────────────────────────

final connectionSummaryProvider =
    FutureProvider.family<Map<String, ConnectionSummarySchema>, String>((
      ref,
      toType,
    ) async {
      ref.keepAlive();
      return ref.read(_connectionServiceProvider).getSummaries(toType);
    });

class EntityConnectionsQuery {
  const EntityConnectionsQuery({
    required this.toType,
    required this.toId,
    this.connectionType,
  });

  final String toType;
  final String toId;
  final String? connectionType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityConnectionsQuery &&
          other.toType == toType &&
          other.toId == toId &&
          other.connectionType == connectionType;

  @override
  int get hashCode => Object.hash(toType, toId, connectionType);
}

final entityConnectionsProvider =
    FutureProvider.family<
      List<ConnectionWithUserSchema>,
      EntityConnectionsQuery
    >((ref, query) async {
      return ref
          .read(_connectionServiceProvider)
          .getConnectionsForEntity(
            toType: query.toType,
            toId: query.toId,
            connectionType: query.connectionType,
          );
    });

final userConnectionsProvider =
    FutureProvider.family<List<ConnectionWithUserSchema>, String>((
      ref,
      userId,
    ) async {
      if (userId.isEmpty) return [];
      return ref.read(_connectionServiceProvider).getConnectionsForUser(userId);
    });

// ── Current user's connections ────────────────────────────────────────────

class MyConnectionsNotifier
    extends AsyncNotifier<List<ConnectionWithUserSchema>> {
  @override
  Future<List<ConnectionWithUserSchema>> build() async {
    ref.keepAlive();
    final user = await ref.watch(currentUserProvider.future);
    if (user?.id == null) return [];
    return ref.read(_connectionServiceProvider).getConnectionsForUser(user!.id!);
  }

  Future<void> connect({
    required String fromType,
    required String fromId,
    required String toType,
    required String toId,
  }) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;

    // Optimistic insert with a temporary ID.
    final optimistic = ConnectionWithUserSchema(
      id: '_pending_${fromType}_${fromId}_${toType}_$toId',
      createdBy: userId,
      fromType: fromType,
      fromId: fromId,
      toType: toType,
      toId: toId,
      connectionType: _inferConnectionType(fromType, toType),
      createdAt: DateTime.now(),
    );
    state = AsyncData([...?state.value, optimistic]);

    try {
      final real = await ref
          .read(_connectionServiceProvider)
          .createConnection(
            createdBy: userId,
            fromType: fromType,
            fromId: fromId,
            toType: toType,
            toId: toId,
          );
      final updated = state.value
          ?.map((c) => c.id == optimistic.id ? real : c)
          .toList();
      if (updated != null) state = AsyncData(updated);
    } catch (_) {
      // Revert on failure.
      final reverted = state.value
          ?.where((c) => c.id != optimistic.id)
          .toList();
      if (reverted != null) state = AsyncData(reverted);
      rethrow;
    }
  }

  Future<void> disconnect(
    String toType,
    String toId, {
    String? fromType,
    String? fromId,
  }) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;

    final conn = state.value
        ?.where(
          (c) =>
              c.toType == toType &&
              c.toId == toId &&
              (fromType == null || c.fromType == fromType) &&
              (fromId == null || c.fromId == fromId),
        )
        .firstOrNull;
    if (conn == null) return;

    final prev = List<ConnectionWithUserSchema>.from(state.value ?? []);
    state = AsyncData(prev.where((c) => c.id != conn.id).toList());

    try {
      await ref
          .read(_connectionServiceProvider)
          .deleteConnection(conn.id, userId);
    } catch (_) {
      state = AsyncData(prev);
      rethrow;
    }
  }
}

final myConnectionsProvider =
    AsyncNotifierProvider<
      MyConnectionsNotifier,
      List<ConnectionWithUserSchema>
    >(MyConnectionsNotifier.new);
