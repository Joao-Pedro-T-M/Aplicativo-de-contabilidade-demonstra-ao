import '../../../models/course_models.dart';

final Trail padrao1 = Trail(
  id: 'Padrao1',
  title: 'Índices de liquidez',
  description: 'Indicadores financeiros que medem a capacidade de uma empresa honrar suas obrigações financeiras.',
  lessons: [
    Lesson(
      id: 'n3l2',
      title: 'Índices de Liquidez — conceitos e cálculos',
      questions: [
        Question(
          id: 'n3q11',
          text: 'Qual é a fórmula do índice de liquidez corrente (LC)?',
          options: [
            'Ativo Total / Passivo Total',
            'Ativo Circulante / Passivo Circulante',
            'Ativo Não Circulante / Passivo Circulante',
            'Caixa / Passivo Circulante',
          ],
          correctIndex: 1,
          explanation: 'Liquidez corrente = Ativo Circulante ÷ Passivo Circulante; mede a capacidade de pagamento de curto prazo.',
        ),
        Question(
          id: 'n3q12',
          text: 'O que o índice de liquidez seca (ou rápida) exclui do ativo circulante para sua fórmula?',
          options: [
            'Caixa e equivalentes de caixa',
            'Estoques',
            'Contas a receber',
            'Ativos intangíveis',
          ],
          correctIndex: 1,
          explanation: 'A liquidez seca exclui os estoques porque eles podem demorar mais a ser convertidos em caixa.',
        ),
        Question(
          id: 'n3q13',
          text: 'Qual interpretação é geralmente aplicada quando a liquidez corrente de uma empresa é menor que 1?',
          options: [
            'A empresa tem mais ativos do que passivos e é muito líquida',
            'A empresa pode não ter recursos suficientes para pagar obrigações de curto prazo',
            'A empresa tem superávit de caixa',
            'Significa que a empresa é isenta de dívidas',
          ],
          correctIndex: 1,
          explanation: 'LC < 1 indica que o ativo circulante é insuficiente para cobrir o passivo circulante, apontando risco de liquidez no curto prazo.',
        ),
        Question(
          id: 'n3q14',
          text: 'O índice de liquidez imediata (caixa) mede:',
          options: [
            'A proporção entre caixa e passivo circulante',
            'O total do ativo sobre o patrimônio líquido',
            'A relação entre estoques e patrimônio',
            'A eficiência operacional da empresa',
          ],
          correctIndex: 0,
          explanation: 'Liquidez imediata = Caixa e equivalentes ÷ Passivo Circulante; indica quanto do passivo pode ser pago imediatamente.',
        ),
        Question(
          id: 'n3q15',
          text: 'Como o aumento expressivo de estoques tende a afetar a liquidez seca, mantendo todo o resto constante?',
          options: [
            'Aumenta a liquidez seca',
            'Não altera a liquidez seca',
            'Reduz a liquidez seca',
            'Transforma a liquidez seca em liquidez imediata',
          ],
          correctIndex: 2,
          explanation: 'Como a liquidez seca exclui estoques, um aumento de estoques reduz a proporção entre ativos líquidos (exceto estoques) e passivos, piorando a liquidez seca relativa.',
        ),
        Question(
          id: 'n3q16',
          text: 'Qual é o objetivo principal dos índices de liquidez?',
          options: [
            'Avaliar a rentabilidade da empresa no longo prazo',
            'Medir a capacidade de a empresa saldar obrigações de curto prazo',
            'Determinar o valor de mercado das ações',
            'Calcular o imposto devido ao fisco',
          ],
          correctIndex: 1,
          explanation: 'Os índices de liquidez avaliam se a empresa tem recursos suficientes para cumprir obrigações financeiras, especialmente de curto prazo.',
        ),
        Question(
          id: 'n3q17',
          text: 'Se uma empresa tem Ativo Circulante = RS 150.000 e Passivo Circulante = RS 100.000, qual é a liquidez corrente?',
          options: [
            '0,67',
            '1,5',
            '2,0',
            '0,33',
          ],
          correctIndex: 1,
          explanation: 'LC = 150.000 ÷ 100.000 = 1,5.',
        ),
        Question(
          id: 'n3q18',
          text: 'Por que é importante analisar índices de liquidez em conjunto com outros indicadores (endividamento, rentabilidade)?',
          options: [
            'Porque liquidez sozinha não mostra a sustentabilidade financeira nem a capacidade de geração de lucro',
            'Porque índices diferentes sempre dão o mesmo diagnóstico',
            'Porque os auditores exigem pelo menos três índices',
            'Porque a contabilidade não registra estoques',
          ],
          correctIndex: 0,
          explanation: 'A análise integrada dá visão mais completa: uma empresa pode ser líquida mas não rentável, ou menos endividada mas com problemas operacionais.',
        ),
        Question(
          id: 'n3q19',
          text: 'Qual dos seguintes itens é considerado no numerador da liquidez seca?',
          options: [
            'Caixa + Contas a receber + Estoques',
            'Caixa + Contas a receber',
            'Ativo Imobilizado',
            'Passivo Não Circulante',
          ],
          correctIndex: 1,
          explanation: 'Liquidez seca normalmente considera Caixa e equivalentes + Contas a receber (ou disponíveis de curto prazo), excluindo estoques.',
        ),
        Question(
          id: 'n3q20',
          text: 'Uma empresa com liquidez corrente muito alta (por exemplo, 4,0) pode indicar:',
          options: [
            'Situação perfeitamente saudável e sem ressalvas',
            'Possível excesso de recursos ociosos que poderiam ser investidos',
            'Que a empresa não possui ativos circulantes',
            'Que a empresa não possui passivo',
          ],
          correctIndex: 1,
          explanation: 'LC muito alta pode significar excesso de ativos circulantes não produtivos (caixa parado ou estoques elevados), indicando uso ineficiente de recursos.',
        ),
      ],
    ),
  ],
);
