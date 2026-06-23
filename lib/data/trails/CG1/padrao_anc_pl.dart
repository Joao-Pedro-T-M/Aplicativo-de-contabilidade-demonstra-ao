import '../../../models/course_models.dart';

final Trail padrao_anc_pl = Trail(
  id: 'padrao_anc_pl',
  title: 'BP — ANC e PL',
  description: 'Questões progressivas com foco no Ativo Não Circulante e no Capital Social.',
  lessons: [
    Lesson(
      id: 'l_anc_pl_basico',
      title: 'Ativo Não Circulante + Capital Social',
      questions: [
        MatchSumQuestion(
          id: 'ancpl_q1',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 2000),
            MatchSumItem(id: 'c2', label: 'Títulos a Receber LP', value: 1000),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 3000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_rlp', label: 'Realizável a Longo Prazo'),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_rlp',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2000,
            'anc_rlp': 1000,
            'anc': 1000,
            'pl': 3000,
          },
          explanation:
              'Títulos a Receber de longo prazo pertencem ao Realizável a Longo Prazo, dentro do ANC.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q2',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Bancos Conta Movimento', value: 3000),
            MatchSumItem(id: 'c2', label: 'Participações Societárias', value: 1000),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 4000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_inv', label: 'Investimentos'),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_inv',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 3000,
            'anc_inv': 1000,
            'anc': 1000,
            'pl': 4000,
          },
          explanation:
              'Participações Societárias são classificadas em Investimentos, que fazem parte do ANC.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q3',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Clientes', value: 2500),
            MatchSumItem(id: 'c2', label: 'Terrenos', value: 1500),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 4000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(
                  id: 'anc_imob',
                  label: 'Imobilizado',
                  subs: [
                    MatchTarget(id: 'anc_imob_terr', label: 'Terrenos'),
                  ],
                ),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_imob_terr',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2500,
            'anc_imob_terr': 1500,
            'anc_imob': 1500,
            'anc': 1500,
            'pl': 4000,
          },
          explanation:
              'Terrenos entram no Imobilizado, dentro do Ativo Não Circulante.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q4',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 2000),
            MatchSumItem(id: 'c2', label: 'Edificações', value: 2000),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 4000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(
                  id: 'anc_imob',
                  label: 'Imobilizado',
                  subs: [
                    MatchTarget(id: 'anc_imob_edif', label: 'Edificações'),
                  ],
                ),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_imob_edif',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 2000,
            'anc_imob_edif': 2000,
            'anc_imob': 2000,
            'anc': 2000,
            'pl': 4000,
          },
          explanation:
              'Edificações também são conta do Imobilizado, e continuam dentro do ANC.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q5',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Bancos Conta Movimento', value: 3500),
            MatchSumItem(id: 'c2', label: 'Máquinas e Equipamentos', value: 1500),
            MatchSumItem(id: 'c3', label: 'Capital Subscrito', value: 5000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(
                  id: 'anc_imob',
                  label: 'Imobilizado',
                  subs: [
                    MatchTarget(id: 'anc_imob_maq', label: 'Máquinas e Equipamentos'),
                  ],
                ),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_imob_maq',
            'c3': 'pl',
          },
          expectedTargetTotals: {
            'ac': 3500,
            'anc_imob_maq': 1500,
            'anc_imob': 1500,
            'anc': 1500,
            'pl': 5000,
          },
          explanation:
              'Nesta etapa o aluno começa a reconhecer mais uma conta do Imobilizado.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q6',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 3000),
            MatchSumItem(id: 'c2', label: 'Veículos', value: 1000),
            MatchSumItem(id: 'c3', label: 'Móveis e Utensílios', value: 1000),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 5000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(
                  id: 'anc_imob',
                  label: 'Imobilizado',
                  subs: [
                    MatchTarget(id: 'anc_imob_vei', label: 'Veículos'),
                    MatchTarget(id: 'anc_imob_mov', label: 'Móveis e Utensílios'),
                  ],
                ),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_imob_vei',
            'c3': 'anc_imob_mov',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 3000,
            'anc_imob_vei': 1000,
            'anc_imob_mov': 1000,
            'anc_imob': 2000,
            'anc': 2000,
            'pl': 5000,
          },
          explanation:
              'Veículos e móveis entram no Imobilizado, e o aluno já começa a somar duas contas diferentes no mesmo grupo.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q7',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 4000),
            MatchSumItem(id: 'c2', label: 'Terrenos', value: 4000),
            MatchSumItem(id: 'c3', label: '(-) Depreciação Acumulada', value: -500),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 7500),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(
                  id: 'anc_imob',
                  label: 'Imobilizado',
                  subs: [
                    MatchTarget(id: 'anc_imob_terr', label: 'Terrenos'),
                    MatchTarget(id: 'anc_imob_dep', label: '(-) Depreciação Acumulada'),
                  ],
                ),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_imob_terr',
            'c3': 'anc_imob_dep',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 4000,
            'anc_imob_terr': 4000,
            'anc_imob_dep': -500,
            'anc_imob': 3500,
            'anc': 3500,
            'pl': 7500,
          },
          explanation:
              'Aqui entra a conta redutora do Imobilizado, o que deixa a leitura um pouco mais avançada.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q8',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 5000),
            MatchSumItem(id: 'c2', label: 'Softwares', value: 2000),
            MatchSumItem(id: 'c3', label: '(-) Amortização Acumulada', value: -400),
            MatchSumItem(id: 'c4', label: 'Capital Subscrito', value: 6600),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(
                  id: 'anc_int',
                  label: 'Intangível',
                  subs: [
                    MatchTarget(id: 'anc_int_soft', label: 'Softwares'),
                    MatchTarget(id: 'anc_int_amort', label: '(-) Amortização Acumulada'),
                  ],
                ),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_int_soft',
            'c3': 'anc_int_amort',
            'c4': 'pl',
          },
          expectedTargetTotals: {
            'ac': 5000,
            'anc_int_soft': 2000,
            'anc_int_amort': -400,
            'anc_int': 1600,
            'anc': 1600,
            'pl': 6600,
          },
          explanation:
              'Softwares ficam no Intangível, e a amortização acumulada atua como redutora desse grupo.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q9',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Clientes', value: 6000),
            MatchSumItem(id: 'c2', label: 'Títulos a Receber LP', value: 1000),
            MatchSumItem(id: 'c3', label: 'Participações Societárias', value: 2000),
            MatchSumItem(id: 'c4', label: 'Máquinas e Equipamentos', value: 1500),
            MatchSumItem(id: 'c5', label: '(-) Depreciação Acumulada', value: -500),
            MatchSumItem(id: 'c6', label: 'Capital Subscrito', value: 10000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_rlp', label: 'Realizável a Longo Prazo'),
                MatchTarget(id: 'anc_inv', label: 'Investimentos'),
                MatchTarget(
                  id: 'anc_imob',
                  label: 'Imobilizado',
                  subs: [
                    MatchTarget(id: 'anc_imob_maq', label: 'Máquinas e Equipamentos'),
                    MatchTarget(id: 'anc_imob_dep', label: '(-) Depreciação Acumulada'),
                  ],
                ),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_rlp',
            'c3': 'anc_inv',
            'c4': 'anc_imob_maq',
            'c5': 'anc_imob_dep',
            'c6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 6000,
            'anc_rlp': 1000,
            'anc_inv': 2000,
            'anc_imob_maq': 1500,
            'anc_imob_dep': -500,
            'anc_imob': 1000,
            'anc': 4000,
            'pl': 10000,
          },
          explanation:
              'Agora a classificação mistura RLP, Investimentos e Imobilizado na mesma questão.',
        ),
        MatchSumQuestion(
          id: 'ancpl_q10',
          text: 'Classifique as contas abaixo em Ativo Circulante, Ativo Não Circulante e Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 7000),
            MatchSumItem(id: 'c2', label: 'Títulos a Receber LP', value: 1500),
            MatchSumItem(id: 'c3', label: 'Participações Societárias', value: 2000),
            MatchSumItem(id: 'c4', label: 'Terrenos', value: 2500),
            MatchSumItem(id: 'c5', label: 'Edificações', value: 3000),
            MatchSumItem(id: 'c6', label: '(-) Depreciação Acumulada', value: -500),
            MatchSumItem(id: 'c7', label: 'Softwares', value: 1000),
            MatchSumItem(id: 'c8', label: '(-) Amortização Acumulada', value: -500),
            MatchSumItem(id: 'c9', label: 'Capital Subscrito', value: 16000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_rlp', label: 'Realizável a Longo Prazo'),
                MatchTarget(id: 'anc_inv', label: 'Investimentos'),
                MatchTarget(
                  id: 'anc_imob',
                  label: 'Imobilizado',
                  subs: [
                    MatchTarget(id: 'anc_imob_terr', label: 'Terrenos'),
                    MatchTarget(id: 'anc_imob_edif', label: 'Edificações'),
                    MatchTarget(id: 'anc_imob_dep', label: '(-) Depreciação Acumulada'),
                  ],
                ),
                MatchTarget(
                  id: 'anc_int',
                  label: 'Intangível',
                  subs: [
                    MatchTarget(id: 'anc_int_soft', label: 'Softwares'),
                    MatchTarget(id: 'anc_int_amort', label: '(-) Amortização Acumulada'),
                  ],
                ),
              ],
            ),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'anc_rlp',
            'c3': 'anc_inv',
            'c4': 'anc_imob_terr',
            'c5': 'anc_imob_edif',
            'c6': 'anc_imob_dep',
            'c7': 'anc_int_soft',
            'c8': 'anc_int_amort',
            'c9': 'pl',
          },
          expectedTargetTotals: {
            'ac': 7000,
            'anc_rlp': 1500,
            'anc_inv': 2000,
            'anc_imob_terr': 2500,
            'anc_imob_edif': 3000,
            'anc_imob_dep': -500,
            'anc_imob': 5000,
            'anc_int_soft': 1000,
            'anc_int_amort': -500,
            'anc_int': 500,
            'anc': 9000,
            'pl': 16000,
          },
          explanation:
              'Esta é a questão mais completa da sequência, reunindo todos os subgrupos do ANC em um único exercício.',
        ),
      ],
    ),
  ],
);