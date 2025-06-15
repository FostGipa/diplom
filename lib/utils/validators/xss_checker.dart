import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

String? sanitizeMessage(String input) {
  final bannedPatterns = [
    RegExp(r'<script.*?>.*?</script>', caseSensitive: false, dotAll: true),
  ];
  for (final pattern in bannedPatterns) {
    if (pattern.hasMatch(input)) {
      return null;
    }
  }
  final document = parse(input);
  final cleanText = dom.DocumentFragment.html(document.body?.text ?? '').text ?? '';
  return cleanText;
}