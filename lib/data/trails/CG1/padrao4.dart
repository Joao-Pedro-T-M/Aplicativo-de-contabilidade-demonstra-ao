import '../../../models/course_models.dart';

final Trail padrao4 = Trail(
  id: 'padrao4',
  title: 'Balanço Patrimonial — Classificação de Contas',
  description: 'Exercícios práticos: a partir da Demonstração do Resultado (receitas e despesas) calcule o valor destinado às reservas (80% do lucro, quando houver lucro). Preencha o resultado sem cifrão, sem centavos, sem pontos e sem vírgulas.',
  lessons: [
    Lesson(
      id: 'n2l_drag_bp',
      title: 'Classificação de contas',
      questions: [

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

        MatchQuestion(
          id: 'n2q_drag_bp2',
          text: 'Classifique as contas abaixo no Balanço Patrimonial.',
          items: [
            'Bancos',
            'Empréstimos a Pagar',
            'Veículos',
            'Lucros Acumulados',
            'Clientes'
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'Bancos': 'ac',
            'Clientes': 'ac',
            'Empréstimos a Pagar': 'pc',
            'Veículos': 'anc',
            'Lucros Acumulados': 'pl',
          },
          explanation: 'Bancos e Clientes = Ativo Circulante; Veículos = Ativo Não Circulante; Empréstimos = Passivo Circulante; Lucros Acumulados = Patrimônio Líquido.',
        ),

        MatchQuestion(
          id: 'n2q_drag_bp3',
          text: 'Associe cada conta à sua classificação correta.',
          items: [
            'Duplicatas a Receber',
            'Salários a Pagar',
            'Imóveis',
            'Reservas de Lucro',
            'Mercadorias'
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'Duplicatas a Receber': 'ac',
            'Mercadorias': 'ac',
            'Salários a Pagar': 'pc',
            'Imóveis': 'anc',
            'Reservas de Lucro': 'pl',
          },
          explanation: 'Duplicatas e Mercadorias = Ativo Circulante; Imóveis = Ativo Não Circulante; Salários a Pagar = Passivo Circulante; Reservas = Patrimônio Líquido.',
        ),

        MatchQuestion(
          id: 'n2q_drag_bp4',
          text: 'Classifique corretamente as contas.',
          items: [
            'Aplicações Financeiras',
            'Financiamentos a Pagar',
            'Equipamentos',
            'Capital Integralizado',
            'Caixa'
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'Aplicações Financeiras': 'ac',
            'Caixa': 'ac',
            'Financiamentos a Pagar': 'pc',
            'Equipamentos': 'anc',
            'Capital Integralizado': 'pl',
          },
          explanation: 'Aplicações e Caixa = Ativo Circulante; Equipamentos = Ativo Não Circulante; Financiamentos = Passivo; Capital Integralizado = Patrimônio Líquido.',
        ),

        MatchQuestion(
          id: 'n2q_drag_bp5',
          text: 'Arraste as contas para suas categorias.',
          items: [
            'Banco Conta Movimento',
            'Fornecedores',
            'Terrenos',
            'Lucro do Exercício',
            'Estoques'
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'Banco Conta Movimento': 'ac',
            'Estoques': 'ac',
            'Fornecedores': 'pc',
            'Terrenos': 'anc',
            'Lucro do Exercício': 'pl',
          },
          explanation: 'Banco e Estoques = Ativo Circulante; Terrenos = Ativo Não Circulante; Fornecedores = Passivo; Lucro do Exercício = Patrimônio Líquido.',
        ),

        MatchQuestion(
          id: 'n2q_drag_bp6',
          text: 'Relacione cada conta com sua classificação.',
          items: [
            'Clientes',
            'Contas a Pagar',
            'Computadores',
            'Capital Social',
            'Mercadorias'
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'Clientes': 'ac',
            'Mercadorias': 'ac',
            'Contas a Pagar': 'pc',
            'Computadores': 'anc',
            'Capital Social': 'pl',
          },
          explanation: 'Clientes e Mercadorias = Ativo Circulante; Computadores = Ativo Não Circulante; Contas a Pagar = Passivo; Capital Social = Patrimônio Líquido.',
        ),

        MatchQuestion(
          id: 'n2q_drag_bp7',
          text: 'Classifique as contas abaixo.',
          items: [
            'Caixa',
            'Salários a Pagar',
            'Veículos',
            'Reservas de Capital',
            'Clientes'
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'Caixa': 'ac',
            'Clientes': 'ac',
            'Salários a Pagar': 'pc',
            'Veículos': 'anc',
            'Reservas de Capital': 'pl',
          },
          explanation: 'Caixa e Clientes = Ativo Circulante; Veículos = Ativo Não Circulante; Salários a Pagar = Passivo Circulante; Reservas de Capital = Patrimônio Líquido.',
        ),

        MatchQuestion(
          id: 'n2q_drag_bp8',
          text: 'Associe cada conta à categoria correta.',
          items: [
            'Bancos',
            'Duplicatas a Pagar',
            'Máquinas',
            'Lucros Acumulados',
            'Estoques'
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'Bancos': 'ac',
            'Estoques': 'ac',
            'Duplicatas a Pagar': 'pc',
            'Máquinas': 'anc',
            'Lucros Acumulados': 'pl',
          },
          explanation: 'Bancos e Estoques = Ativo Circulante; Máquinas = Ativo Não Circulante; Duplicatas a Pagar = Passivo Circulante; Lucros Acumulados = Patrimônio Líquido.',
        ),

        MatchQuestion(
          id: 'n2q_drag_bp9',
          text: 'Arraste as contas para suas classificações.',
          items: [
            'Clientes',
            'Empréstimos Bancários',
            'Equipamentos',
            'Capital Social',
            'Aplicações Financeiras'
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'anc', label: 'Ativo Não Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'Clientes': 'ac',
            'Aplicações Financeiras': 'ac',
            'Empréstimos Bancários': 'pc',
            'Equipamentos': 'anc',
            'Capital Social': 'pl',
          },
          explanation: 'Clientes e Aplicações = Ativo Circulante; Equipamentos = Ativo Não Circulante; Empréstimos = Passivo; Capital Social = Patrimônio Líquido.',
        ),

        MatchQuestion(
          id: 'n2q_drag_bp10',
          text: 'Classifique corretamente as contas.',
          items: [
            'Caixa',
            'Fornecedores',
            'Imóveis',
            'Lucro do Exercício',
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
            'Imóveis': 'anc',
            'Lucro do Exercício': 'pl',
          },
          explanation: 'Caixa e Estoques = Ativo Circulante; Imóveis = Ativo Não Circulante; Fornecedores = Passivo Circulante; Lucro do Exercício = Patrimônio Líquido.',
        ),


      ],
    ),
  ],
);