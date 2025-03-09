import 'dart:io';

enum InterpretationSource {
  camera,
  image,
  video,
}

class SignInterpretation {
  final String id;
  final String text;
  final DateTime timestamp;
  final InterpretationSource source;
  final String? imagePath;
  final String? videoPath;
  final double confidence;
  final List<SignGesture>? detectedGestures;

  SignInterpretation({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.source,
    this.imagePath,
    this.videoPath,
    required this.confidence,
    this.detectedGestures,
  });

  factory SignInterpretation.fromJson(Map<String, dynamic> json) {
    return SignInterpretation(
      id: json['id'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      source: InterpretationSource.values.byName(json['source']),
      imagePath: json['imagePath'],
      videoPath: json['videoPath'],
      confidence: json['confidence'],
      detectedGestures: json['detectedGestures'] != null
          ? (json['detectedGestures'] as List)
              .map((e) => SignGesture.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'source': source.name,
      'imagePath': imagePath,
      'videoPath': videoPath,
      'confidence': confidence,
      'detectedGestures': detectedGestures?.map((e) => e.toJson()).toList(),
    };
  }
}

class SignGesture {
  final String label;
  final double confidence;
  final List<double>? boundingBox; // [x, y, width, height]

  SignGesture({
    required this.label,
    required this.confidence,
    this.boundingBox,
  });

  factory SignGesture.fromJson(Map<String, dynamic> json) {
    return SignGesture(
      label: json['label'],
      confidence: json['confidence'],
      boundingBox: json['boundingBox'] != null
          ? (json['boundingBox'] as List).cast<double>()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'confidence': confidence,
      'boundingBox': boundingBox,
    };
  }
} 