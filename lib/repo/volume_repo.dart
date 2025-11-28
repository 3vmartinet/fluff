import 'dart:async';

import 'package:volume_controller/volume_controller.dart';

class VolumeRepo {
  Future<double> get volume async =>
      await VolumeController.instance.getVolume();

  Future<bool> get muted async => await VolumeController.instance.isMuted();

  Future<void> mute() async => await VolumeController.instance.setMute(true);
  Future<void> unmute() async => await VolumeController.instance.setMute(false);

  Future<void> setAverageVolume() async {
    await VolumeController.instance.setVolume(0.5);
  }

  StreamSubscription addListener(Function(double) listener) {
    return VolumeController.instance.addListener(listener);
  }

  void removeListener() {
    VolumeController.instance.removeListener();
  }
}
