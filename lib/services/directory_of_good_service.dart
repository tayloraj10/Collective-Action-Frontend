import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class DirectoryOfGoodService {
  late final DirectoryOfGoodApi _api;

  DirectoryOfGoodService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = DirectoryOfGoodApi(client);
  }

  Future<List<DirectoryOfGoodSchema>> listEntries() async {
    try {
      final result = await _api.listEntriesDirectoryOfGoodGet();
      return result ?? [];
    } catch (e) {
      throw Exception('Failed to fetch directory of good entries: $e');
    }
  }

  Future<List<DirectoryOfGoodSchema>> listEntriesByUser(String userId) async {
    try {
      final result =
          await _api.listEntriesByUserDirectoryOfGoodByUserUserIdGet(userId);
      return result ?? [];
    } catch (e) {
      throw Exception(
          'Failed to fetch directory of good entries by user: $e');
    }
  }

  Future<DirectoryOfGoodSchema?> getEntry(String entryId) async {
    try {
      return await _api.getEntryDirectoryOfGoodEntryIdGet(entryId);
    } catch (e) {
      throw Exception('Failed to fetch directory of good entry: $e');
    }
  }

  Future<DirectoryOfGoodSchema?> createEntry(
      DirectoryOfGoodCreate body) async {
    try {
      return await _api.createEntryDirectoryOfGoodPost(body);
    } catch (e) {
      throw Exception('Failed to create directory of good entry: $e');
    }
  }

  Future<DirectoryOfGoodSchema?> updateEntry(
    String entryId,
    DirectoryOfGoodUpdate body,
  ) async {
    try {
      return await _api.updateEntryDirectoryOfGoodEntryIdPatch(
        entryId,
        body,
      );
    } catch (e) {
      throw Exception('Failed to update directory of good entry: $e');
    }
  }

  Future<void> deleteEntry(String entryId) async {
    try {
      await _api.deleteEntryDirectoryOfGoodEntryIdDelete(entryId);
    } catch (e) {
      throw Exception('Failed to delete directory of good entry: $e');
    }
  }
}
