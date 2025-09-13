import 'package:flutter/widgets.dart';

enum Breakpoint { xs, sm, md, lg, xl }

Breakpoint breakpointForWidth(double w) {
  if (w < 450) return Breakpoint.xs;
  if (w < 740) return Breakpoint.sm;
  if (w < 1200) return Breakpoint.md;
  if (w < 1600) return Breakpoint.lg;
  return Breakpoint.xl;
}

extension BreakpointX on BuildContext {
  Breakpoint get layoutBreakPoint => breakpointForWidth(MediaQuery.sizeOf(this).width);
}

int movieGridColumns(Breakpoint bp) {
  switch (bp) {
    case Breakpoint.xs:
      return 1;
    case Breakpoint.sm:
      return 2;
    case Breakpoint.md:
      return 3;
    case Breakpoint.lg:
      return 4;
    case Breakpoint.xl:
      return 6;
  }
}
