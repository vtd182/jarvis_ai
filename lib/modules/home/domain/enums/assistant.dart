import 'package:json_annotation/json_annotation.dart';

enum Assistant {
  @JsonValue('claude-3-haiku-20240307')
  claude_3_haiku_20240307,
  @JsonValue('claude-3-5-sonet-20240620')
  claude_3_5_sonet_20240620,
  @JsonValue('gemini-1-5-flash-latest')
  gemini_1_5_flash_latest,
  @JsonValue('gemini-1-5-pro-latest')
  gemini_1_5_pro_latest,
  @JsonValue('gpt-4o')
  gpt_4o,
  @JsonValue('gpt-4o-mini')
  gpt_4o_mini,
}

extension AssistantExtension on Assistant {
  String get value {
    switch (this) {
      case Assistant.claude_3_haiku_20240307:
        return 'claude-3-haiku-20240307';
      case Assistant.claude_3_5_sonet_20240620:
        return 'claude-3-5-sonet-20240620';
      case Assistant.gemini_1_5_flash_latest:
        return 'gemini-1-5-flash-latest';
      case Assistant.gemini_1_5_pro_latest:
        return 'gemini-1-5-pro-latest';
      case Assistant.gpt_4o:
        return 'gpt-4o';
      case Assistant.gpt_4o_mini:
        return 'gpt-4o-mini';
      default:
        return 'gpt-4o-mini';
    }
  }
}

extension AssistantStringExtension on String {
  Assistant toAssistant() {
    switch (this) {
      case 'claude-3-haiku-20240307':
        return Assistant.claude_3_haiku_20240307;
      case 'claude-3-5-sonet-20240620':
        return Assistant.claude_3_5_sonet_20240620;
      case 'gemini-1-5-flash-latest':
        return Assistant.gemini_1_5_flash_latest;
      case 'gemini-1-5-pro-latest':
        return Assistant.gemini_1_5_pro_latest;
      case 'gpt-4o':
        return Assistant.gpt_4o;
      case 'gpt-4o-mini':
        return Assistant.gpt_4o_mini;
      default:
        return Assistant.gpt_4o_mini;
    }
  }
}
