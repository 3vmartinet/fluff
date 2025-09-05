import 'package:flutter/widgets.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:share_plus/share_plus.dart';

extension BuildContextExtension on BuildContext {
  bool get isLargeScreen => Breakpoints.large.isActive(this);

  Future<ShareResult> shareFile({
    required String path,
    String? text,
  }) {
    final box = findRenderObject() as RenderBox?;

    final params = ShareParams(
      text: text,
      files: [XFile(path)],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
    return SharePlus.instance.share(params);
  }
}
