import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/services/quote_service.dart';

final quoteProvider = AsyncNotifierProvider<QuoteNotifier, QuoteSchema?>(
  QuoteNotifier.new,
);

class QuoteNotifier extends AsyncNotifier<QuoteSchema?> {
  @override
  Future<QuoteSchema?> build() async {
    return await QuoteService().fetchQuote();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await QuoteService().fetchQuote();
    });
  }
}
