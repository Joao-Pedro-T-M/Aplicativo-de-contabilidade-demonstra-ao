// lib/data/trails/nivel3.dart
import '../../../models/course_models.dart';

final Trail balancopatrimonial = Trail(
  id: 'Balançopatrimonial',
  title: 'Balanço Patrimonial',
  description: 'Questões avançadas sobre composição, mensuração e movimentações do Patrimônio Líquido.',
  lessons: [
    Lesson(
      id: 'n3l1',
      title: 'Balanço Patrimonial',
      questions: [
        Question(
    id: 'n1q2',
    text: 'Qual é a equação patrimonial?',
    options: [
      'Ativo = Passivo + Patrimônio Líquido',
      'Ativo = Passivo - Patrimônio Líquido',
      'Ativo + Passivo = Patrimônio Líquido',
      'Patrimônio Líquido = Ativo + Passivo',
    ],
    correctIndex: 0,
    explanation: 'A equação fundamental: Ativo = Passivo + Patrimônio Líquido.',
  ),
  







            // dentro de trails -> nivel2 -> lessons -> questions (adicione um item MatchQuestion) testando
MatchQuestion(
  id: 'n2q_drag_bp1',
  text: 'Arraste cada conta para a seção correta do Balanço Patrimonial.',
  items: [
    'Caixa',
    'Fornecedores',
    'Máquinas',
    'Capital Social',
    'Estoques'
  ],
  targets: [
    MatchTarget(id: 'ac', label: 'Ativo Circulante'),
    MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
    MatchTarget(id: 'pc', label: 'Passivo Circulante'),
    MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
  ],
  correctMap: {
    'Caixa': 'ac',
    'Estoques': 'ac',
    'Fornecedores': 'pc',
    'Máquinas': 'anc',
    'Capital Social': 'pl',
  },
  explanation: 'Caixa/Estoques = Ativo Circulante; Máquinas = Ativo Não Circulante; Fornecedores = Passivo Circulante; Capital Social = Patrimônio Líquido.',
),









// Exemplo (insira na lista de questions do lesson desejado)
MatchQuestion(
  id: 'bp_drag_submit_1',
  text: 'Arraste cada conta para a seção correta do Balanço Patrimonial e pressione ENVIAR para conferir.',
  items: [
    'Caixa',
    'Estoques',
    'Imobilizado (Máquinas)',
    'Fornecedores',
    'Empréstimos LP',
    'Salários a Pagar',
  ],
  targets: [
    MatchTarget(id: 'ac', label: 'Ativo Circulante'),
    MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
    MatchTarget(id: 'pc', label: 'Passivo Circulante'),
    MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
  ],
  correctMap: {
    'Caixa': 'ac',
    'Estoques': 'ac',
    'Imobilizado (Máquinas)': 'anc',
    'Fornecedores': 'pc',
    'Salários a Pagar': 'pc',
    'Empréstimos LP': 'pnc',
  },
  explanation: 'Caixa/Estoques = AC; Imobilizado = ANC; Fornecedores/Salários = PC; Empréstimos LP = PNC.',
),

      ]
    ),
    


  ],
);