import 'package:flutter_test/flutter_test.dart';

import 'package:cobra_shield/core/models.dart';
import 'package:cobra_shield/services/message_analyzer.dart';

void main() {
  group('استخراج الروابط', () {
    test('رابط كامل بنقطة في آخر الجملة', () {
      final l = MessageAnalyzer.extractLinks(
          'عاجل: اضغط http://nbe-secure-login.top/verify.');
      expect(l, ['http://nbe-secure-login.top/verify']);
    });

    test('رابط مختصر من غير http', () {
      final l = MessageAnalyzer.extractLinks('مبروك! اضغط هنا: bit.ly/3xYz12 الآن');
      expect(l, ['bit.ly/3xYz12']);
    });

    test('إيميل مش رابط', () {
      expect(MessageAnalyzer.extractLinks('راسلنا على info@example.com للدعم'),
          isEmpty);
    });

    test('مفيش روابط', () {
      expect(MessageAnalyzer.extractLinks('لا يوجد رابط هنا'), isEmpty);
    });
  });

  group('تحليل الرسائل', () {
    test('رسالة نصب واضحة: جائزة + استعجال + رابط مشبوه', () {
      final r = MessageAnalyzer.analyze(
          'مبروك! فزت بجائزة كبيرة. اضغط الآن خلال 24 ساعة وادفع الرسوم '
          'http://win-prize-now.top/claim');
      expect(r.level, isNot(RiskLevel.low), reason: 'score=${r.score}');
    });

    test('رسالة عادية', () {
      final r = MessageAnalyzer.analyze('هنتقابل الساعة خمسة في الكافيه');
      expect(r.level, RiskLevel.low, reason: 'score=${r.score}');
    });
  });
}
