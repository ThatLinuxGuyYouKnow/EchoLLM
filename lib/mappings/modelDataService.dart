import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Represents a model's data from modelData.json
class ModelInfo {
  final String name;
  final String slug;
  final String provider;
  final String costInput;
  final double costInputInt;
  final String costOutput;
  final double costOutputInt;
  final String brandingImage;
  final String contextWindow;

  ModelInfo({
    required this.name,
    required this.slug,
    required this.provider,
    required this.costInput,
    required this.costInputInt,
    required this.costOutput,
    required this.costOutputInt,
    required this.brandingImage,
    required this.contextWindow,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      provider: json['Provider'] ?? '',
      costInput: json['Cost_input'] ?? '',
      costInputInt: (json['Cost_int'] ?? 0).toDouble(),
      costOutput: json['Cost_output'] ?? '',
      costOutputInt: (json['Cost_output_int'] ?? 0).toDouble(),
      brandingImage: json['branding_image'] ?? '',
      contextWindow: json['context_window'] ?? '',
    );
  }
}

/// Singleton service to load and provide model data from modelData.json.
/// This replaces the old onlineModels Map<String, String>.
class ModelDataService {
  static final ModelDataService _instance = ModelDataService._internal();
  factory ModelDataService() => _instance;
  ModelDataService._internal();

  List<ModelInfo> _models = [];
  bool _isLoaded = false;

  /// The list of all ModelInfo objects
  List<ModelInfo> get models => _models;

  /// Whether the data has been loaded
  bool get isLoaded => _isLoaded;

  /// Map of model name -> slug (backwards compatible with onlineModels)
  Map<String, String> get onlineModels {
    return {for (var m in _models) m.name: m.slug};
  }

  /// Map of slug -> model name (reverse lookup)
  Map<String, String> get slugToName {
    return {for (var m in _models) m.slug: m.name};
  }

  /// Get all model names
  List<String> get modelNames => _models.map((m) => m.name).toList();

  /// Get all model slugs
  List<String> get modelSlugs => _models.map((m) => m.slug).toList();

  /// Load the model data from JSON asset
  Future<void> loadModels() async {
    if (_isLoaded) return;

    try {
      final String jsonString =
          await rootBundle.loadString('lib/mappings/modelData.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> modelsJson = jsonData['models'] ?? [];

      _models = modelsJson.map((m) => ModelInfo.fromJson(m)).toList();
      _isLoaded = true;
    } catch (e) {
      print('Error loading model data: $e');
      _models = [];
      _isLoaded = false;
    }
  }

  /// Get ModelInfo by name
  ModelInfo? getModelByName(String name) {
    try {
      return _models.firstWhere((m) => m.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get ModelInfo by slug
  ModelInfo? getModelBySlug(String slug) {
    try {
      return _models.firstWhere((m) => m.slug == slug);
    } catch (e) {
      return null;
    }
  }

  /// Get slug from model name
  String? getSlugByName(String name) {
    return getModelByName(name)?.slug;
  }

  /// Get model name from slug
  String? getNameBySlug(String slug) {
    return getModelBySlug(slug)?.name;
  }

  modelDatafromSlug({required String slug}) {
    return _models.firstWhere((m) => m.slug == slug,
        orElse: () => ModelInfo(
            name: '',
            slug: '',
            provider: '',
            costInput: '',
            costInputInt: 0.0,
            costOutput: '',
            costOutputInt: 0.0,
            brandingImage: '',
            contextWindow: ''));
  }

  String getModelProvider(slug) {
    final provider = _models
        .firstWhere((m) => m.slug == slug,
            orElse: () => ModelInfo(
                name: '',
                slug: '',
                provider: '',
                costInput: '',
                costInputInt: 0.0,
                costOutput: '',
                costOutputInt: 0.0,
                brandingImage: '',
                contextWindow: ''))
        .provider
        .toLowerCase();

    return provider;
  }

  String getModelType(String slug) {
    final provider = _models
        .firstWhere((m) => m.slug == slug,
            orElse: () => ModelInfo(
                name: '',
                slug: '',
                provider: '',
                costInput: '',
                costInputInt: 0.0,
                costOutput: '',
                costOutputInt: 0.0,
                brandingImage: '',
                contextWindow: ''))
        .provider
        .toLowerCase();

    // Normalize provider strings to canonical family tokens used across the UI
    if (provider.contains('google') || provider.contains('gemini')) {
      return 'gemini';
    }
    if (provider.contains('openai') || provider.contains('gpt')) {
      return 'openai';
    }
    if (provider.contains('anthropic') || provider.contains('claude')) {
      return 'claude';
    }
    if (provider.contains('xai')) {
      return 'x-ai';
    }

    // Fallback to the lowercase provider string if no mapping matched
    return provider;
  }

  getModelBrandingBySlug(String slug) {
    return _models
        .firstWhere((m) => m.slug == slug,
            orElse: () => ModelInfo(
                name: '',
                slug: '',
                provider: '',
                costInput: '',
                costInputInt: 0.0,
                costOutput: '',
                costOutputInt: 0.0,
                brandingImage: '',
                contextWindow: ''))
        .brandingImage;
  }
}

/// Global accessor for backwards compatibility
/// This provides the same Map<String, String> interface as the old onlineModels
Map<String, String> get onlineModels => ModelDataService().onlineModels;
