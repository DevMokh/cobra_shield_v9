import 'package:flutter_test/flutter_test.dart';

import 'package:cobra_shield/core/models.dart';
import 'package:cobra_shield/services/url_analyzer.dart';

// اختبارات المحلل: روابط معروفة بأنها احتيال لازم تتصنف "متوسط" أو أعلى،
// وروابط سليمة معروفة لازم تفضل "منخفض". لو غيرت القواعد وفشل اختبار،
// يبقى التعديل كسر حالة قديمة.
void main() {
  group('روابط مشبوهة', () {
    const suspicious = <String>[
    'https://evil-site.com/paypal/login',
    'https://xkqzrtvbnmpl.top/a',
    'https://a8392kd04x1zq.com/verify',
    'http://win-prize-now.top/claim',
    'http://vodafone-egypt.update-line.xyz',
    'http://parcel-fee-check.click/pay',
    'https://paypal.com.account-verify.xyz/login',
    'https://paypa1.com/signin',
    'https://traffic-pay.top/fine',
    'https://secure-amazon.eg.login-check.com/ap/signin',
    'https://www.arnazon.com/orders',
    'https://sites.google.com/view/bank-login-update',
    'https://mail.google.com@evil-login.com/inbox',
    'http://nbe-secure-login.top/verify',
    'https://google.pw/login',
    'https://аpple.com/id',
    'https://dhl-parcel-redelivery.top/pay',
    'https://noon-verify-account.xyz/login',
    ];
    for (final u in suspicious) {
      test(u, () {
        final r = UrlAnalyzer.analyze(u);
        expect(r.level, isNot(RiskLevel.low), reason: 'score=${r.score}');
      });
    }
  });

  group('روابط سليمة', () {
    const legit = <String>[
    'https://www.bbc.com/news/facebook-account-changes',
    'https://www.theguardian.com/technology/amazon-prime-day',
    'https://medium.com/@x/why-paypal-won',
    'https://ar.wikipedia.org/wiki/مصر',
    'https://www.amazon.eg/gp/help/customer/display.html',
    'https://support.apple.com/ar-eg',
    'https://www.google.com',
    'https://www.google.de/search?q=x',
    'https://amazon.co.uk/orders',
    'https://apple-pie-recipes.com/best',
    'https://orange-juice-shop.com',
    'https://accounts.google.com/signin/v2',
    'https://www.paypal.com/myaccount/summary',
    'https://www.facebook.com/login',
    'https://www.microsoft.com/en-us/security',
    'https://news.ycombinator.com/item?id=1',
    'https://stackoverflow.com/questions/1',
    'https://dhl.de/track',
    'https://www.noon.com/egypt-ar/',
    'https://zoom.us/j/123',
    ];
    for (final u in legit) {
      test(u, () {
        final r = UrlAnalyzer.analyze(u);
        expect(r.level, RiskLevel.low, reason: 'score=${r.score}');
      });
    }
  });

  test('رابط جافاسكربت خطير', () {
    final r = UrlAnalyzer.analyze('javascript:alert(1)');
    expect(r.level, isNot(RiskLevel.low));
  });

  test('نص فاضي', () {
    final r = UrlAnalyzer.analyze('   ');
    expect(r.score, 0);
  });
}
