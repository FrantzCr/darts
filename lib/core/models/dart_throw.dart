import 'package:flutter/material.dart';

enum DartMultiplier { miss, single, double, triple }

class DartThrow {
  final String id;
  final int sector;
  final DartMultiplier multiplier;
  final int value;
  // viewBox coords (0,0 = center of board), null for misses
  final Offset? tapOffset;

  const DartThrow({
    required this.id,
    required this.sector,
    required this.multiplier,
    required this.value,
    this.tapOffset,
  });

  String get label {
    if (multiplier == DartMultiplier.miss) return 'M';
    if (id == 'bull-50') return 'BULL';
    if (id == 'bull-25') return '25';
    if (multiplier == DartMultiplier.triple) return 'T$sector';
    if (multiplier == DartMultiplier.double) return 'D$sector';
    return '$sector';
  }

  static DartThrow miss({Offset? tapOffset}) => DartThrow(
    id: 'miss',
    sector: 0,
    multiplier: DartMultiplier.miss,
    value: 0,
    tapOffset: tapOffset,
  );
}
