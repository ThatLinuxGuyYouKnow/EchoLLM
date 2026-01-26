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
  final String company;
  final String type;
  final String subtitle;
  final String description;
  final String knowledgeCutoff;
  final String speed;
  final String params;

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
    required this.company,
    required this.type,
    required this.subtitle,
    required this.description,
    required this.knowledgeCutoff,
    required this.speed,
    required this.params,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      provider: (json['Provider'] ?? '').toString(),
      costInput: (json['Cost_input'] ?? '').toString(),
      costInputInt: double.tryParse((json['Cost_int'] ?? 0).toString()) ?? 0.0,
      costOutput: (json['Cost_output'] ?? '').toString(),
      costOutputInt:
          double.tryParse((json['Cost_output_int'] ?? 0).toString()) ?? 0.0,
      brandingImage: (json['branding_image'] ?? '').toString(),
      contextWindow: (json['context_window'] ?? '').toString(),
      company: (json['company'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      knowledgeCutoff: (json['knowledge_cutoff'] ?? '').toString(),
      speed: (json['speed'] ?? '').toString(),
      params: (json['params'] ?? '').toString(),
    );
  }

  // Added: serialize ModelInfo back to Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'Provider': provider,
      'Cost_input': costInput,
      'Cost_int': costInputInt,
      'Cost_output': costOutput,
      'Cost_output_int': costOutputInt,
      'branding_image': brandingImage,
      'context_window': contextWindow,
      'company': company,
      'type': type,
      'subtitle': subtitle,
      'description': description,
      'knowledge_cutoff': knowledgeCutoff,
      'speed': speed,
      'params': params,
    };
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
    try {
      return {for (var m in _models) m.name: m.slug};
    } catch (e) {
      print('Error in onlineModels getter: $e');
      return {};
    }
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

  // Fixed: return ModelInfo and avoid undefined variable 'name'
  ModelInfo modelDataFromSlug({required String slug}) {
    return _models.firstWhere(
      (m) => m.slug == slug,
      orElse: () => ModelInfo(
        name: '',
        slug: '',
        provider: '',
        costInput: '',
        costInputInt: 0.0,
        costOutput: '',
        costOutputInt: 0.0,
        brandingImage: '',
        contextWindow: '',
        company: '',
        type: '',
        subtitle: '',
        description: '',
        knowledgeCutoff: '',
        speed: '',
        params: '',
      ),
    );
  }

  // Added: return all models as a list of maps
  List<Map<String, dynamic>> allModelsAsMap() {
    return _models.map((m) => m.toJson()).toList();
  }

  // Added: return all models as a JSON string (same structure as the asset)
  String allModelsAsJson() {
    return json.encode({'models': allModelsAsMap()});
  }

  /// Return a single model as a Map given its slug, or null if not found.
  Map<String, dynamic>? getModelAsMapBySlug(String slug) {
    final model = getModelBySlug(slug);
    return model?.toJson();
  }

  /// Return a single model as a JSON string given its slug, or null if not found.
  String? getModelAsJsonBySlug(String slug) {
    final map = getModelAsMapBySlug(slug);
    return map == null ? null : json.encode(map);
  }

  String getModelProvider(String slug) {
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
                contextWindow: '',
                company: '',
                type: '',
                subtitle: '',
                description: '',
                knowledgeCutoff: '',
                speed: '',
                params: ''))
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
                contextWindow: '',
                company: '',
                type: '',
                subtitle: '',
                description: '',
                knowledgeCutoff: '',
                speed: '',
                params: ''))
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

  String getModelBrandingBySlug(String slug) {
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
                contextWindow: '',
                company: '',
                type: '',
                subtitle: '',
                description: '',
                knowledgeCutoff: '',
                speed: '',
                params: ''))
        .brandingImage;
  }
}

/// Global accessor for backwards compatibility
/// This provides the same Map<String, String> interface as the old onlineModels
Map<String, String> get onlineModels => ModelDataService().onlineModels;
