import 'package:volume_watcher_plus/volume_watcher_plus.dart';

class VolumeRepo {
  Future<double> get volume async => await VolumeWatcherPlus.getCurrentVolume;

  Future<bool> initMutedState() async {
    final currentVolume = await volume;
    _muted = currentVolume == 0;
    return _muted;
  }

  bool _muted = false;
  bool get muted => _muted;

  void mute() => _muted = true;
  void unmute() => _muted = false;

  Future<bool> setAverageVolume() async {
    final volume = await VolumeWatcherPlus.getMaxVolume / 2;
    _muted = false;
    return await VolumeWatcherPlus.setVolume(volume);
  }
}
