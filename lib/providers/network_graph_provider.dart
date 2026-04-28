import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GraphNodeType { directoryOfGood, initiative, project }

enum GraphEdgeType { sharedCategory, projectInitiative }

class GraphNodeData {
  const GraphNodeData({
    required this.entityId,
    required this.type,
    required this.label,
    this.subtitle,
    this.categoryId,
    this.location,
    required this.entity,
  });

  final String entityId;
  final GraphNodeType type;
  final String label;
  final String? subtitle;
  final String? categoryId;
  final LocationSchema? location;
  final Object entity;
}

class GraphEdgeData {
  const GraphEdgeData({
    required this.fromId,
    required this.toId,
    required this.edgeType,
  });

  final String fromId;
  final String toId;
  final GraphEdgeType edgeType;
}

class NetworkGraphData {
  const NetworkGraphData({required this.nodes, required this.edges});

  final List<GraphNodeData> nodes;
  final List<GraphEdgeData> edges;

  bool get isEmpty => nodes.isEmpty;

  int countByType(GraphNodeType type) =>
      nodes.where((n) => n.type == type).length;
}

/// Derives a read-only graph data snapshot from the three live data providers.
/// Returns loading/error states while any source is still fetching.
final networkGraphDataProvider = Provider<AsyncValue<NetworkGraphData>>((ref) {
  final dogs = ref.watch(directoryOfGoodEntriesProvider);
  final initiatives = ref.watch(activeInitiativeProvider);
  final projects = ref.watch(activeProjectsProvider);

  if (dogs.isLoading || initiatives.isLoading || projects.isLoading) {
    return const AsyncValue.loading();
  }

  if (dogs.hasError) {
    return AsyncValue.error(dogs.error!, dogs.stackTrace!);
  }
  if (initiatives.hasError) {
    return AsyncValue.error(initiatives.error!, initiatives.stackTrace!);
  }
  if (projects.hasError) {
    return AsyncValue.error(projects.error!, projects.stackTrace!);
  }

  try {
    return AsyncValue.data(_buildGraphData(
      dogs.value ?? [],
      initiatives.value ?? [],
      projects.value ?? [],
    ));
  } catch (e, st) {
    return AsyncValue.error(e, st);
  }
});

NetworkGraphData _buildGraphData(
  List<DirectoryOfGoodSchema> dogs,
  List<InitiativeSchema> initiatives,
  List<ProjectSchema> projects,
) {
  final nodes = <GraphNodeData>[];
  final seenIds = <String>{};

  for (final dog in dogs) {
    final id = dog.id ?? dog.name;
    if (seenIds.add(id)) {
      nodes.add(GraphNodeData(
        entityId: id,
        type: GraphNodeType.directoryOfGood,
        label: dog.name,
        subtitle: dog.focus,
        categoryId: dog.categoryIds.firstOrNull,
        location: dog.location,
        entity: dog,
      ));
    }
  }

  for (final initiative in initiatives) {
    if (seenIds.add(initiative.id)) {
      nodes.add(GraphNodeData(
        entityId: initiative.id,
        type: GraphNodeType.initiative,
        label: initiative.title,
        subtitle: initiative.action,
        categoryId: initiative.categoryId,
        entity: initiative,
      ));
    }
  }

  for (final project in projects) {
    if (seenIds.add(project.id)) {
      nodes.add(GraphNodeData(
        entityId: project.id,
        type: GraphNodeType.project,
        label: project.name,
        subtitle: project.description,
        entity: project,
      ));
    }
  }

  final edges = <GraphEdgeData>[];

  // DoG ↔ Initiative: shared category signals alignment of focus.
  final dogsByCategory = <String, List<String>>{};
  for (final dog in dogs) {
    for (final catId in dog.categoryIds) {
      if (catId.isNotEmpty) {
        dogsByCategory.putIfAbsent(catId, () => []).add(dog.id ?? dog.name);
      }
    }
  }
  final initiativesByCategory = <String, List<String>>{};
  for (final initiative in initiatives) {
    final catId = initiative.categoryId;
    if (catId != null && catId.isNotEmpty) {
      initiativesByCategory.putIfAbsent(catId, () => []).add(initiative.id);
    }
  }
  for (final catId in dogsByCategory.keys) {
    final dogIds = dogsByCategory[catId]!;
    final initIds = initiativesByCategory[catId] ?? [];
    for (final dogId in dogIds) {
      for (final initId in initIds) {
        edges.add(GraphEdgeData(
          fromId: dogId,
          toId: initId,
          edgeType: GraphEdgeType.sharedCategory,
        ));
      }
    }
  }

  // Project ↔ Initiative: explicit project link.
  for (final project in projects) {
    for (final link in project.links) {
      final initId = link.initiativeId;
      if (initId != null && seenIds.contains(initId)) {
        edges.add(GraphEdgeData(
          fromId: project.id,
          toId: initId,
          edgeType: GraphEdgeType.projectInitiative,
        ));
      }
    }
  }

  return NetworkGraphData(nodes: nodes, edges: edges);
}
