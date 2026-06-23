import '../../../models/course_models.dart';

final Trail padrao = Trail(
  id: 'Padrao',
  title: 'Introdução às demonstrações contábeis',
  description: 'As demonstrações contábeis são relatórios técnicos obrigatórios que oferecem um "retrato" da saúde financeira, econômica e patrimonial de uma empresa em determinado período.',
  lessons: [
    Lesson(
      id: 'n3l1',
      title: 'Conceitos básicos e usuários',
      questions: [
        Question(
          id: 'n3q1',
          text: 'Qual a diferença fundamental entre uma associação e uma sociedade, segundo o Código Civil brasileiro?',
          options: [
            'Associação presta serviços ao governo; sociedade não.',
            'Associação não possui fins econômicos; sociedade tem finalidade econômica.',
            'Associação tem capital dividido em ações; sociedade não.',
            'Associação é sempre uma pessoa física; sociedade é pessoa jurídica.',
          ],
          correctIndex: 1,
          explanation: 'Associações são pessoas jurídicas sem fins econômicos; sociedades têm finalidade econômica.',
        ),
        Question(
          id: 'n3q2',
          text: 'Quais siglas identificam, respectivamente, uma sociedade anônima e uma limitada?',
          options: [
            'S.A. e Ltda.',
            'S.A. e EIRELI',
            'MEI e Ltda.',
            'EIRELI e S.A.',
          ],
          correctIndex: 0,
          explanation: 'Sociedade anônima costuma usar S.A. (ou Cia.); sociedade limitada usa Ltda.',
        ),
        Question(
          id: 'n3q3',
          text: 'O que caracteriza uma companhia de capital aberto em relação à de capital fechado?',
          options: [
            'Aberta tem sócios; fechada não tem sócios.',
            'Aberta negocia ações em bolsa; fechada não negocia em bolsa.',
            'Aberta é obrigada a distribuir lucro; fechada não é.',
            'Aberta é sempre maior que a fechada.',
          ],
          correctIndex: 2,
          explanation: 'Companhias de capital aberto possuem ações negociadas em bolsa; as fechadas não. (Permite investimento público.)',
        ),
        Question(
          id: 'n3q4',
          text: 'Qual das opções é uma forma adequada para uma empresa muito pequena com apenas um sócio?',
          options: [
            'Sociedade Anônima (S.A.)',
            'Empresa Individual de Responsabilidade Limitada (EIRELI)',
            'Associação sem fins econômicos',
            'CNPJ de terceiro',
          ],
          correctIndex: 1,
          explanation: 'EIRELI e empresário individual são formas utilizadas por quem tem apenas um sócio (ou é pessoa única) e deseja limitar responsabilidade.',
        ),
        Question(
          id: 'n3q5',
          text: 'Quem são considerados usuários internos da informação contábil?',
          options: [
            'Gerentes, diretores e empregados',
            'Investidores e fornecedores',
            'Agência reguladora e fisco',
            'Clientes e público em geral',
          ],
          correctIndex: 0,
          explanation: 'Usuários internos são aqueles que trabalham na entidade, como gerentes, diretores e empregados, que usam a contabilidade para decisões gerenciais.',
        ),
        Question(
          id: 'n3q6',
          text: 'Qual usuário externo está mais interessado na arrecadação de tributos e influencia fortemente a contabilidade?',
          options: [
            'Investidores',
            'Fornecedores',
            'Autoridade fiscal (fisco)',
            'Clientes',
          ],
          correctIndex: 2,
          explanation: 'A autoridade fiscal (fisco) utiliza a informação contábil para arrecadação de tributos e influencia práticas contábeis.',
        ),
        Question(
          id: 'n3q7',
          text: 'Em contabilidade, quais são os três grandes grupos de atividades de uma entidade?',
          options: [
            'Produção, vendas e logística',
            'Financiamento, investimento e operações',
            'Ativos, passivos e patrimônio líquido',
            'Receita, despesa e lucro',
          ],
          correctIndex: 1,
          explanation: 'As atividades são classificadas em financiamento (captação de recursos), investimento (compra de ativos) e operações (geração de receita).',
        ),
        Question(
          id: 'n3q8',
          text: 'O que, em termos contábeis, representa o Patrimônio Líquido?',
          options: [
            'Os recursos provenientes de empréstimos bancários',
            'Os recursos aportados pelos acionistas e resultados retidos na empresa',
            'As obrigações com fornecedores e empregados',
            'O total de receitas do período',
          ],
          correctIndex: 1,
          explanation: 'Patrimônio líquido é composto pelos recursos dos acionistas (capital) e pelos lucros retidos na entidade.',
        ),
        Question(
          id: 'n3q9',
          text: 'Como se define, de forma simples, a receita e a despesa?',
          options: [
            'Receita é entrada de caixa; despesa é obrigação de pagar impostos',
            'Receita é o aumento de ativos pela venda/serviço; despesa é o consumo de recursos para gerar essa receita',
            'Receita é sinônimo de lucro; despesa é sinônimo de passivo',
            'Receita é dívida de clientes; despesa é dívida da empresa',
          ],
          correctIndex: 1,
          explanation: 'Receita surge da venda de bens/serviços (aumenta ativos); despesa representa os insumos consumidos na geração da receita.',
        ),
        Question(
          id: 'n3q10',
          text: 'Por que a ética é destacada como importante na preparação das informações contábeis?',
          options: [
            'Porque a legislação proíbe a divulgação de informações financeiras',
            'Porque a contabilidade deve ser transparente e o profissional precisa escolher critérios que representem fielmente os eventos',
            'Porque contadores não podem opinar sobre decisões gerenciais',
            'Porque a ética define a forma de apuração dos impostos',
          ],
          correctIndex: 1,
          explanation: 'A ética garante transparência e que o profissional escolha critérios contábeis que representem a realidade de forma fidedigna.',
        ),
      ],
    ),
  ],
);
