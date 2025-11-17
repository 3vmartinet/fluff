import 'package:volume_watcher_plus/volume_watcher_plus.dart';

class VolumeRepo {
  VolumeRepo() {
    volume.then((value) => _muted = value == 0);
  }

  bool _muted = false;
  bool get muted => _muted;

  Future<double> get volume async => await VolumeWatcherPlus.getCurrentVolume;
  Future<double> get max async => await VolumeWatcherPlus.getMaxVolume;

  void mute() => _muted = true;
  void unmute() => _muted = false;

  Future<bool> setAverageVolume() async {
    final volume = await VolumeWatcherPlus.getMaxVolume / 2;
    _muted = false;
    return await VolumeWatcherPlus.setVolume(volume);
  }

  int? addListener(Function(double) listener) {
    return VolumeWatcherPlus.addListener(listener);
  }

  void removeListener(int id) {
    VolumeWatcherPlus.removeListener(id);
  }
}
