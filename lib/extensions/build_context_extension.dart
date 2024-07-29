library fluff;

import 'package:flutter/widgets.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

extension BuildContextExtension on BuildContext {
  bool get isLargeScreen => Breakpoints.large.isActive(this);
}
