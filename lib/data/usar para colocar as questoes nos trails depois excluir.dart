import '../models/course_models.dart';

final sampleCourse = Course(
  id: 'c1',
  title: 'Contabilidade Geral 1',
  // descrição removida conforme pedido (string curta para manter compatibilidade)
  description: '',
  
  trails: [
    
    // Nível 1 - Básico (5 questões)
    Trail(
      id: 'nivel1',
      title: 'Nível 1 - Básico',
      description: '5 questões para fixação de conceitos fundamentais.',
      lessons: [
        Lesson(
          id: 'n1l1',
          title: 'Prova - Nível 1',
          questions: [



  // Unidade 1 — Patrimônio
  Question(
    id: 'n1q1',
    text: 'O que é Patrimônio na contabilidade?',
    options: [
      'Apenas os bens de uma empresa',
      'Conjunto de bens, direitos e obrigações',
      'Apenas o dinheiro em caixa',
      'Somente os imóveis da empresa',
    ],
    correctIndex: 1,
    explanation: 'Patrimônio é o conjunto de bens, direitos e obrigações de uma entidade.',
  ),
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
  Question(
    id: 'n1q3',
    text: 'O que são BENS na contabilidade?',
    options: [
      'Valores a receber de terceiros',
      'Dívidas com fornecedores',
      'Tudo que a empresa possui e que pode ser avaliado em dinheiro',
      'Capital investido pelos sócios',
    ],
    correctIndex: 2,
    explanation: 'Bens são elementos que possuem valor econômico e pertencem à entidade.',
  ),
  Question(
    id: 'n1q4',
    text: 'Um veículo da empresa é classificado como:',
    options: [
      'Direito',
      'Obrigação',
      'Bem móvel',
      'Patrimônio líquido',
    ],
    correctIndex: 2,
    explanation: 'Veículos são bens móveis, pois podem ser deslocados.',
  ),
  Question(
    id: 'n1q5',
    text: 'Duplicatas a receber são classificadas como:',
    options: [
      'Bens',
      'Direitos',
      'Obrigações',
      'Receitas',
    ],
    correctIndex: 1,
    explanation: 'Duplicatas a receber representam direitos da empresa perante terceiros.',
  ),

  // Unidade 1 — Ativo e Passivo
  Question(
    id: 'n2q1',
    text: 'O Ativo representa:',
    options: [
      'As dívidas da empresa',
      'Os bens e direitos da empresa',
      'O lucro do período',
      'As despesas operacionais',
    ],
    correctIndex: 1,
    explanation: 'O Ativo compreende os bens e direitos da entidade.',
  ),
  Question(
    id: 'n2q2',
    text: 'O Passivo representa:',
    options: [
      'Os bens da empresa',
      'Os direitos da empresa',
      'As obrigações da empresa',
      'O capital social',
    ],
    correctIndex: 2,
    explanation: 'O Passivo representa as obrigações (dívidas) da empresa com terceiros.',
  ),
  Question(
    id: 'n2q3',
    text: 'Ativo Circulante inclui bens e direitos realizáveis em até:',
    options: [
      '30 dias',
      '6 meses',
      '12 meses (exercício seguinte)',
      '24 meses',
    ],
    correctIndex: 2,
    explanation: 'Ativo Circulante são os itens realizáveis até o final do exercício seguinte.',
  ),
  Question(
    id: 'n2q4',
    text: 'Caixa e Bancos são classificados no:',
    options: [
      'Passivo Circulante',
      'Ativo Não Circulante',
      'Patrimônio Líquido',
      'Ativo Circulante',
    ],
    correctIndex: 3,
    explanation: 'Disponibilidades como Caixa e Bancos pertencem ao Ativo Circulante.',
  ),
  Question(
    id: 'n2q5',
    text: 'Empréstimos bancários a pagar são:',
    options: [
      'Ativo Circulante',
      'Passivo Circulante ou Não Circulante',
      'Patrimônio Líquido',
      'Receita financeira',
    ],
    correctIndex: 1,
    explanation: 'Empréstimos a pagar são obrigações e ficam no Passivo.',
  ),

  // Unidade 2 — Débito e Crédito
  Question(
    id: 'n3q1',
    text: 'No método das partidas dobradas:',
    options: [
      'Para cada débito há um crédito de igual valor',
      'Débitos são sempre maiores que créditos',
      'Só se registra o débito',
      'Créditos são opcionais',
    ],
    correctIndex: 0,
    explanation: 'Partidas dobradas: todo débito tem um crédito correspondente de mesmo valor.',
  ),
  Question(
    id: 'n3q2',
    text: 'Débito significa:',
    options: [
      'Sempre algo ruim',
      'Aplicação de recursos (destino)',
      'Apenas saída de dinheiro',
      'Lucro da empresa',
    ],
    correctIndex: 1,
    explanation: 'Débito representa a aplicação de recursos, o destino do valor.',
  ),
  Question(
    id: 'n3q3',
    text: 'Quando uma conta de Ativo aumenta, ela é:',
    options: [
      'Creditada',
      'Debitada',
      'Encerrada',
      'Transferida',
    ],
    correctIndex: 1,
    explanation: 'Contas de Ativo aumentam pelo débito e diminuem pelo crédito.',
  ),
  Question(
    id: 'n3q4',
    text: 'Quando uma conta de Passivo aumenta, ela é:',
    options: [
      'Debitada',
      'Creditada',
      'Anulada',
      'Estornada',
    ],
    correctIndex: 1,
    explanation: 'Contas de Passivo aumentam pelo crédito e diminuem pelo débito.',
  ),
  Question(
    id: 'n3q5',
    text: 'Compra de mercadorias à vista. Qual o lançamento?',
    options: [
      'D - Caixa / C - Mercadorias',
      'D - Mercadorias / C - Caixa',
      'D - Fornecedores / C - Mercadorias',
      'D - Mercadorias / C - Fornecedores',
    ],
    correctIndex: 1,
    explanation: 'Debita Mercadorias (ativo aumenta) e Credita Caixa (ativo diminui).',
  ),

  // Unidade 2 — Balanço Patrimonial
  Question(
    id: 'n4q1',
    text: 'O Balanço Patrimonial apresenta:',
    options: [
      'Receitas e despesas do período',
      'A situação patrimonial e financeira em determinada data',
      'Apenas o fluxo de caixa',
      'Somente as dívidas da empresa',
    ],
    correctIndex: 1,
    explanation: 'O BP mostra a posição patrimonial e financeira em uma data específica.',
  ),
  Question(
    id: 'n4q2',
    text: 'O lado esquerdo do Balanço Patrimonial apresenta:',
    options: [
      'Passivo',
      'Patrimônio Líquido',
      'Ativo',
      'Receitas',
    ],
    correctIndex: 2,
    explanation: 'Convenção: Ativo fica do lado esquerdo do Balanço Patrimonial.',
  ),
  Question(
    id: 'n4q3',
    text: 'Qual grupo NÃO faz parte do Balanço Patrimonial?',
    options: [
      'Ativo Circulante',
      'Despesas Operacionais',
      'Passivo Não Circulante',
      'Patrimônio Líquido',
    ],
    correctIndex: 1,
    explanation: 'Despesas Operacionais pertencem à DRE, não ao Balanço.',
  ),
  Question(
    id: 'n4q4',
    text: 'O Patrimônio Líquido fica no lado:',
    options: [
      'Esquerdo, junto ao Ativo',
      'Direito, junto ao Passivo',
      'Em demonstração separada',
      'Não aparece no Balanço',
    ],
    correctIndex: 1,
    explanation: 'PL fica do lado direito, junto com o Passivo.',
  ),
  Question(
    id: 'n4q5',
    text: 'Se Ativo = R\$100.000 e Passivo = R\$60.000, o PL é:',
    options: [
      'R\$160.000',
      'R\$60.000',
      'R\$40.000',
      'R\$100.000',
    ],
    correctIndex: 2,
    explanation: 'PL = Ativo - Passivo = 100.000 - 60.000 = R\$40.000.',
  ),

  // Unidade 3 — DRE
  Question(
    id: 'n5q1',
    text: 'A DRE demonstra:',
    options: [
      'A posição patrimonial da empresa',
      'O resultado (lucro ou prejuízo) do período',
      'O fluxo de caixa',
      'Apenas as receitas',
    ],
    correctIndex: 1,
    explanation: 'A DRE apura o resultado econômico (lucro ou prejuízo) do exercício.',
  ),
  Question(
    id: 'n5q2',
    text: 'Receita Bruta menos Deduções resulta em:',
    options: [
      'Lucro Bruto',
      'Receita Líquida',
      'Lucro Operacional',
      'EBITDA',
    ],
    correctIndex: 1,
    explanation: 'Receita Bruta - Deduções (impostos, devoluções) = Receita Líquida.',
  ),
  Question(
    id: 'n5q3',
    text: 'CMV significa:',
    options: [
      'Custo Mensal Variável',
      'Custo das Mercadorias Vendidas',
      'Controle de Mercadorias e Vendas',
      'Capital Mínimo de Vendas',
    ],
    correctIndex: 1,
    explanation: 'CMV = Custo das Mercadorias Vendidas.',
  ),
  Question(
    id: 'n5q4',
    text: 'Receita Líquida - CMV =',
    options: [
      'Lucro Líquido',
      'EBITDA',
      'Lucro Bruto',
      'Receita Bruta',
    ],
    correctIndex: 2,
    explanation: 'Receita Líquida menos o CMV resulta no Lucro Bruto.',
  ),
  Question(
    id: 'n5q5',
    text: 'Despesas administrativas e de vendas são deduzidas do:',
    options: [
      'Ativo',
      'Lucro Bruto',
      'Patrimônio Líquido',
      'Passivo Circulante',
    ],
    correctIndex: 1,
    explanation: 'Despesas operacionais são subtraídas do Lucro Bruto na DRE.',
  ),

  // Unidade 3 — Princípios Contábeis
  Question(
    id: 'n6q1',
    text: 'O Princípio da Entidade determina que:',
    options: [
      'O patrimônio da empresa se confunde com o dos sócios',
      'O patrimônio da empresa não se confunde com o dos sócios',
      'A empresa deve ter lucro',
      'Todos os registros devem ser em dólar',
    ],
    correctIndex: 1,
    explanation: 'O patrimônio da entidade não se mistura com o dos sócios/proprietários.',
  ),
  Question(
    id: 'n6q2',
    text: 'O Princípio da Continuidade pressupõe que:',
    options: [
      'A empresa vai encerrar em breve',
      'A empresa continuará operando por tempo indeterminado',
      'Só se aplica a empresas novas',
      'Não existe mais na contabilidade',
    ],
    correctIndex: 1,
    explanation: 'Pressupõe que a entidade continuará operando indefinidamente.',
  ),
  Question(
    id: 'n6q3',
    text: 'O regime de competência reconhece receitas e despesas:',
    options: [
      'Quando o dinheiro entra ou sai',
      'No momento do fato gerador, independente do pagamento',
      'Apenas no final do ano',
      'Somente quando há lucro',
    ],
    correctIndex: 1,
    explanation: 'Regime de competência: reconhece no fato gerador, não no pagamento.',
  ),
  Question(
    id: 'n6q4',
    text: 'O regime de caixa reconhece receitas e despesas:',
    options: [
      'No fato gerador',
      'Na data da nota fiscal',
      'Quando efetivamente recebidas ou pagas',
      'Mensalmente',
    ],
    correctIndex: 2,
    explanation: 'Regime de caixa: reconhece quando o dinheiro efetivamente entra ou sai.',
  ),
  Question(
    id: 'n6q5',
    text: 'O Princípio do Registro pelo Valor Original determina que:',
    options: [
      'Ativos devem ser registrados pelo valor de mercado',
      'Ativos devem ser registrados pelo valor original da transação',
      'Ativos não precisam de registro',
      'O valor depende do contador',
    ],
    correctIndex: 1,
    explanation: 'Registrar pelo valor original da transação que deu origem ao componente patrimonial.',
  ),




















MatchSumQuestion(
  id: 'n1_sum_bp1',
  text: 'Arraste cada conta para a seção correta do Balanço e veja as somas. Exemplo: AC + ANC (Investimentos, Imobilizado, Intangível) / PC + PL.',
  items: [
    MatchSumItem(id: 'it_caixa', label: 'Caixa', value: 12000.0),
    MatchSumItem(id: 'it_estoques', label: 'Estoques', value: 8000.0),
    MatchSumItem(id: 'it_invest', label: 'Participações Societárias', value: 15000.0),
    MatchSumItem(id: 'it_imobilizado', label: 'Terreno', value: 25000.0),
    MatchSumItem(id: 'it_intangivel', label: 'Marca', value: 20000.0),
    MatchSumItem(id: 'it_fornecedores', label: 'Fornecedores', value: 30000.0),
    MatchSumItem(id: 'it_capital', label: 'Capital Social', value: 50000.0),
  ],
  targets: [
    MatchTarget(id: 'ac', label: 'Ativo Circulante (AC)'),
    MatchTarget(
      id: 'anc',
      label: 'Ativo Não Circulante (ANC)',
      subs: [
        MatchTarget(id: 'anc_invest', label: 'Investimentos'),
        MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
        MatchTarget(id: 'anc_int', label: 'Intangível'),
      ],
    ),
    MatchTarget(id: 'pc', label: 'Passivo Circulante (PC)'),
    MatchTarget(id: 'pnc', label: 'Passivo Não Circulante (PNC)'),
    MatchTarget(id: 'pl', label: 'Patrimônio Líquido (PL)'),
  ],
  correctMap: {
    'it_caixa': 'ac',
    'it_estoques': 'ac',
    'it_invest': 'anc_invest',
    'it_imobilizado': 'anc_imob',
    'it_intangivel': 'anc_int',
    'it_fornecedores': 'pc',
    'it_capital': 'pl',
  },
  // Expected: você pode declarar metas por sub ou por pai (ou ambos).
  expectedTargetTotals: {
    'ac': 20000.0,
    'anc_invest': 15000.0,
    'anc_imob': 25000.0,
    'anc_int': 20000.0,
    // opcional: total do anc — widget vai calcular a soma dos subs e comparar
    'anc': 60000.0,
    'pc': 30000.0,
    'pl': 50000.0,
  },
  explanation: 
'Caixa e Estoques pertencem ao Ativo Circulante. '
'Participações Societárias ficam em Investimentos no Ativo Não Circulante. '
'Terreno pertence ao Imobilizado e Marca ao Intangível. '
'Fornecedores são Passivo Circulante e Capital Social compõe o Patrimônio Líquido. '
'Somando: AC = 20.000, ANC = 60.000, total do Ativo = 80.000. '
'PC = 30.000 e PL = 50.000, totalizando 80.000, mantendo o equilíbrio do Balanço Patrimonial.',
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






            Question(
              id: 'n1q2',
              text:
                  'Em partida dobrada, toda operação deve:',
              options: [
                'Ter uma conta afetada',
                'Ter pelo menos um débito e um crédito de valores iguais',
                'Ter apenas créditos',
                'Ser registrada só no razão'
              ],
              correctIndex: 1,
              explanation:
                  'A partida dobrada exige débitos e créditos iguais para manter o equilíbrio patrimonial.',
            ),
            Question(
              id: 'n1q3',
              text:
                  'Qual das contas abaixo é tipicamente classificada como passivo circulante?',
              options: ['Caixa', 'Contas a Receber', 'Fornecedores', 'Receitas'],
              correctIndex: 2,
              explanation: 'Fornecedores representam obrigação de pagamento no curto prazo — passivo circulante.',
            ),
            Question(
              id: 'n1q4',
              text:
                  'O que aumenta o saldo da conta "Receita de Vendas" no regime de competência?',
              options: [
                'Emissão de nota fiscal de venda a prazo',
                'Recebimento em dinheiro de venda anterior',
                'Depreciação acumulada',
                'Pagamento de fornecedores'
              ],
              correctIndex: 0,
              explanation:
                  'No regime de competência, a receita é reconhecida quando ocorre a venda, independentemente do recebimento.',
            ),
            Question(
              id: 'n1q5',
              text:
                  'Em qual razão a conta "Despesas Antecipadas" é registrada inicialmente?',
              options: ['Ativo', 'Passivo', 'Resultado', 'Patrimônio Líquido'],
              correctIndex: 0,
              explanation: 'Despesas antecipadas representam pagamentos que geram benefícios futuros — classificadas como ativo.',
            ),
          ],
        )
      ],
    ),

    // Nível 2 - Intermediário (5 questões)
    Trail(
      id: 'nivel2',
      title: 'Nível 2 - Intermediário',
      description: 'Questões intermediárias sobre ajustes e controles.',
      lessons: [
        Lesson(
          id: 'n2l1',
          title: 'Prova - Nível 2',
          questions: [
            Question(
              id: 'n2q1',
              text:
                  'Qual é o lançamento típico para registrar a depreciação mensal de um equipamento?',
              options: [
                'Débito em Despesa de Depreciação / Crédito em Depreciação Acumulada',
                'Débito em Depreciação Acumulada / Crédito em Caixa',
                'Débito em Equipamento / Crédito em Receita',
                'Débito em Caixa / Crédito em Equipamento'
              ],
              correctIndex: 0,
              explanation:
                  'A depreciação reconhece despesa (débito) e aumenta a conta retificadora do ativo (crédito em depreciação acumulada).',
            ),
            Question(
              id: 'n2q2',
              text:
                  'Em ajuste de provisão para perdas em contas a receber, qual é o efeito no resultado e no ativo?',
              options: [
                'Aumenta resultado e aumenta ativo',
                'Reduz resultado e reduz ativo líquido',
                'Não altera resultado e aumenta passivo',
                'Aumenta patrimônio líquido'
              ],
              correctIndex: 1,
              explanation:
                  'Provisionar perdas aumenta despesa (reduz resultado) e reduz o valor líquido do ativo contas a receber.',
            ),
            Question(
              id: 'n2q3',
              text:
                  'Uma compra de mercadorias a prazo afeta quais contas?',
              options: [
                'Débito em Estoques / Crédito em Fornecedores',
                'Débito em Caixa / Crédito em Estoques',
                'Débito em Fornecedores / Crédito em Caixa',
                'Débito em Receita / Crédito em Estoques'
              ],
              correctIndex: 0,
              explanation:
                  'Ao comprar mercadorias a prazo: aumenta o estoque (débito) e surge uma obrigação com fornecedores (crédito).',
            ),
            Question(
              id: 'n2q4',
              text:
                  'No método do custo, como é registrado o estoque de compras?',
              options: [
                'Como despesa no momento da compra',
                'Como ativo até a venda, quando passa para custo das mercadorias vendidas',
                'Como patrimônio líquido',
                'Como receita antecipada'
              ],
              correctIndex: 1,
              explanation:
                  'No método do custo (ou CMV), as compras entram como ativo (estoque) e só são reconhecidas no resultado quando vendidas.',
            ),
            Question(
              id: 'n2q5',
              text:
                  'Qual é o objetivo principal dos lançamentos de estorno no diário?',
              options: [
                'Aumentar receita',
                'Corrigir lançamentos errados mantendo histórico',
                'Evitar conciliação bancária',
                'Criar provisões'
              ],
              correctIndex: 1,
              explanation:
                  'Estornos corrigem erros reversando o lançamento original e aplicando o correto, preservando rastreabilidade.',
            ),
          ],
        )
      ],
    ),

    // Nível 3 - Avançado (5 questões)
    Trail(
      id: 'nivel3',
      title: 'Nível 3 - Avançado',
      description: 'Questões avançadas para análise e demonstrações contábeis.',
      lessons: [
        Lesson(
          id: 'n3l1',
          title: 'Prova - Nível 3',
          questions: [
            Question(
              id: 'n3q1',
              text:
                  'Ao emitir uma debênture convertível que será convertida futuramente em ações, como classifica-se inicialmente?',
              options: [
                'Como receita',
                'Como passivo (dívida) até a conversão',
                'Como reserva de capital',
                'Como despesa operacional'
              ],
              correctIndex: 1,
              explanation:
                  'Instrumentos conversíveis são inicialmente classificados como passivo (obrigação) até ocorrer a conversão, salvo componente patrimonial identificado. ',
            ),
            Question(
              id: 'n3q2',
              text:
                  'Como a participação nos lucros de empregados, registrada como despesa, afeta as demonstrações?',
              options: [
                'Reduz o lucro do exercício e reduz o caixa quando paga',
                'Aumenta o lucro do exercício',
                'Não tem efeito no patrimônio',
                'É reconhecida diretamente em reservas'
              ],
              correctIndex: 0,
              explanation:
                  'Participação nos lucros é despesa (reduz lucro) e gera obrigação de pagamento; no pagamento reduz o caixa.',
            ),
            Question(
              id: 'n3q3',
              text:
                  'O que representa a razão corrente (current ratio) e um nível baixo indica:',
              options: [
                'Liquidez imediata; nível baixo indica alta liquidez',
                'Capacidade de pagar obrigações de curto prazo; nível baixo indica risco de liquidez',
                'Rentabilidade do patrimônio; nível baixo indica lucro alto',
                'Estrutura de capital; nível baixo indica alto patrimônio líquido'
              ],
              correctIndex: 1,
              explanation:
                  'Current ratio = Ativo Circulante / Passivo Circulante. Valor baixo sinaliza possível dificuldade de pagamento de curto prazo.',
            ),
            Question(
              id: 'n3q4',
              text:
                  'Quando uma empresa reconhece receita de um serviço prestado por etapas (percentage of completion)?',
              options: [
                'Somente na entrega final',
                'Proporcional ao progresso (reconhecimento periódico conforme etapa)',
                'Ao receber o pagamento inicial apenas',
                'Nunca reconhece receita'
              ],
              correctIndex: 1,
              explanation:
                  'Método percentage of completion reconhece receita conforme o progresso da obra/serviço, refletindo desempenho.',
            ),
            Question(
              id: 'n3q5',
              text:
                  'Na demonstração do fluxo de caixa, como é classificado o pagamento de juros em regra geral (IFRS permite opções)?',
              options: [
                'Sempre como fluxo de investimento',
                'Como atividade operacional ou de financiamento, conforme política contábil',
                'Como aumento de ativo',
                'Como lucro retido'
              ],
              correctIndex: 1,
              explanation:
                  'Pagamento de juros pode ser apresentado em atividades operacionais ou de financiamento, dependendo da política adotada e normas aplicáveis.',
            ),
          ],
        )
        
      ],
    ),
    







    // Nível 4 - Avançado (5 questões)
    Trail(
      id: 'nivel4',
      title: 'Nível 4 Separado',
      description: 'Questões avançadas para análise e demonstrações contábeis.',
      lessons: [
        Lesson(
          id: 'n3l1',
          title: 'Prova - Nível 3',
          questions: [
            Question(
              id: 'n3q1',
              text:
                  'Ao emitir uma debênture convertível que será convertida futuramente em ações, como classifica-se inicialmente?',
              options: [
                'Como receita',
                'Como passivo (dívida) até a conversão',
                'Como reserva de capital',
                'Como despesa operacional'
              ],
              correctIndex: 1,
              explanation:
                  'Instrumentos conversíveis são inicialmente classificados como passivo (obrigação) até ocorrer a conversão, salvo componente patrimonial identificado. ',
            ),
            Question(
              id: 'n3q2',
              text:
                  'Como a participação nos lucros de empregados, registrada como despesa, afeta as demonstrações?',
              options: [
                'Reduz o lucro do exercício e reduz o caixa quando paga',
                'Aumenta o lucro do exercício',
                'Não tem efeito no patrimônio',
                'É reconhecida diretamente em reservas'
              ],
              correctIndex: 0,
              explanation:
                  'Participação nos lucros é despesa (reduz lucro) e gera obrigação de pagamento; no pagamento reduz o caixa.',
            ),
            Question(
              id: 'n3q3',
              text:
                  'O que representa a razão corrente (current ratio) e um nível baixo indica:',
              options: [
                'Liquidez imediata; nível baixo indica alta liquidez',
                'Capacidade de pagar obrigações de curto prazo; nível baixo indica risco de liquidez',
                'Rentabilidade do patrimônio; nível baixo indica lucro alto',
                'Estrutura de capital; nível baixo indica alto patrimônio líquido'
              ],
              correctIndex: 1,
              explanation:
                  'Current ratio = Ativo Circulante / Passivo Circulante. Valor baixo sinaliza possível dificuldade de pagamento de curto prazo.',
            ),
            Question(
              id: 'n3q4',
              text:
                  'Quando uma empresa reconhece receita de um serviço prestado por etapas (percentage of completion)?',
              options: [
                'Somente na entrega final',
                'Proporcional ao progresso (reconhecimento periódico conforme etapa)',
                'Ao receber o pagamento inicial apenas',
                'Nunca reconhece receita'
              ],
              correctIndex: 1,
              explanation:
                  'Método percentage of completion reconhece receita conforme o progresso da obra/serviço, refletindo desempenho.',
            ),
            Question(
              id: 'n3q5',
              text:
                  'Na demonstração do fluxo de caixa, como é classificado o pagamento de juros em regra geral (IFRS permite opções)?',
              options: [
                'Sempre como fluxo de investimento',
                'Como atividade operacional ou de financiamento, conforme política contábil',
                'Como aumento de ativo',
                'Como lucro retido'
              ],
              correctIndex: 1,
              explanation:
                  'Pagamento de juros pode ser apresentado em atividades operacionais ou de financiamento, dependendo da política adotada e normas aplicáveis.',
            ),
          ],
        )
        
      ],
    ),
    
  ],
);
