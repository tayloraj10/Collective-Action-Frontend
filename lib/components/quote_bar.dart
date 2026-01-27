import 'package:collective_action_frontend/providers/quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuoteBar extends ConsumerWidget {
  const QuoteBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(quoteProvider);
    if (quoteAsync.isLoading || quoteAsync.hasError) {
      return const SizedBox.shrink();
    }
    final quote = quoteAsync.value;
    if (quote == null || (quote.text.isEmpty)) {
      return const SizedBox.shrink();
    }
    final hasTranslation =
        quote.translation != null && quote.translation!.isNotEmpty;
    Widget quoteText = Text(
      '"${quote.text}"',
      style: TextStyle(
        fontSize: 11,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    if (hasTranslation) {
      quoteText = Tooltip(message: quote.translation!, child: quoteText);
    }
    return Padding(padding: const EdgeInsets.only(top: 2.0), child: quoteText);
  }
}
