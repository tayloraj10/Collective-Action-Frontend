/**
 * Post-generation patch for lib/api/lib/api/photos_api.dart.
 *
 * The OpenAPI Dart generator emits wrong code for multipart array-of-files:
 * it uses mp.files.add(files) and mp.fields[r'files'] = files.field, which
 * are invalid when `files` is List<MultipartFile>. This script replaces that
 * block with correct handling (addAll, no .field).
 *
 * Run after: openapi-generator-cli generate ... (e.g. from generate_models.bat)
 */

const fs = require('fs');
const path = require('path');

const apiPath = path.resolve(__dirname, '..', 'lib', 'api', 'lib', 'api', 'photos_api.dart');

// Exact block the generator emits (after normalizing line endings to \n)
const broken = [
  "    if (files != null) {",
  "      hasFields = true;",
  "      mp.fields[r'files'] = files.field;",
  "      mp.files.add(files);",
  "    }"
].join('\n');

const fixed = [
  "    if (files != null && files.isNotEmpty) {",
  "      hasFields = true;",
  "      mp.files.addAll(files);",
  "    }"
].join('\n');

if (!fs.existsSync(apiPath)) {
  console.error('patch_photos_api_multipart.js: File not found:', apiPath);
  process.exit(1);
}

let content = fs.readFileSync(apiPath, 'utf8');
const lineEnding = content.includes('\r\n') ? '\r\n' : '\n';
content = content.replace(/\r\n/g, '\n');

if (content.includes('mp.files.addAll(files)')) {
  console.log('patch_photos_api_multipart.js: Already patched, skipping.');
  process.exit(0);
  return;
}

if (!content.includes(broken)) {
  console.error('patch_photos_api_multipart.js: Expected block not found; generator output may have changed.');
  process.exit(1);
}

const newContent = content.replace(broken, fixed).replace(/\n/g, lineEnding);
fs.writeFileSync(apiPath, newContent);
console.log('patch_photos_api_multipart.js: Patched photos_api.dart (multipart files list).');
