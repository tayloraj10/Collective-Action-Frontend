import 'dart:convert';
import 'dart:typed_data';

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PhotosService {
  late final PhotosApi _api;

  PhotosService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = PhotosApi(client);
  }

  /// Strips JSON wrapping and surrounding quotes so the stored URL is clean.
  static String _normalizePhotoUrl(String url) {
    final trimmed = url.trim();
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is String) return decoded.trim();
      if (decoded is Map && decoded['photo_url'] is String) {
        return (decoded['photo_url'] as String).trim();
      }
      if (decoded is Map && decoded['url'] is String) {
        return (decoded['url'] as String).trim();
      }
    } catch (_) {}
    if (trimmed.length >= 2) {
      final first = trimmed[0];
      final last = trimmed[trimmed.length - 1];
      if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
        return trimmed.substring(1, trimmed.length - 1).trim();
      }
    }
    return trimmed;
  }

  Future<String?> uploadSubmissionPhoto(
    String submissionId,
    String filePath,
  ) async {
    try {
      final file = await http.MultipartFile.fromPath('file', filePath);
      return await _api.uploadSubmissionPhotoPhotosSubmissionSubmissionIdPost(
        submissionId,
        file,
      );
    } catch (e) {
      throw Exception('Failed to upload submission photo: $e');
    }
  }

  /// Upload a profile photo for the given user. Returns the public URL of the uploaded photo.
  // Future<String?> uploadProfilePhoto(String userId, String filePath) async {
  //   try {
  //     final file = await http.MultipartFile.fromPath('file', filePath);
  //     return await _api.uploadProfilePhotoPhotosProfileUserIdPost(userId, file);
  //   } catch (e) {
  //     throw Exception('Failed to upload profile photo: $e');
  //   }
  // }

  /// Upload a profile photo from bytes (e.g. after crop or from web picker). Returns the public URL.
  Future<String?> uploadProfilePhotoFromBytes(
    String userId,
    Uint8List bytes, {
    String filename = 'image.png',
  }) async {
    try {
      final contentType = _contentTypeFromFilename(filename);
      final file = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: contentType,
      );
      final raw = await _api.uploadProfilePhotoPhotosProfileUserIdPost(
        userId,
        file,
      );
      return raw == null ? null : _normalizePhotoUrl(raw);
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  /// Upload a new profile photo and then update the user's `photo_url` to match
  /// the returned URL. The URL is normalized (no quotes) before saving.
  Future<String?> uploadProfilePhotoFromBytesAndUpdateUserPhotoUrl(
    UserSchema user,
    Uint8List bytes, {
    String filename = 'image.png',
  }) async {
    if (user.id == null || user.id!.isEmpty) {
      throw Exception('Cannot upload profile photo: user.id is missing');
    }

    final url = await uploadProfilePhotoFromBytes(
      user.id!,
      bytes,
      filename: filename,
    );
    if (url == null) return null;

    final cleanUrl = _normalizePhotoUrl(url);
    await UserService().updateUserPhotoUrl(user: user, photoUrl: cleanUrl);
    return cleanUrl;
  }

  static MediaType? _contentTypeFromFilename(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('image', 'png');
    }
  }
}
