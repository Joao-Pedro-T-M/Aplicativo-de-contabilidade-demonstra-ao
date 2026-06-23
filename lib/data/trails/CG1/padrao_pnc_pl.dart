import '../../../models/course_models.dart';

final Trail padrao_pnc_pl = Trail(
  id: 'padrao_pnc_pl',
  title: 'BP — PNC e PL',
  description: 'Questões progressivas com foco no Passivo Não Circulante e no Capital Social.',
  lessons: [
    Lesson(
      id: 'l_pnc_pl_basico',
      title: 'Passivo Não Circulante + Capital Social',
      questions: [
        MatchSumQuestion(
          id: 'pncpl_q1',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 2500),
            MatchSumItem(id: 'c2', label: 'Empréstimos de Sócios', value: 1500),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 1000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2500,
            'pnc': 1500,
            'pl': 1000,
          },
          explanation:
              'Caixa é Ativo Circulante. Empréstimos de Sócios é Passivo Não Circulante. Capital Subscrito é Patrimônio Líquido.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q2',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Bancos Conta Movimento', value: 3000),
            MatchSumItem(id: 'c2', label: 'Financiamentos Banco A', value: 1000),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 2000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 3000,
            'pnc': 1000,
            'pl': 2000,
          },
          explanation:
              'Financiamentos de longo prazo entram no Passivo Não Circulante.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q3',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Clientes', value: 2200),
            MatchSumItem(id: 'c2', label: 'Financiamentos Banco A', value: 1200),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 1000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2200,
            'pnc': 1200,
            'pl': 1000,
          },
          explanation:
              'Clientes é Ativo Circulante e Financiamentos Banco A é obrigação de longo prazo.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q4',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 2800),
            MatchSumItem(id: 'c2', label: 'Empréstimos de Sócios', value: 900),
            MatchSumItem(id: 'c3', label: 'Financiamentos Banco A', value: 1100),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 2000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pnc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2800,
            'pnc': 2000,
            'pl': 2000,
          },
          explanation:
              'Aqui o aluno começa a separar mais de uma obrigação de longo prazo no Passivo Não Circulante.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q5',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Bancos Conta Movimento', value: 4000),
            MatchSumItem(id: 'c2', label: 'Empréstimos de Sócios', value: 1000),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 3000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 4000,
            'pnc': 1000,
            'pl': 3000,
          },
          explanation:
              'A lógica continua a mesma: contas de caixa e banco ficam no Ativo Circulante, enquanto a obrigação de longo prazo vai para PNC.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q6',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 5000),
            MatchSumItem(id: 'c2', label: 'Financiamentos Banco A', value: 1300),
            MatchSumItem(id: 'c3', label: 'Empréstimos de Sócios', value: 700),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 3000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pnc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 5000,
            'pnc': 2000,
            'pl': 3000,
          },
          explanation:
              'Nesta etapa o aluno percebe que o PNC pode reunir mais de uma conta de longo prazo.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q7',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Mercadorias', value: 4500),
            MatchSumItem(id: 'c2', label: 'Financiamentos Banco A', value: 1000),
            MatchSumItem(id: 'c3', label: 'Empréstimos de Sócios', value: 500),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 3000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pnc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 4500,
            'pnc': 1500,
            'pl': 3000,
          },
          explanation:
              'Mercadorias são Ativo Circulante. Financiamentos e empréstimos de longo prazo formam o Passivo Não Circulante.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q8',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 6000),
            MatchSumItem(id: 'c2', label: 'Financiamentos Banco A', value: 1200),
            MatchSumItem(id: 'c3', label: 'Empréstimos de Sócios', value: 800),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 4000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pnc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 6000,
            'pnc': 2000,
            'pl': 4000,
          },
          explanation:
              'Agora o aluno já identifica o PNC com mais segurança e sem depender de apenas uma conta.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q9',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Clientes', value: 7000),
            MatchSumItem(id: 'c2', label: 'Financiamentos Banco A', value: 1500),
            MatchSumItem(id: 'c3', label: 'Empréstimos de Sócios', value: 1500),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 4000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pnc',
            'c3': 'pnc',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 7000,
            'pnc': 3000,
            'pl': 4000,
          },
          explanation:
              'Nesta questão há duas contas de Passivo Não Circulante, exigindo mais atenção na classificação.',
        ),
        MatchSumQuestion(
          id: 'pncpl_q10',
          text: 'Classifique as contas abaixo em Ativo Circulante, Passivo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 8000),
            MatchSumItem(id: 'c2', label: 'Bancos Conta Movimento', value: 2000),
            MatchSumItem(id: 'c3', label: 'Financiamentos Banco A', value: 2000),
            MatchSumItem(id: 'c4', label: 'Empréstimos de Sócios', value: 1000),
            MatchSumItem(id: 'c5', label: 'Capital Subscrito', value: 9000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo Não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'pnc',
            'c4': 'pnc',
            'c5': 'pl',
          },
          expectedTargetTotals: {
            'ac': 10000,
            'pnc': 3000,
            'pl': 9000,
          },
          explanation:
              'Fechando a sequência, o aluno trabalha com mais de uma conta no ativo e duas contas no PNC.',
        ),
      ],
    ),
  ],
);