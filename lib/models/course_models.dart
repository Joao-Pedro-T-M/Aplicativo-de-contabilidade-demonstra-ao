// lib/models/course_models.dart

class Course {
  final String id;
  final String title;
  final String description;
  final List<Trail> trails;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.trails,
  });

  List<Lesson> get lessons => trails.expand((trail) => trail.lessons).toList();
}

class Trail {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;

  Trail({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
  });
}

class Lesson {
  final String id;
  final String title;
  // Pode conter Question (MCQ), MatchQuestion, MatchSumQuestion, DREQuestion, MPMQuestion etc.
  final List<dynamic> questions;

  Lesson({
    required this.id,
    required this.title,
    required this.questions,
  });
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });
}

/// Questão do tipo arrastar/encaixar (matching)
class MatchQuestion {
  final String id;
  final String text; // instrução
  final List<String> items;
  final List<MatchTarget> targets;
  final Map<String, String> correctMap;
  final String? explanation;

  MatchQuestion({
    required this.id,
    required this.text,
    required this.items,
    required this.targets,
    required this.correctMap,
    this.explanation,
  });
}

class MatchTarget {
  final String id;
  final String label;
  /// Sub-targets opcionais (cada um poderá ser uma drop-zone).
  final List<MatchTarget>? subs;

  MatchTarget({
    required this.id,
    required this.label,
    this.subs,
  });
}

/// ---------- NOVAS CLASSES: Questão com soma por seção (BP / DFC) ----------

/// Item com valor numérico (ex.: 'Caixa', 12000.0)
class MatchSumItem {
  final String id;
  final String label;
  final double value;

  MatchSumItem({
    required this.id,
    required this.label,
    required this.value,
  });
}

/// Questão: arrastar itens (cada um com value) para targets e ver subtotais/totais.
/// - expectedTargetTotals (opcional): se fornecido, pode ser usado para validar somas.
/// - dreEntries (opcional): permite integrar lançamentos de DRE na mesma questão.
/// - groups (opcional): permite agrupar targets em blocos como Ativos, Passivos e PL.
class MatchSumQuestion {
  final String id;
  final String text;
  final List<MatchSumItem> items;
  final List<MatchTarget> targets;
  final Map<String, String> correctMap;
  final Map<String, double>? expectedTargetTotals;
  final String? explanation;
  final Map<String, List<String>>? groups;
  final List<DREEntry>? dreEntries;

  /// Novo: suporte para DFC
  final bool isDfcMode;
  final double? initialCash;
  final List<DfcFlowItem>? dfcFlows;

  MatchSumQuestion({
    required this.id,
    required this.text,
    required this.items,
    required this.targets,
    required this.correctMap,
    this.expectedTargetTotals,
    this.explanation,
    this.groups,
    this.dreEntries,
    this.isDfcMode = false,
    this.initialCash,
    this.dfcFlows,
  });
}

/// ---------- NOVAS ADIÇÕES: Suporte a DRE (Débito / Crédito) ----------

/// Entrada de DRE — representa um lançamento / conta que pode ser natureza débito ou crédito.
class DREEntry {
  final String id;
  final String label;
  final double value;
  /// true = débito (ex.: despesas); false = crédito (ex.: receitas)
  final bool isDebit;

  DREEntry({
    required this.id,
    required this.label,
    required this.value,
    required this.isDebit,
  });
}

/// Questão especializada para DRE (usada pelo widget DRE).
/// - entries: lista de lançamentos (cada um com natureza débito/crédito)
/// - correctMap: itemId -> 'deb' | 'cred' (usado para validação de arrastos)
/// - dividendPercent: quando houver lucro positivo, percentual (ex.: 0.2 para 20%)
class DREQuestion {
  final String id;
  final String text;
  final List<DREEntry> entries;
  final Map<String, String> correctMap;
  final double dividendPercent;
  final String? explanation;

  DREQuestion({
    required this.id,
    required this.text,
    required this.entries,
    required this.correctMap,
    this.dividendPercent = 0.20,
    this.explanation,
  });

  /// Calcula totais: débito, crédito e resultado (crédito - débito).
  Map<String, double> computeTotals() {
    double debit = 0.0;
    double credit = 0.0;
    for (var e in entries) {
      if (e.isDebit) {
        debit += e.value;
      } else {
        credit += e.value;
      }
    }
    final result = credit - debit;
    return {'debit': debit, 'credit': credit, 'result': result};
  }

  /// Dado o resultado (lucro), calcula distribuição: dividendos e reservas.
  /// Se não houver lucro (result <= 0), dividendos e reservas são zero.
  Map<String, double> computeDistribution() {
    final totals = computeTotals();
    final result = totals['result'] ?? 0.0;
    if (result <= 0) {
      return {'profit': result, 'dividends': 0.0, 'reserves': 0.0};
    }
    final dividends = result * dividendPercent;
    final reserves = result - dividends;
    return {'profit': result, 'dividends': dividends, 'reserves': reserves};
  }
}

/// Fluxo da DFC
/// category: 'operacional', 'investimento' ou 'financiamento'
/// isInflow: true = entrada de caixa; false = saída de caixa
class DfcFlowItem {
  final String label;
  final double value;
  final String category;
  final bool isInflow;

  const DfcFlowItem({
    required this.label,
    required this.value,
    required this.category,
    required this.isInflow,
  });
}

/// ---------- NOVO: Modelo para questões de MPM (custo médio ponderado móvel) ----------

class MPMPurchase {
  final String id;
  final String label;
  final int quantity;
  final double unitCost;

  const MPMPurchase({
    required this.id,
    required this.label,
    required this.quantity,
    required this.unitCost,
  });

  double get totalCost => quantity * unitCost;
}

/// Questão específica para Média Ponderada Móvel.
/// Pensada para apoiar um fluxo de encaixe/etapas:
/// - compras
/// - custo total
/// - custo médio
/// - estoque final
/// - CMV
/// - resultado do período
class MPMQuestion {
  final String id;
  final String text;
  final List<MPMPurchase> purchases;
  final int saleQuantity;
  final double salePrice;
  final Map<String, String> correctMap;
  final String? explanation;

  const MPMQuestion({
    required this.id,
    required this.text,
    required this.purchases,
    required this.saleQuantity,
    required this.salePrice,
    required this.correctMap,
    this.explanation,
  });

  int get totalPurchasedQuantity =>
      purchases.fold<int>(0, (sum, p) => sum + p.quantity);

  double get totalPurchaseCost =>
      purchases.fold<double>(0.0, (sum, p) => sum + p.totalCost);

  double get weightedAverageCost {
    final qty = totalPurchasedQuantity;
    if (qty == 0) return 0.0;
    return totalPurchaseCost / qty;
  }

  int get endingQuantity => totalPurchasedQuantity - saleQuantity;

  double get endingInventoryValue =>
      endingQuantity * weightedAverageCost;

  double get revenue => saleQuantity * salePrice;

  double get cogs => saleQuantity * weightedAverageCost;

  double get periodResult => revenue - cogs;

  Map<String, double> computeSummary() {
    return {
      'totalPurchasedQuantity': totalPurchasedQuantity.toDouble(),
      'totalPurchaseCost': totalPurchaseCost,
      'weightedAverageCost': weightedAverageCost,
      'endingQuantity': endingQuantity.toDouble(),
      'endingInventoryValue': endingInventoryValue,
      'revenue': revenue,
      'cogs': cogs,
      'periodResult': periodResult,
    };
  }
}

class ExamQuestion {
  final String id;
  final String subject;
  final String statement;
  final List<String> options;
  final String correctOption;
  final String explanation;
  final int examYear;

  final List<String>? dreTableHeaders;
  final List<List<String>>? dreTableRows;

  final List<String>? tableHeaders;
  final List<List<String>>? tableRows;

  ExamQuestion({
    required this.id,
    required this.subject,
    required this.statement,
    required this.options,
    required this.correctOption,
    required this.explanation,
    required this.examYear,
    this.dreTableHeaders,
    this.dreTableRows,
    this.tableHeaders,
    this.tableRows,
  });

  /// Compatibilidade com telas antigas que usam question.text
  String get text => statement;

  factory ExamQuestion.fromJson(
    Map<String, dynamic> json, {
    required int examYear,
  }) {
    final dreTable = json['dreTable'] as Map<String, dynamic>?;
    final table = json['table'] as Map<String, dynamic>?;

    return ExamQuestion(
      id: json['id'].toString(),
      subject: (json['subject'] as String?) ?? '',
      statement: (json['statement'] as String?) ?? '',
      options: List<String>.from((json['options'] as List?) ?? const []),
      correctOption: (json['correctOption'] as String?) ?? '',
      explanation: (json['explanation'] as String?) ?? '',
      examYear: examYear,
      dreTableHeaders: dreTable?['headers'] != null
          ? List<String>.from(dreTable!['headers'] as List)
          : null,
      dreTableRows: dreTable?['rows'] != null
          ? (dreTable!['rows'] as List)
              .map((row) => List<String>.from(row as List))
              .toList()
          : null,
      tableHeaders:
          table?['headers'] != null ? List<String>.from(table!['headers'] as List) : null,
      tableRows: table?['rows'] != null
          ? (table!['rows'] as List).map((row) => List<String>.from(row as List)).toList()
          : null,
    );
  }
}

class QuestionStats {
  final int wrongCount;
  final int rightCount;
  final DateTime? lastWrongAt;
  final DateTime? lastSeenAt;

  QuestionStats({
    this.wrongCount = 0,
    this.rightCount = 0,
    this.lastWrongAt,
    this.lastSeenAt,
  });
}