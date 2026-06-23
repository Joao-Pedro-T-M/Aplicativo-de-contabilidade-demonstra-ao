class CfcQuestionHistory {
  final String questionId;
  final int wrongCount;
  final int rightCount;
  final DateTime? lastWrongAt;
  final DateTime? lastSeenAt;

  const CfcQuestionHistory({
    required this.questionId,
    this.wrongCount = 0,
    this.rightCount = 0,
    this.lastWrongAt,
    this.lastSeenAt,
  });

  factory CfcQuestionHistory.fromJson(Map<String, dynamic> json) {
    return CfcQuestionHistory(
      questionId: json['questionId'] as String,
      wrongCount: (json['wrongCount'] as num?)?.toInt() ?? 0,
      rightCount: (json['rightCount'] as num?)?.toInt() ?? 0,
      lastWrongAt: json['lastWrongAt'] != null
          ? DateTime.parse(json['lastWrongAt'] as String)
          : null,
      lastSeenAt: json['lastSeenAt'] != null
          ? DateTime.parse(json['lastSeenAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'wrongCount': wrongCount,
        'rightCount': rightCount,
        'lastWrongAt': lastWrongAt?.toIso8601String(),
        'lastSeenAt': lastSeenAt?.toIso8601String(),
      };

  CfcQuestionHistory copyWith({
    int? wrongCount,
    int? rightCount,
    DateTime? lastWrongAt,
    DateTime? lastSeenAt,
  }) {
    return CfcQuestionHistory(
      questionId: questionId,
      wrongCount: wrongCount ?? this.wrongCount,
      rightCount: rightCount ?? this.rightCount,
      lastWrongAt: lastWrongAt ?? this.lastWrongAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}