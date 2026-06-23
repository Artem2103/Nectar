import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// The nutrition estimate returned by the vision model for a meal photo.
///
/// Mirrors the JSON the model is instructed to reply with.
class MealAnalysis {
  const MealAnalysis({
    required this.name,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.fiberG = 0,
    this.sugarG = 0,
    this.sodiumMg = 0,
  });

  final String name;
  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final double sugarG;
  final double sodiumMg;

  factory MealAnalysis.fromJson(Map<String, dynamic> json) => MealAnalysis(
        name: json['name'] as String,
        kcal: (json['kcal'] as num).toInt(),
        proteinG: (json['proteinG'] as num).toDouble(),
        carbsG: (json['carbsG'] as num).toDouble(),
        fatG: (json['fatG'] as num).toDouble(),
        fiberG: (json['fiberG'] as num?)?.toDouble() ?? 0,
        sugarG: (json['sugarG'] as num?)?.toDouble() ?? 0,
        sodiumMg: (json['sodiumMg'] as num?)?.toDouble() ?? 0,
      );
}

/// Sends [imageFile] to the Claude vision API and returns the estimated meal
/// nutrition.
///
/// The API key is injected at build time and must never be hardcoded:
///   flutter run --dart-define=ANTHROPIC_API_KEY=sk-ant-...
/// Throws if the key is missing or the model returns an unparseable response.
Future<MealAnalysis> analyseImage(File imageFile) async {
  const apiKey = String.fromEnvironment('ANTHROPIC_API_KEY');
  if (apiKey.isEmpty) {
    throw StateError(
      'ANTHROPIC_API_KEY is not set. Pass it via '
      '--dart-define=ANTHROPIC_API_KEY=sk-ant-...',
    );
  }

  final bytes = await imageFile.readAsBytes();
  final base64Image = base64Encode(bytes);
  final response = await http.post(
    Uri.parse('https://api.anthropic.com/v1/messages'),
    headers: {
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    },
    body: jsonEncode({
      'model': 'claude-haiku-4-5-20251001',
      'max_tokens': 256,
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'image',
              'source': {
                'type': 'base64',
                'media_type': 'image/jpeg',
                'data': base64Image,
              },
            },
            {
              'type': 'text',
              'text':
                  'Identify the meal in this image. Reply ONLY with valid JSON: '
                      '{"name":"...","kcal":...,"proteinG":...,"carbsG":...,"fatG":...,'
                      '"fiberG":...,"sugarG":...,"sodiumMg":...}. '
                      'proteinG, carbsG, fatG, fiberG and sugarG are grams; '
                      'sodiumMg is milligrams. Use typical serving-size estimates.',
            },
          ],
        },
      ],
    }),
  );

  if (response.statusCode != 200) {
    throw http.ClientException(
      'Meal analysis failed (${response.statusCode}): ${response.body}',
    );
  }

  final body = jsonDecode(response.body) as Map<String, dynamic>;
  final text = (body['content'] as List).first['text'] as String;
  return MealAnalysis.fromJson(jsonDecode(text) as Map<String, dynamic>);
}
