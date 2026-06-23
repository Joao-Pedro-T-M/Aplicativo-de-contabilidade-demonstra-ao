import '../../../models/course_models.dart';

final Trail padrao_pc_pl = Trail(
  id: 'padrao_pc_pl',
  title: 'BP — PC e PL',
  description: 'Questões progressivas com foco no Passivo Circulante e no Capital Social.',
  lessons: [
    Lesson(
      id: 'l_pc_pl_basico',
      title: 'Passivo Circulante + Capital Social',
      questions: [
        MatchSumQuestion(
          id: 'pcpl_q1',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 2500),
            MatchSumItem(id: 'c2', label: 'Fornecedores Nacionais', value: 1000),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 1500),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2500,
            'pc': 1000,
            'pl': 1500,
          },
          explanation:
              'Caixa é Ativo Circulante. Fornecedores Nacionais é Passivo Circulante. Capital Subscrito é Patrimônio Líquido.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q2',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Bancos Conta Movimento', value: 3000),
            MatchSumItem(id: 'c2', label: 'Empréstimos Bancários', value: 1500),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 1500),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 3000,
            'pc': 1500,
            'pl': 1500,
          },
          explanation:
              'Empréstimos Bancários aparecem no Passivo Circulante quando a obrigação é de curto prazo.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q3',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Clientes', value: 2200),
            MatchSumItem(id: 'c2', label: 'Fornecedores Nacionais', value: 1200),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 1000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2200,
            'pc': 1200,
            'pl': 1000,
          },
          explanation:
              'Clientes é Ativo Circulante porque representa direito a receber. Fornecedores é obrigação de curto prazo.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q4',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 2800),
            MatchSumItem(id: 'c2', label: 'ICMS a Recolher', value: 900),
            MatchSumItem(id: 'c3', label: 'Salários a Pagar', value: 1100),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 2000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2800,
            'pc': 2000,
            'pl': 2000,
          },
          explanation:
              'ICMS a Recolher e Salários a Pagar são obrigações do Passivo Circulante.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q5',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Bancos Conta Movimento', value: 4000),
            MatchSumItem(id: 'c2', label: 'Contas a Pagar', value: 1000),
            MatchSumItem(id: 'c3', label: 'Energia a Pagar', value: 1000),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 2000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 4000,
            'pc': 2000,
            'pl': 2000,
          },
          explanation:
              'Contas a Pagar e Energia a Pagar são exemplos clássicos de Passivo Circulante.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q6',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 5000),
            MatchSumItem(id: 'c2', label: 'Fornecedores Nacionais', value: 1300),
            MatchSumItem(id: 'c3', label: 'ISSQN a Recolher', value: 700),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 3000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 5000,
            'pc': 2000,
            'pl': 3000,
          },
          explanation:
              'Nesta etapa o aluno começa a reconhecer diferentes obrigações fiscais no Passivo Circulante.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q7',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Mercadorias', value: 4500),
            MatchSumItem(id: 'c2', label: 'Salários a Pagar', value: 1000),
            MatchSumItem(id: 'c3', label: 'FGTS a Recolher', value: 500),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 3000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 4500,
            'pc': 1500,
            'pl': 3000,
          },
          explanation:
              'FGTS a Recolher também é Passivo Circulante, pois é uma obrigação trabalhista de curto prazo.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q8',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 6000),
            MatchSumItem(id: 'c2', label: 'Receita Antecipada', value: 1200),
            MatchSumItem(id: 'c3', label: 'Provisão de Férias', value: 800),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 4000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 6000,
            'pc': 2000,
            'pl': 4000,
          },
          explanation:
              'Receita antecipada e provisão de férias são obrigações do Passivo Circulante.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q9',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Bancos Conta Movimento', value: 7000),
            MatchSumItem(id: 'c2', label: 'Empréstimos Bancários', value: 1200),
            MatchSumItem(id: 'c3', label: 'SIMPLES NACIONAL', value: 1800),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 4000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 7000,
            'pc': 3000,
            'pl': 4000,
          },
          explanation:
              'Nesta fase o aluno já reconhece tributos e financiamentos de curto prazo no Passivo Circulante.',
        ),
        MatchSumQuestion(
          id: 'pcpl_q10',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Clientes', value: 8000),
            MatchSumItem(id: 'c2', label: 'Fornecedores Nacionais', value: 1000),
            MatchSumItem(id: 'c3', label: 'Contas a Pagar', value: 1000),
            MatchSumItem(id: 'c4', label: 'Salários a Pagar', value: 1000),
            MatchSumItem(id: 'c5', label: 'Capital Subscrito', value: 5000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pc',
            'c3': 'pc',
            'c4': 'pc',
            'c5': 'pl',
          },
          expectedTargetTotals: {
            'ac': 8000,
            'pc': 3000,
            'pl': 5000,
          },
          explanation:
              'A sequência final reúne várias obrigações de curto prazo, mas ainda mantém a leitura simples e direta.',
        ),
      ],
    ),
  ],
);