// Openapi Generator last run: : 2026-01-17T02:03:38.099594
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  // Use 'inputSpecFile' for a local file (relative path from project root)
  // or 'inputSpec' with a 'RemoteSpec' for a URL.
  inputSpec: InputSpec(path: 'api/openapi.json'),
  // or inputSpec: RemoteSpec(path: 'https://petstore3.swagger.io/api/v3/openapi.json'),
  generatorName:
      Generator.dio, // Recommended generator (uses Dio for HTTP requests)
  outputDirectory: 'lib/models', // Output directory for the generated code
)
class Example {}