import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannel Attribution', () {
    late MapLibreMethodChannel platform;
    late List<MethodCall> methodCalls;
    late Object? attributionsReply;

    setUp(() async {
      platform = MapLibreMethodChannel();
      methodCalls = [];
      attributionsReply = <Object?, Object?>{
        'attributions': <Object?>['© OpenStreetMap contributors', '© Provider'],
      };

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/maplibre_gl_0'),
            (methodCall) async {
              methodCalls.add(methodCall);
              switch (methodCall.method) {
                case 'style#getAttributions':
                  return attributionsReply;
                default:
                  return null;
              }
            },
          );

      await platform.initPlatform(0);
      methodCalls.clear();
    });

    test('getAttributions invokes style#getAttributions', () async {
      await platform.getAttributions();

      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'style#getAttributions');
    });

    test('getAttributions returns the attribution strings in order', () async {
      final attributions = await platform.getAttributions();

      expect(attributions, [
        '© OpenStreetMap contributors',
        '© Provider',
      ]);
    });

    test('getAttributions propagates a PlatformException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/maplibre_gl_0'),
            (methodCall) async {
              throw PlatformException(code: 'STYLE_NOT_READY');
            },
          );

      expect(platform.getAttributions(), throwsA(isA<PlatformException>()));
    });
  });
}
