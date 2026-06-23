import '../../../models/course_models.dart';

final Trail padrao_ac_pl = Trail(
  id: 'padrao_ac_pl',
  title: 'BP — AC e PL',
  description: 'Questões progressivas com foco no Ativo Circulante e no Capital Social.',
  lessons: [
    Lesson(
      id: 'l_ac_pl_basico',
      title: 'Ativo Circulante + Capital Social',
      questions: [
        MatchSumQuestion(
          id: 'acpl_q1',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 1000),
            MatchSumItem(id: 'c2', label: 'Capital Subscrito', value: 1000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'pl',
          },
          expectedTargetTotals: {
            'ac': 1000,
            'pl': 1000,
          },
          explanation:
              'Caixa pertence ao Ativo Circulante. Capital Subscrito pertence ao Patrimônio Líquido. '
              'Como os dois lados somam 1.000, o balanço fica equilibrado.',
        ),
        MatchSumQuestion(
          id: 'acpl_q2',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 1200),
            MatchSumItem(id: 'c2', label: 'Bancos Conta Movimento', value: 800),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 2000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2000,
            'pl': 2000,
          },
          explanation:
              'Caixa e Bancos Conta Movimento são contas do Ativo Circulante. Capital Subscrito é do Patrimônio Líquido.',
        ),
        MatchSumQuestion(
          id: 'acpl_q3',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 900),
            MatchSumItem(id: 'c2', label: 'Clientes', value: 1100),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 2000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2000,
            'pl': 2000,
          },
          explanation:
              'Caixa e Clientes representam direitos de curto prazo, então entram no Ativo Circulante.',
        ),
        MatchSumQuestion(
          id: 'acpl_q4',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 700),
            MatchSumItem(id: 'c2', label: 'Bancos Conta Movimento', value: 600),
            MatchSumItem(id: 'c3', label: 'Clientes', value: 700),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 2000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'ac',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2000,
            'pl': 2000,
          },
          explanation:
              'Nesta etapa surgem mais contas do Ativo Circulante, mas a lógica continua a mesma: recursos de curto prazo vão para AC.',
        ),
        MatchSumQuestion(
          id: 'acpl_q5',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 500),
            MatchSumItem(id: 'c2', label: 'Bancos Conta Movimento', value: 700),
            MatchSumItem(id: 'c3', label: 'Mercadorias', value: 800),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 2000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'ac',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2000,
            'pl': 2000,
          },
          explanation:
              'Mercadorias também são Ativo Circulante porque fazem parte do estoque da empresa.',
        ),
        MatchSumQuestion(
          id: 'acpl_q6',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 400),
            MatchSumItem(id: 'c2', label: 'Clientes', value: 900),
            MatchSumItem(id: 'c3', label: 'Mercadorias', value: 700),
            MatchSumItem(id: 'c4', label: 'Despesas Antecipadas', value: 1000),
            MatchSumItem(id: 'c5', label: 'Capital Subscrito', value: 3000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'ac',
            'c4': 'ac',
            'c5': 'pl',
          },
          expectedTargetTotals: {
            'ac': 3000,
            'pl': 3000,
          },
          explanation:
              'Despesas antecipadas entram no Ativo Circulante porque representam benefício futuro de curto prazo.',
        ),
        MatchSumQuestion(
          id: 'acpl_q7',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 600),
            MatchSumItem(id: 'c2', label: 'Bancos Conta Movimento', value: 700),
            MatchSumItem(id: 'c3', label: 'Clientes', value: 500),
            MatchSumItem(id: 'c4', label: 'Impostos a Recuperar', value: 1200),
            MatchSumItem(id: 'c5', label: 'Capital Subscrito', value: 3000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'ac',
            'c4': 'ac',
            'c5': 'pl',
          },
          expectedTargetTotals: {
            'ac': 3000,
            'pl': 3000,
          },
          explanation:
              'Impostos a Recuperar também são AC, pois representam valores que a empresa pode compensar no curto prazo.',
        ),
        MatchSumQuestion(
          id: 'acpl_q8',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 800),
            MatchSumItem(id: 'c2', label: 'Bancos Conta Movimento', value: 500),
            MatchSumItem(id: 'c3', label: 'Clientes', value: 900),
            MatchSumItem(id: 'c4', label: 'Mercadorias', value: 700),
            MatchSumItem(id: 'c5', label: 'Seguros Pagos Antecipadamente', value: 1100),
            MatchSumItem(id: 'c6', label: 'Capital Subscrito', value: 4000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'ac',
            'c4': 'ac',
            'c5': 'ac',
            'c6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 4000,
            'pl': 4000,
          },
          explanation:
              'Seguros pagos antecipadamente são AC porque o benefício será aproveitado em período futuro próximo.',
        ),
        MatchSumQuestion(
          id: 'acpl_q9',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 1000),
            MatchSumItem(id: 'c2', label: 'Bancos Conta Movimento', value: 1200),
            MatchSumItem(id: 'c3', label: 'Clientes', value: 800),
            MatchSumItem(id: 'c4', label: 'Mercadorias', value: 1000),
            MatchSumItem(id: 'c5', label: 'Impostos a Recuperar', value: 1000),
            MatchSumItem(id: 'c6', label: 'Despesas Antecipadas', value: 1000),
            MatchSumItem(id: 'c7', label: 'Capital Subscrito', value: 6000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'ac',
            'c4': 'ac',
            'c5': 'ac',
            'c6': 'ac',
            'c7': 'pl',
          },
          expectedTargetTotals: {
            'ac': 6000,
            'pl': 6000,
          },
          explanation:
              'Aqui o aluno precisa perceber que várias contas diferentes continuam pertencendo ao mesmo grupo: Ativo Circulante.',
        ),
        MatchSumQuestion(
          id: 'acpl_q10',
          text: 'Classifique as contas abaixo em Ativo Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 1500),
            MatchSumItem(id: 'c2', label: 'Bancos Conta Movimento', value: 1500),
            MatchSumItem(id: 'c3', label: 'Clientes', value: 1000),
            MatchSumItem(id: 'c4', label: 'Mercadorias', value: 1000),
            MatchSumItem(id: 'c5', label: 'Impostos a Recuperar', value: 1000),
            MatchSumItem(id: 'c6', label: 'Seguros Pagos Antecipadamente', value: 1000),
            MatchSumItem(id: 'c7', label: 'Capital Subscrito', value: 7000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'ac',
            'c4': 'ac',
            'c5': 'ac',
            'c6': 'ac',
            'c7': 'pl',
          },
          expectedTargetTotals: {
            'ac': 7000,
            'pl': 7000,
          },
          explanation:
              'Esta é a etapa final da sequência básica: mais itens no Ativo Circulante, mas ainda sem ANC.',
        ),
      ],
    ),
  ],
);