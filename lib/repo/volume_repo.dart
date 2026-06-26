import 'dart:async';

import 'package:volume_controller/volume_controller.dart';

class VolumeRepo {
  Future<double> get volume async =>
      await VolumeController.instance.getVolume();

  Future<bool> get muted async => await VolumeController.instance.isMuted();

  Future<void> mute() async => await VolumeController.instance.setMute(true);
  Future<void> unmute() async => await VolumeController.instance.setMute(false);

  final StreamController<double> _volumeController =
      StreamController.broadcast();

  Stream<double> get volumeStream => _volumeController.stream;

  void init() {
    VolumeController.instance.addListener((v) => _volumeController.add(v));
  }

  Future<void> setAverageVolume() async {
    await VolumeController.instance.setVolume(0.5);
  }

  /// On iOS, the underlying implementation deactivates the audio session.
  /// Therefore, be sure to call dispose when the application is shutting down.
  void dispose() {
    _volumeController.close();
    VolumeController.instance.removeListener();
  }
}
