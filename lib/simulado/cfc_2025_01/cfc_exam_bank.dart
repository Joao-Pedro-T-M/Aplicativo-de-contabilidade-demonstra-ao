import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/course_models.dart';

class CfcQuestionDto {
  final int questionNumber;
  final String subject;
  final String statement;
  final List<String> options;
  final String correctOption;
  final String explanation;

  final List<String>? dreTableHeaders;
  final List<List<String>>? dreTableRows;

  final List<String>? tableHeaders;
  final List<List<String>>? tableRows;

  const CfcQuestionDto({
    required this.questionNumber,
    required this.subject,
    required this.statement,
    required this.options,
    required this.correctOption,
    required this.explanation,
    this.dreTableHeaders,
    this.dreTableRows,
    this.tableHeaders,
    this.tableRows,
  });

  factory CfcQuestionDto.fromJson(Map<String, dynamic> json) {
    final dreTable = json['dreTable'] as Map<String, dynamic>?;
    final table = json['table'] as Map<String, dynamic>?;

    return CfcQuestionDto(
      questionNumber: (json['questionNumber'] as num).toInt(),
      subject: json['subject'] as String,
      statement: json['statement'] as String,
      options: (json['options'] as List).map((e) => e.toString()).toList(),
      correctOption: json['correctOption'] as String,
      explanation: json['explanation'] as String? ?? '',
      dreTableHeaders: dreTable?['headers'] != null
          ? List<String>.from(dreTable!['headers'] as List)
          : null,
      dreTableRows: dreTable?['rows'] != null
          ? (dreTable!['rows'] as List)
              .map((row) => List<String>.from(row as List))
              .toList()
          : null,
      tableHeaders: table?['headers'] != null
          ? List<String>.from(table!['headers'] as List)
          : null,
      tableRows: table?['rows'] != null
          ? (table!['rows'] as List)
              .map((row) => List<String>.from(row as List))
              .toList()
          : null,
    );
  }

  ExamQuestion toModel({
    required String fileTag,
    required int examYear,
  }) {
    return ExamQuestion(
      id: '${fileTag}_q$questionNumber',
      subject: subject,
      statement: statement,
      options: options,
      correctOption: correctOption,
      explanation: explanation,
      examYear: examYear,
      dreTableHeaders: dreTableHeaders,
      dreTableRows: dreTableRows,
      tableHeaders: tableHeaders,
      tableRows: tableRows,
    );
  }
}
class _ExamAsset {
  final String assetPath;
  final int examYear;
  final String fileTag;

  const _ExamAsset({
    required this.assetPath,
    required this.examYear,
    required this.fileTag,
  });
}

class CfcExamBank {
  static const List<_ExamAsset> _assets = [
    _ExamAsset(
      assetPath: 'assets/data/cfc_2025_01_questions.json',
      examYear: 2025,
      fileTag: 'cfc_2025_01',
    )
  ];

  static Future<List<ExamQuestion>> load() async {
    try {
      final allQuestions = <ExamQuestion>[];

      for (final asset in _assets) {
        final raw = await rootBundle.loadString(asset.assetPath);
        final decoded = jsonDecode(raw);

        List<dynamic> list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map && decoded['questions'] is List) {
          list = decoded['questions'] as List<dynamic>;
        } else {
          throw Exception('Formato de JSON desconhecido em ${asset.assetPath}');
        }

        final questions = list.map((e) {
          final dto = CfcQuestionDto.fromJson(e as Map<String, dynamic>);
          return dto.toModel(
            fileTag: asset.fileTag,
            examYear: asset.examYear,
          );
        }).toList();

        allQuestions.addAll(questions);
      }

      return allQuestions;
    } catch (e) {
      debugPrint('ERRO AO CARREGAR QUESTÕES: $e');
      return [];
    }
  }
}