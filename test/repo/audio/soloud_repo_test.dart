import 'dart:async';

import 'package:fluff/repo/audio/soloud_repo.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

class MockSoLoud extends Mock implements SoLoud {
  @override
  void setInaudibleBehavior(SoundHandle handle, bool mustTick, bool kill) {}
}

class MockAudioSource extends Mock implements AudioSource {}

class FakeAudioSource extends Fake implements AudioSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAudioSource());
    // SoundHandle is an extension type on int — no Fake needed.
    registerFallbackValue(const SoundHandle(0));
    registerFallbackValue(LoadMode.memory);
  });

  late MockSoLoud mockSoLoud;
  late SoLoudRepo repo;

  setUp(() {
    mockSoLoud = MockSoLoud();
    repo = SoLoudRepo(soLoud: mockSoLoud);
    SoLoudRepo.onError = null;
  });

  tearDown(() async {
    SoLoudRepo.onError = null;
  });

  group('SoLoudRepo - init & voice controls', () {
    test('init initializes SoLoud, sets max voices, and captures logs',
        () async {
      when(() => mockSoLoud.init()).thenAnswer((_) async {});
      when(() => mockSoLoud.setMaxActiveVoiceCount(128)).thenReturn(128);

      await repo.init();

      verify(() => mockSoLoud.init()).called(1);
      verify(() => mockSoLoud.setMaxActiveVoiceCount(128)).called(1);

      Logger('TestLogger').info('Test log message');
      expect(
        repo.debugLogs.any((log) => log.contains('Test log message')),
        isTrue,
      );
    });

    test('setMaxActiveVoiceCount calls SoLoud setMaxActiveVoiceCount', () {
      when(() => mockSoLoud.setMaxActiveVoiceCount(64)).thenReturn(64);

      repo.setMaxActiveVoiceCount(64);

      verify(() => mockSoLoud.setMaxActiveVoiceCount(64)).called(1);
    });

    test('getMaxActiveVoiceCount returns count from SoLoud', () {
      when(() => mockSoLoud.getMaxActiveVoiceCount()).thenReturn(32);

      final count = repo.getMaxActiveVoiceCount();

      expect(count, equals(32));
      verify(() => mockSoLoud.getMaxActiveVoiceCount()).called(1);
    });

    test('getActiveVoiceCount returns count from SoLoud', () {
      when(() => mockSoLoud.getActiveVoiceCount()).thenReturn(8);

      final count = repo.getActiveVoiceCount();

      expect(count, equals(8));
      verify(() => mockSoLoud.getActiveVoiceCount()).called(1);
    });

    test('logActiveVoices records active and max voices to debugLogs', () {
      when(() => mockSoLoud.getActiveVoiceCount()).thenReturn(4);
      when(() => mockSoLoud.getMaxActiveVoiceCount()).thenReturn(128);

      repo.logActiveVoices();

      expect(repo.debugLogs, contains('Active/Max voices : 4/128'));
    });
  });

  group('SoLoudRepo - cache', () {
    test('cache pre-warms assets if not already cached', () async {
      final mockSource1 = MockAudioSource();
      final mockSource2 = MockAudioSource();

      when(() => mockSoLoud.loadAsset('asset1.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource1);
      when(() => mockSoLoud.loadAsset('asset2.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource2);

      await repo.cache(['asset1.mp3', 'asset2.mp3']);

      verify(() => mockSoLoud.loadAsset('asset1.mp3', mode: LoadMode.memory))
          .called(1);
      verify(() => mockSoLoud.loadAsset('asset2.mp3', mode: LoadMode.memory))
          .called(1);

      // Repeated cache call should skip already loaded assets
      await repo.cache(['asset1.mp3']);
      verifyNoMoreInteractions(mockSoLoud);
    });

    test('cache invokes onError and rethrows on error', () async {
      final exception = Exception('Failed to load asset');
      Object? capturedError;
      StackTrace? capturedStack;

      SoLoudRepo.onError = (e, stack) {
        capturedError = e;
        capturedStack = stack;
      };

      when(() => mockSoLoud.loadAsset('fail.mp3', mode: LoadMode.memory))
          .thenThrow(exception);

      expect(() => repo.cache(['fail.mp3']), throwsA(equals(exception)));
      expect(capturedError, equals(exception));
      expect(capturedStack, isNotNull);
    });
  });

  group('SoLoudRepo - play', () {
    test('play plays cached asset and waits for finished stream', () async {
      final mockSource = MockAudioSource();
      const fakeHandle = SoundHandle(101);

      when(() => mockSource.allInstancesFinished)
          .thenAnswer((_) => Stream<void>.value(null));
      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.play(mockSource, volume: 1.0, looping: false))
          .thenReturn(fakeHandle);

      await repo.cache(['sound.mp3']);
      await repo.play('sound.mp3');

      verify(() => mockSoLoud.play(mockSource, volume: 1.0, looping: false))
          .called(1);
      expect(repo.debugLogs, contains('Playing sound sound.mp3'));
    });

    test('play throws StateError if asset is not cached', () async {
      expect(
        () => repo.play('uncached.mp3'),
        throwsStateError,
      );
    });

    test('play invokes onError and rethrows on exception during play',
        () async {
      final mockSource = MockAudioSource();
      final exception = Exception('Play failed');
      Object? capturedError;

      SoLoudRepo.onError = (e, stack) {
        capturedError = e;
      };

      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.play(mockSource, volume: 1.0, looping: false))
          .thenThrow(exception);

      await repo.cache(['sound.mp3']);

      expect(() => repo.play('sound.mp3'), throwsA(equals(exception)));
      expect(capturedError, equals(exception));
    });
  });

  group('SoLoudRepo - pause & resume', () {
    test('pause and resume toggle pause state for playing sound', () async {
      final mockSource = MockAudioSource();
      const fakeHandle = SoundHandle(202);

      when(() => mockSource.allInstancesFinished)
          .thenAnswer((_) => Stream<void>.value(null));
      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.play(mockSource, volume: 1.0, looping: false))
          .thenReturn(fakeHandle);
      when(() => mockSoLoud.setPause(fakeHandle, true)).thenReturn(true);
      when(() => mockSoLoud.setPause(fakeHandle, false)).thenReturn(true);

      await repo.cache(['sound.mp3']);

      // Start playing sound
      final playFuture = repo.play('sound.mp3');

      expect(repo.isPaused('sound.mp3'), isFalse);

      await repo.pause('sound.mp3');
      expect(repo.isPaused('sound.mp3'), isTrue);
      verify(() => mockSoLoud.setPause(fakeHandle, true)).called(1);

      await repo.resume('sound.mp3');
      expect(repo.isPaused('sound.mp3'), isFalse);
      verify(() => mockSoLoud.setPause(fakeHandle, false)).called(1);

      await playFuture;
    });

    test('pause and resume do nothing if handle is not active', () async {
      await repo.pause('nonexistent.mp3');
      await repo.resume('nonexistent.mp3');

      verifyNever(() => mockSoLoud.setPause(any(), any()));
      expect(repo.isPaused('nonexistent.mp3'), isFalse);
    });

    test('pause invokes onError and rethrows on exception', () async {
      final mockSource = MockAudioSource();
      const fakeHandle = SoundHandle(303);
      final exception = Exception('Pause error');
      Object? capturedError;

      SoLoudRepo.onError = (e, stack) {
        capturedError = e;
      };

      when(() => mockSource.allInstancesFinished)
          .thenAnswer((_) => Stream<void>.value(null));
      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.play(mockSource, volume: 1.0, looping: false))
          .thenReturn(fakeHandle);
      when(() => mockSoLoud.setPause(fakeHandle, true)).thenThrow(exception);

      await repo.cache(['sound.mp3']);
      final playFuture = repo.play('sound.mp3');

      expect(() => repo.pause('sound.mp3'), throwsA(equals(exception)));
      expect(capturedError, equals(exception));

      await playFuture;
    });

    test('resume invokes onError and rethrows on exception', () async {
      final mockSource = MockAudioSource();
      const fakeHandle = SoundHandle(304);
      final exception = Exception('Resume error');
      Object? capturedError;

      SoLoudRepo.onError = (e, stack) {
        capturedError = e;
      };

      when(() => mockSource.allInstancesFinished)
          .thenAnswer((_) => Stream<void>.value(null));
      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.play(mockSource, volume: 1.0, looping: false))
          .thenReturn(fakeHandle);
      when(() => mockSoLoud.setPause(fakeHandle, false)).thenThrow(exception);

      await repo.cache(['sound.mp3']);
      final playFuture = repo.play('sound.mp3');

      expect(() => repo.resume('sound.mp3'), throwsA(equals(exception)));
      expect(capturedError, equals(exception));

      await playFuture;
    });
  });

  group('SoLoudRepo - stop & stopAll', () {
    test('stop stops sound and removes active handle', () async {
      final mockSource = MockAudioSource();
      const fakeHandle = SoundHandle(404);

      when(() => mockSource.allInstancesFinished)
          .thenAnswer((_) => Stream<void>.value(null));
      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.play(mockSource, volume: 1.0, looping: false))
          .thenReturn(fakeHandle);
      when(() => mockSoLoud.setPause(fakeHandle, true)).thenReturn(true);
      when(() => mockSoLoud.stop(fakeHandle)).thenAnswer((_) async {});

      await repo.cache(['sound.mp3']);
      final playFuture = repo.play('sound.mp3');

      await repo.pause('sound.mp3');
      await repo.stop('sound.mp3');

      verify(() => mockSoLoud.stop(fakeHandle)).called(1);
      expect(repo.isPaused('sound.mp3'), isFalse);

      await playFuture;
    });

    test('stop does nothing if asset has no active handle', () async {
      await repo.stop('inactive.mp3');
      verifyNever(() => mockSoLoud.stop(any()));
    });

    test('stop invokes onError and rethrows on exception', () async {
      final mockSource = MockAudioSource();
      const fakeHandle = SoundHandle(405);
      final exception = Exception('Stop error');
      Object? capturedError;

      SoLoudRepo.onError = (e, stack) {
        capturedError = e;
      };

      when(() => mockSource.allInstancesFinished)
          .thenAnswer((_) => Stream<void>.value(null));
      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.play(mockSource, volume: 1.0, looping: false))
          .thenReturn(fakeHandle);
      when(() => mockSoLoud.stop(fakeHandle)).thenThrow(exception);

      await repo.cache(['sound.mp3']);
      final playFuture = repo.play('sound.mp3');

      expect(() => repo.stop('sound.mp3'), throwsA(equals(exception)));
      expect(capturedError, equals(exception));

      await playFuture;
    });

    test('stopAll stops all playing sounds and clears state', () async {
      final mockSource1 = MockAudioSource();
      final mockSource2 = MockAudioSource();
      const fakeHandle1 = SoundHandle(501);
      const fakeHandle2 = SoundHandle(502);

      when(() => mockSource1.allInstancesFinished)
          .thenAnswer((_) => Stream<void>.value(null));
      when(() => mockSource2.allInstancesFinished)
          .thenAnswer((_) => Stream<void>.value(null));
      when(() => mockSoLoud.loadAsset('sound1.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource1);
      when(() => mockSoLoud.loadAsset('sound2.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource2);
      when(() => mockSoLoud.play(mockSource1, volume: 1.0, looping: false))
          .thenReturn(fakeHandle1);
      when(() => mockSoLoud.play(mockSource2, volume: 1.0, looping: false))
          .thenReturn(fakeHandle2);
      when(() => mockSoLoud.stop(any())).thenAnswer((_) async {});

      await repo.cache(['sound1.mp3', 'sound2.mp3']);

      final f1 = repo.play('sound1.mp3');
      final f2 = repo.play('sound2.mp3');

      await repo.stopAll();

      verify(() => mockSoLoud.stop(fakeHandle1)).called(1);
      verify(() => mockSoLoud.stop(fakeHandle2)).called(1);

      await f1;
      await f2;
    });

    test('stopAll returns early when no sounds are playing', () async {
      await repo.stopAll();
      verifyNever(() => mockSoLoud.stop(any()));
    });
  });

  group('SoLoudRepo - disposeAsset & dispose', () {
    test('disposeAsset disposes source and removes from sounds', () async {
      final mockSource = MockAudioSource();

      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.disposeSource(mockSource)).thenAnswer((_) async {});

      await repo.cache(['sound.mp3']);
      await repo.disposeAsset('sound.mp3');

      verify(() => mockSoLoud.disposeSource(mockSource)).called(1);

      // Play should now fail as asset was disposed
      expect(() => repo.play('sound.mp3'), throwsStateError);
    });

    test('disposeAsset ignores non-existent asset', () async {
      await repo.disposeAsset('nonexistent.mp3');
      verifyNever(() => mockSoLoud.disposeSource(any()));
    });

    test('disposeAsset invokes onError and rethrows on exception', () async {
      final mockSource = MockAudioSource();
      final exception = Exception('Dispose asset error');
      Object? capturedError;

      SoLoudRepo.onError = (e, stack) {
        capturedError = e;
      };

      when(() => mockSoLoud.loadAsset('sound.mp3', mode: LoadMode.memory))
          .thenAnswer((_) async => mockSource);
      when(() => mockSoLoud.disposeSource(mockSource)).thenThrow(exception);

      await repo.cache(['sound.mp3']);

      expect(() => repo.disposeAsset('sound.mp3'), throwsA(equals(exception)));
      expect(capturedError, equals(exception));
    });

    test('dispose cancels subscription, stops sounds, and deinits SoLoud',
        () async {
      when(() => mockSoLoud.init()).thenAnswer((_) async {});
      when(() => mockSoLoud.setMaxActiveVoiceCount(128)).thenReturn(128);
      when(() => mockSoLoud.deinit()).thenReturn(null);

      await repo.init();
      await repo.dispose();

      verify(() => mockSoLoud.deinit()).called(1);
    });
  });
}
