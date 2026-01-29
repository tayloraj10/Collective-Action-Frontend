import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class QuoteService {
  late final QuotesApi _api;

  QuoteService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = QuotesApi(client);
  }

  Future<QuoteSchema?> fetchQuote() async {
    try {
      return await _api.getRandomQuoteQuotesRandomGet();
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }
}
