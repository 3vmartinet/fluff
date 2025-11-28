import 'package:fluff/mixin/receive_port_mixin.dart';
import 'package:volume_watcher_plus/volume_watcher_plus.dart';

class VolumeRepo with ReceivePortMixin {
  Future<double> get volume async => await VolumeWatcherPlus.getCurrentVolume;

  Future<bool> initMutedState() async {
    final currentVolume = await volume;
    _muted = currentVolume == 0;
    return _muted;
  }

  Future<void> awaitMutedState() async {
    _muted = await waitForReceivedValue();
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

  int? addListener(Function(double) listener) {
    return VolumeWatcherPlus.addListener(listener);
  }

  void removeListener(int id) {
    VolumeWatcherPlus.removeListener(id);
  }
}
