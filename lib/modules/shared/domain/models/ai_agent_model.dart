class AiAgentModel {
  final String name;
  final String description;
  final int numberToken;
  final String imagePath;
  String? prompt;
  List<String>? attachmentPaths;

  AiAgentModel(
      {required this.name, required this.description, required this.numberToken, required this.imagePath, this.prompt, this.attachmentPaths});
}
