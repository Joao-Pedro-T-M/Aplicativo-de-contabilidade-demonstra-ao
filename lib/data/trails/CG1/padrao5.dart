import '../../../models/course_models.dart';

final Trail padrao5 = Trail(
  id: 'padrao5',
  title: 'Balanço Patrimonial — Classificação com Somatórios',
  description: 'Classifique contas e observe o equilíbrio do Balanço Patrimonial.',
  lessons: [
    Lesson(
      id: 'l_sum_bp',
      title: 'Classificação e somas',
      questions: [
        MatchSumQuestion(
          id: 'n1_sum_bp3',
          text:
              'Classifique as contas abaixo no Balanço Patrimonial e verifique se o total do Ativo é igual ao total do Passivo + Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 20000),
            MatchSumItem(id: 'c2', label: 'Banco', value: 2100),
            MatchSumItem(id: 'c3', label: 'Clientes', value: 800),
            MatchSumItem(id: 'c4', label: 'Seguros antecipados', value: 500),
            MatchSumItem(id: 'c5', label: 'Contas a pagar', value: 300),
            MatchSumItem(id: 'c6', label: 'Duplicatas a pagar', value: 12000),
            MatchSumItem(id: 'c7', label: 'Empréstimos', value: 5000),
            MatchSumItem(id: 'c8', label: 'Receita antecipada', value: 670),
            MatchSumItem(id: 'c9', label: 'Capital social', value: 19000),
            MatchSumItem(id: 'c10', label: 'Lucro/Prejuízo acumulado', value: 2830),
            MatchSumItem(id: 'c11', label: 'Amortização acumulada', value: -600),
            MatchSumItem(id: 'c12', label: 'Terrenos', value: 15000),
            MatchSumItem(id: 'c13', label: 'Patentes', value: 2000),
            MatchSumItem(id: 'c14', label: 'Títulos a receber LP', value: 4500),
            MatchSumItem(id: 'c15', label: 'Participações societárias', value: 2500),
            MatchSumItem(id: 'c16', label: 'Debêntures de longo prazo', value: 7000),
          ],
          targets: [
            MatchTarget(
              id: 'ac',
              label: 'Ativo Circulante',
            ),
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
                    MatchTarget(id: 'anc_imob_amort', label: 'Amortização acumulada'),
                    MatchTarget(id: 'anc_imob_terr', label: 'Terrenos'),
                  ],
                ),
                MatchTarget(
                  id: 'anc_int',
                  label: 'Intangível',
                  subs: [
                    MatchTarget(id: 'anc_int_pat', label: 'Patentes'),
                  ],
                ),
              ],
            ),
            MatchTarget(
              id: 'pc',
              label: 'Passivo Circulante',
            ),
            MatchTarget(
              id: 'pnc',
              label: 'Passivo não Circulante',
            ),
            MatchTarget(
              id: 'pl',
              label: 'Patrimônio Líquido',
            ),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'ac',
            'c4': 'ac',
            'c5': 'pc',
            'c6': 'pc',
            'c7': 'pc',
            'c8': 'pc',
            'c9': 'pl',
            'c10': 'pl',
            'c11': 'anc_imob_amort',
            'c12': 'anc_imob_terr',
            'c13': 'anc_int_pat',
            'c14': 'anc_rlp',
            'c15': 'anc_inv',
            'c16': 'pnc',
          },
          expectedTargetTotals: {
            'ac': 23400,
            'anc_rlp': 4500,
            'anc_inv': 2500,
            'anc_imob_amort': -600,
            'anc_imob_terr': 15000,
            'anc_imob': 14400,
            'anc_int_pat': 2000,
            'anc_int': 2000,
            'anc': 23400,
            'pc': 17970,
            'pnc': 7000,
            'pl': 21830,
          },
          explanation:
              'Ativo Circulante: Caixa (20.000), Banco (2.100), Clientes (800) e Seguros antecipados (500) = 23.400,00. '
              'Ativo Não Circulante: Realizável a Longo Prazo — Títulos a receber LP (4.500), Investimentos — Participações societárias (2.500), Imobilizado — Terrenos (15.000) e Amortização acumulada (-600) = 14.400,00, e Intangível — Patentes (2.000) = 2.000,00. '
              'Passivo Circulante: Contas a pagar (300), Duplicatas a pagar (12.000), Empréstimos (5.000) e Receita antecipada (670) = 17.970,00. '
              'Passivo não Circulante: Debêntures de longo prazo (7.000) = 7.000,00. '
              'Patrimônio Líquido: Capital social (19.000) e Lucro/Prejuízo acumulado (2.830) = 21.830,00. '
              'Total do Ativo = 46.800,00 e Total do Passivo + PL = 46.800,00. '
              'Assim, o Balanço Patrimonial está equilibrado.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp11',
          text:
              'Classifique as contas abaixo no Balanço Patrimonial e verifique se o total do Ativo é igual ao total do Passivo + Patrimônio Líquido.',
          items: [
            MatchSumItem(id: 'c1', label: 'Caixa', value: 10000),
            MatchSumItem(id: 'c2', label: 'Clientes', value: 15000),
            MatchSumItem(id: 'c3', label: 'Créditos a receber LP', value: 5000),
            MatchSumItem(id: 'c4', label: 'Máquinas', value: 30000),
            MatchSumItem(id: 'c5', label: 'Patente', value: 20000),
            MatchSumItem(id: 'c6', label: 'Fornecedores', value: 25000),
            MatchSumItem(id: 'c7', label: 'Financiamentos LP', value: 5000),
            MatchSumItem(id: 'c8', label: 'Capital Social', value: 50000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_rlp', label: 'Realizável a Longo Prazo'),
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'anc_rlp',
            'c4': 'anc_imob',
            'c5': 'anc_int',
            'c6': 'pc',
            'c7': 'pnc',
            'c8': 'pl',
          },
          expectedTargetTotals: {
            'ac': 25000,
            'anc_rlp': 5000,
            'anc_imob': 30000,
            'anc_int': 20000,
            'anc': 55000,
            'pc': 25000,
            'pnc': 5000,
            'pl': 50000,
          },
explanation:
  'Ativo Circulante: Caixa (10.000) e Clientes (15.000) = 25.000,00. '
  'Ativo Não Circulante: Realizável a Longo Prazo — Créditos a receber LP (5.000) = 5.000,00. '
  'Imobilizado — Máquinas (30.000) = 30.000,00. '
  'Intangível — Patente (20.000) = 20.000,00. '
  'Passivo Circulante: Fornecedores (25.000) = 25.000,00. '
  'Passivo não Circulante: Financiamentos LP (5.000) = 5.000,00. '
  'Patrimônio Líquido: Capital Social (50.000) = 50.000,00. '
  'Total do Ativo = 80.000,00 e Total do Passivo + PL = 80.000,00. '
  'Assim, o Balanço Patrimonial está equilibrado.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp12',
          text:
              'Distribua corretamente as contas no Balanço Patrimonial e observe o equilíbrio das somas.',
          items: [
            MatchSumItem(id: 'i1', label: 'Bancos', value: 9000),
            MatchSumItem(id: 'i2', label: 'Estoques', value: 11000),
            MatchSumItem(id: 'i3', label: 'Participações permanentes', value: 12000),
            MatchSumItem(id: 'i4', label: 'Veículos', value: 40000),
            MatchSumItem(id: 'i5', label: 'Software', value: 15000),
            MatchSumItem(id: 'i6', label: 'Fornecedores', value: 20000),
            MatchSumItem(id: 'i7', label: 'Empréstimos LP', value: 12000),
            MatchSumItem(id: 'i8', label: 'Capital Social', value: 55000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_inv', label: 'Investimentos'),
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pnc', label: 'Passivo não Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'i1': 'ac',
            'i2': 'ac',
            'i3': 'anc_inv',
            'i4': 'anc_imob',
            'i5': 'anc_int',
            'i6': 'pc',
            'i7': 'pnc',
            'i8': 'pl',
          },
          expectedTargetTotals: {
            'ac': 20000,
            'anc_inv': 12000,
            'anc_imob': 40000,
            'anc_int': 15000,
            'anc': 67000,
            'pc': 20000,
            'pnc': 12000,
            'pl': 55000,
          },
          explanation:
              'Ativo Circulante: Bancos (9.000) e Estoques (11.000) = 20.000,00. '
              'Ativo Não Circulante: Investimentos — Participações permanentes (12.000), Imobilizado — Veículos (40.000) e Intangível — Software (15.000) = 67.000,00. '
              'Passivo Circulante: Fornecedores (20.000) = 20.000,00. '
              'Passivo não Circulante: Empréstimos LP (12.000) = 12.000,00. '
              'Patrimônio Líquido: Capital Social (55.000) = 55.000,00. '
              'Total do Ativo = 87.000,00 e Total do Passivo + PL = 87.000,00.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp4',
          text: 'Classifique as contas no Balanço Patrimonial e observe os totais.',
          items: [
            MatchSumItem(id: 'a1', label: 'Caixa', value: 8000),
            MatchSumItem(id: 'a2', label: 'Clientes', value: 12000),
            MatchSumItem(id: 'a3', label: 'Equipamentos', value: 35000),
            MatchSumItem(id: 'a4', label: 'Marca', value: 15000),
            MatchSumItem(id: 'a5', label: 'Fornecedores', value: 20000),
            MatchSumItem(id: 'a6', label: 'Capital Social', value: 50000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'a1': 'ac',
            'a2': 'ac',
            'a3': 'anc_imob',
            'a4': 'anc_int',
            'a5': 'pc',
            'a6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 20000,
            'anc_imob': 35000,
            'anc_int': 15000,
            'anc': 50000,
            'pc': 20000,
            'pl': 50000,
          },
          explanation:
              'Ativo Circulante: Caixa (8.000) e Clientes (12.000) = 20.000,00. '
              'Ativo Não Circulante: Imobilizado — Equipamentos (35.000) e Intangível — Marca (15.000) = 50.000,00. '
              'Passivo Circulante: Fornecedores (20.000) = 20.000,00. '
              'Patrimônio Líquido: Capital Social (50.000) = 50.000,00. '
              'Total do Ativo = 70.000,00 e Total do Passivo + PL = 70.000,00.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp5',
          text: 'Classifique as contas no Balanço Patrimonial e observe os totais.',
          items: [
            MatchSumItem(id: 'b1', label: 'Caixa', value: 10000),
            MatchSumItem(id: 'b2', label: 'Clientes', value: 15000),
            MatchSumItem(id: 'b3', label: 'Máquinas', value: 30000),
            MatchSumItem(id: 'b4', label: 'Patente', value: 20000),
            MatchSumItem(id: 'b5', label: 'Fornecedores', value: 25000),
            MatchSumItem(id: 'b6', label: 'Capital Social', value: 50000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'b1': 'ac',
            'b2': 'ac',
            'b3': 'anc_imob',
            'b4': 'anc_int',
            'b5': 'pc',
            'b6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 25000,
            'anc_imob': 30000,
            'anc_int': 20000,
            'anc': 50000,
            'pc': 25000,
            'pl': 50000,
          },
          explanation:
              'Ativo Circulante: Caixa (10.000) e Clientes (15.000) = 25.000,00. '
              'Ativo Não Circulante: Imobilizado — Máquinas (30.000) e Intangível — Patente (20.000) = 50.000,00. '
              'Passivo Circulante: Fornecedores (25.000) = 25.000,00. '
              'Patrimônio Líquido: Capital Social (50.000) = 50.000,00. '
              'Total do Ativo = 75.000,00 e Total do Passivo + PL = 75.000,00.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp6',
          text: 'Classifique as contas no Balanço Patrimonial e observe os totais.',
          items: [
            MatchSumItem(id: 'c1', label: 'Bancos', value: 9000),
            MatchSumItem(id: 'c2', label: 'Estoques', value: 11000),
            MatchSumItem(id: 'c3', label: 'Veículos', value: 40000),
            MatchSumItem(id: 'c4', label: 'Software', value: 15000),
            MatchSumItem(id: 'c5', label: 'Fornecedores', value: 20000),
            MatchSumItem(id: 'c6', label: 'Capital Social', value: 55000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'c1': 'ac',
            'c2': 'ac',
            'c3': 'anc_imob',
            'c4': 'anc_int',
            'c5': 'pc',
            'c6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 20000,
            'anc_imob': 40000,
            'anc_int': 15000,
            'anc': 55000,
            'pc': 20000,
            'pl': 55000,
          },
          explanation:
              'Ativo Circulante: Bancos (9.000) e Estoques (11.000) = 20.000,00. '
              'Ativo Não Circulante: Imobilizado — Veículos (40.000) e Intangível — Software (15.000) = 55.000,00. '
              'Passivo Circulante: Fornecedores (20.000) = 20.000,00. '
              'Patrimônio Líquido: Capital Social (55.000) = 55.000,00. '
              'Total do Ativo = 75.000,00 e Total do Passivo + PL = 75.000,00.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp7',
          text: 'Classifique as contas no Balanço Patrimonial e observe os totais.',
          items: [
            MatchSumItem(id: 'd1', label: 'Caixa', value: 7000),
            MatchSumItem(id: 'd2', label: 'Clientes', value: 13000),
            MatchSumItem(id: 'd3', label: 'Equipamentos', value: 30000),
            MatchSumItem(id: 'd4', label: 'Marca', value: 20000),
            MatchSumItem(id: 'd5', label: 'Fornecedores', value: 15000),
            MatchSumItem(id: 'd6', label: 'Capital Social', value: 55000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'd1': 'ac',
            'd2': 'ac',
            'd3': 'anc_imob',
            'd4': 'anc_int',
            'd5': 'pc',
            'd6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 20000,
            'anc_imob': 30000,
            'anc_int': 20000,
            'anc': 50000,
            'pc': 15000,
            'pl': 55000,
          },
          explanation:
              'Ativo Circulante: Caixa (7.000) e Clientes (13.000) = 20.000,00. '
              'Ativo Não Circulante: Imobilizado — Equipamentos (30.000) e Intangível — Marca (20.000) = 50.000,00. '
              'Passivo Circulante: Fornecedores (15.000) = 15.000,00. '
              'Patrimônio Líquido: Capital Social (55.000) = 55.000,00. '
              'Total do Ativo = 70.000,00 e Total do Passivo + PL = 70.000,00.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp8',
          text: 'Classifique as contas no Balanço Patrimonial e observe os totais.',
          items: [
            MatchSumItem(id: 'e1', label: 'Caixa', value: 9000),
            MatchSumItem(id: 'e2', label: 'Clientes', value: 11000),
            MatchSumItem(id: 'e3', label: 'Terrenos', value: 35000),
            MatchSumItem(id: 'e4', label: 'Software', value: 15000),
            MatchSumItem(id: 'e5', label: 'Fornecedores', value: 20000),
            MatchSumItem(id: 'e6', label: 'Capital Social', value: 50000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'e1': 'ac',
            'e2': 'ac',
            'e3': 'anc_imob',
            'e4': 'anc_int',
            'e5': 'pc',
            'e6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 20000,
            'anc_imob': 35000,
            'anc_int': 15000,
            'anc': 50000,
            'pc': 20000,
            'pl': 50000,
          },
          explanation:
              'Ativo Circulante: Caixa (9.000) e Clientes (11.000) = 20.000,00. '
              'Ativo Não Circulante: Imobilizado — Terrenos (35.000) e Intangível — Software (15.000) = 50.000,00. '
              'Passivo Circulante: Fornecedores (20.000) = 20.000,00. '
              'Patrimônio Líquido: Capital Social (50.000) = 50.000,00. '
              'Total do Ativo = 70.000,00 e Total do Passivo + PL = 70.000,00.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp9',
          text: 'Classifique as contas no Balanço Patrimonial e observe os totais.',
          items: [
            MatchSumItem(id: 'f1', label: 'Bancos', value: 10000),
            MatchSumItem(id: 'f2', label: 'Estoques', value: 10000),
            MatchSumItem(id: 'f3', label: 'Máquinas', value: 40000),
            MatchSumItem(id: 'f4', label: 'Marca', value: 10000),
            MatchSumItem(id: 'f5', label: 'Fornecedores', value: 15000),
            MatchSumItem(id: 'f6', label: 'Capital Social', value: 55000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'f1': 'ac',
            'f2': 'ac',
            'f3': 'anc_imob',
            'f4': 'anc_int',
            'f5': 'pc',
            'f6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 20000,
            'anc_imob': 40000,
            'anc_int': 10000,
            'anc': 50000,
            'pc': 15000,
            'pl': 55000,
          },
          explanation:
              'Ativo Circulante: Bancos (10.000) e Estoques (10.000) = 20.000,00. '
              'Ativo Não Circulante: Imobilizado — Máquinas (40.000) e Intangível — Marca (10.000) = 50.000,00. '
              'Passivo Circulante: Fornecedores (15.000) = 15.000,00. '
              'Patrimônio Líquido: Capital Social (55.000) = 55.000,00. '
              'Total do Ativo = 70.000,00 e Total do Passivo + PL = 70.000,00.',
        ),

        MatchSumQuestion(
          id: 'n1_sum_bp10',
          text: 'Classifique as contas no Balanço Patrimonial e observe os totais.',
          items: [
            MatchSumItem(id: 'g1', label: 'Caixa', value: 10000),
            MatchSumItem(id: 'g2', label: 'Clientes', value: 10000),
            MatchSumItem(id: 'g3', label: 'Equipamentos', value: 30000),
            MatchSumItem(id: 'g4', label: 'Patente', value: 20000),
            MatchSumItem(id: 'g5', label: 'Fornecedores', value: 25000),
            MatchSumItem(id: 'g6', label: 'Capital Social', value: 45000),
          ],
          targets: [
            MatchTarget(id: 'ac', label: 'Ativo Circulante'),
            MatchTarget(
              id: 'anc',
              label: 'Ativo Não Circulante',
              subs: [
                MatchTarget(id: 'anc_imob', label: 'Imobilizado'),
                MatchTarget(id: 'anc_int', label: 'Intangível'),
              ],
            ),
            MatchTarget(id: 'pc', label: 'Passivo Circulante'),
            MatchTarget(id: 'pl', label: 'Patrimônio Líquido'),
          ],
          correctMap: {
            'g1': 'ac',
            'g2': 'ac',
            'g3': 'anc_imob',
            'g4': 'anc_int',
            'g5': 'pc',
            'g6': 'pl',
          },
          expectedTargetTotals: {
            'ac': 20000,
            'anc_imob': 30000,
            'anc_int': 20000,
            'anc': 50000,
            'pc': 25000,
            'pl': 45000,
          },
          explanation:
              'Ativo Circulante: Caixa (10.000) e Clientes (10.000) = 20.000,00. '
              'Ativo Não Circulante: Imobilizado — Equipamentos (30.000) e Intangível — Patente (20.000) = 50.000,00. '
              'Passivo Circulante: Fornecedores (25.000) = 25.000,00. '
              'Patrimônio Líquido: Capital Social (45.000) = 45.000,00. '
              'Total do Ativo = 70.000,00 e Total do Passivo + PL = 70.000,00.',
        ),
      ],
    ),
  ],
);