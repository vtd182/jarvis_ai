import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/const/resource.dart';
import 'package:jarvis_ai/modules/knowledge_base/domain/models/knowledge.dart';

class UnitTableController extends GetxController {
  final knowledges = [
    Knowledge(
      'Knowledge 1',
      'Description 1',
      DateTime.now(),
      [
        LocalFile('Local File 1', 'Source 1', DateTime.now(), true, 'Path 1'),
        Github('Github 1', 'Source 1', DateTime.now(), true, 'Path 1'),
        GoogleDrive(
            'Google Drive 1', 'Source 1', DateTime.now(), true, 'Path 1'),
      ],
    ),
    Knowledge(
      'Knowledge 2',
      'Description 2',
      DateTime.now(),
      [
        LocalFile('Local File 2', 'Source 2', DateTime.now(), true, 'Path 2'),
        Github('Github 2', 'Source 2', DateTime.now(), true, 'Path 2'),
        GoogleDrive(
            'Google Drive 2', 'Source 2', DateTime.now(), true, 'Path 2'),
      ],
    ),
    Knowledge(
      'Knowledge 3',
      'Description 3',
      DateTime.now(),
      [
        LocalFile('Local File 3', 'Source 3', DateTime.now(), true, 'Path 3'),
        Github('Github 3', 'Source 3', DateTime.now(), true, 'Path 3'),
        GoogleDrive(
            'Google Drive 3', 'Source 3', DateTime.now(), true, 'Path 3'),
     ])
  ];
  final indexAiAgent = 0.obs;
  final inputMessageFocusNode = FocusNode();

  @override
  void dispose() {
    inputMessageFocusNode.dispose();
    super.dispose();
  }
}
