import 'dart:ui';

void precacheEmojis() {
  ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(locale: window.locale));

  pb.addText('👋');
  pb.build().layout(const ParagraphConstraints(width: 100));
}
