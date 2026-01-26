import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:echo_llm/widgets/modals/enterApiKeyModal.dart';
import 'package:echo_llm/widgets/modals/modelPreviewCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:echo_llm/state_management/keysState.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<KeysState>(
        builder: (context, keysState, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: onlineModels.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final modelName = onlineModels.keys.elementAt(index);
                final slug = onlineModels[modelName] ?? '';
                final isAvailable = keysState.isModelAvailable(slug);
                String modelIcon = getModelIcon(modelSlug: slug);
                return ModelTile(
                  modelFamilyIconPath: modelIcon,
                  modelSlug: slug,
                  tileTitle: modelName,
                  isAvailable: isAvailable,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ModelTile extends StatefulWidget {
  final String tileTitle;
  final bool isAvailable;
  final String modelSlug;
  final String modelFamilyIconPath;

  ModelTile(
      {super.key,
      required this.tileTitle,
      required this.isAvailable,
      required this.modelSlug,
      required this.modelFamilyIconPath});

  @override
  State<ModelTile> createState() => _ModelTileState();
}

class _ModelTileState extends State<ModelTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          final modelData =
              ModelDataService().getModelAsMapBySlug(widget.modelSlug) ?? {};
          showDialog(
              context: context,
              builder: (modalContext) => ModelPreviewCard(
                    brandingImagePath: ModelDataService()
                        .getModelBrandingBySlug(widget.modelSlug),
                    provider: ModelDataService().getModelType(widget.modelSlug),
                    isAvailable: widget.isAvailable,
                    modelName: widget.tileTitle,
                    modelType: (modelData['type'] ?? '').toString(),
                    description: (modelData['description'] ?? '').toString(),
                    subtitle: (modelData['subtitle'] ?? '').toString(),
                    contextWindow:
                        (modelData['context_window'] ?? '').toString(),
                    modelCompany: (modelData['company'] ?? '').toString(),
                    knowledgeCutoff:
                        (modelData['knowledge_cutoff'] ?? '').toString(),
                    speed: (modelData['speed'] ?? '').toString(),
                    inputCost: (modelData['Cost_input'] ?? '').toString(),
                    params: (modelData['params'] ?? '').toString(),
                    onClose: () => Navigator.of(modalContext).pop(),
                    onSelectModel: () {
                      Navigator.of(modalContext).pop();
                    },
                  ));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 100,
          width: 100,
          constraints: BoxConstraints(
              minWidth: 100, minHeight: 100, maxHeight: 200, maxWidth: 200),
          decoration: BoxDecoration(
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF4C83D1).withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 1),
                    )
                  ]
                : [],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isHovered
                  ? const Color(0xFF4C83D1).withOpacity(0.3)
                  : Colors.transparent,
              width: 1.0,
            ),
            color:
                isHovered ? const Color(0xFF1A1F25) : const Color(0xFF1C1C1D),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            widget.modelFamilyIconPath,
                            width: 25,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.tileTitle,
                              style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!widget.isAvailable) {
                          showDialog(
                            context: context,
                            builder: (_) => EnterApiKeyModal(
                                modelName: widget.tileTitle,
                                modelSlug: widget.modelSlug,
                                context: context),
                          );
                        }
                      },
                      child: Icon(
                        widget.isAvailable
                            ? Icons.check_circle
                            : Icons.add_circle,
                        color: widget.isAvailable
                            ? const Color(0xFF4C83D1)
                            : Colors.white.withOpacity(isHovered ? 0.9 : 0.7),
                        size: isHovered ? 22 : 20,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getModelIcon({required String modelSlug}) {
  String model_family = ModelDataService().getModelType(modelSlug);
  if (model_family == 'gemini') {
    return 'assets/model_icons/gemini-icon.png';
  } else if (model_family == 'openai') {
    return 'assets/model_icons/openai-icon.png';
  } else if (model_family == 'claude') {
    return 'assets/model_icons/claude-icon.png';
  } else {
    return 'assets/model_icons/xai-icon.png';
  }
}
