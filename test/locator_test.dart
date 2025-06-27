import 'package:flutter_test/flutter_test.dart';
import 'package:rec_sesh/core/utils/locator.dart';

class TestServiceA {
  var value = 0;

  void increment() {
    value++;
  }
}

class TestServiceB {
  int value = 0;

  void increment() {
    value++;
  }
}

void main() {
  tearDown(() {
    locator.reset();
  });

  group('ModuleLocator Tests', () {
    test(
      'Retrieving an unregistered module throws ModuleNotFoundException',
      () {
        expect(
          () => locator<TestServiceA>(),
          throwsA(isA<ModuleNotFoundException>()),
        );
      },
    );

    test('Should return a module that has been registered', () {
      final modules = [
        Module<TestServiceA>(builder: () => TestServiceA(), lazy: false),
      ];

      locator.registerMany(modules);

      final instance = locator<TestServiceA>();

      expect(instance, isA<TestServiceA>());
    });

    test(
      'Same instance should be returned when retrieving the same module multiple times',
      () {
        final modules = [
          Module<TestServiceA>(builder: () => TestServiceA(), lazy: false),
        ];

        locator.registerMany(modules);

        final instance1 = locator<TestServiceA>();
        instance1.increment();
        final instance2 = locator<TestServiceA>();

        expect(instance1.value, 1);
        expect(instance2.value, 1);
      },
    );

    test('Register multiple modules with mixed lazy types', () {
      final moduleA = Module<TestServiceA>(
        builder: () => TestServiceA(),
        lazy: true,
      );
      final moduleB = Module<TestServiceB>(
        builder: () => TestServiceB(),
        lazy: false,
      );

      locator.registerMany([moduleA, moduleB]);

      final instanceA1 = locator<TestServiceA>();
      final instanceA2 = locator<TestServiceA>();
      instanceA1.increment();
      expect(instanceA1, isA<TestServiceA>());
      expect(instanceA1.value, 1);
      expect(instanceA2.value, 1);

      final instanceB1 = locator<TestServiceB>();
      final instanceB2 = locator<TestServiceB>();
      expect(instanceB1, isA<TestServiceB>());
      expect(instanceB1.value, 0);
      expect(instanceB2.value, 0);
    });

    test('Reset clears registered modules', () {
      final module = Module<TestServiceA>(
        builder: () => TestServiceA(),
        lazy: false,
      );
      locator.registerMany([module]);

      locator.reset();

      expect(
        () => locator<TestServiceA>(),
        throwsA(isA<ModuleNotFoundException>()),
        reason: 'Should throw after reset',
      );
    });

    test(
      'Registering an existing module throws a ModuleAlreadyRegisteredException',
      () {
        final modules = [
          Module<TestServiceA>(builder: () => TestServiceA(), lazy: false),
          Module<TestServiceA>(builder: () => TestServiceA(), lazy: false),
        ];

        expect(
          () => locator.registerMany(modules),
          throwsA(isA<ModuleAlreadyRegisteredException>()),
        );
      },
    );
  });
}
