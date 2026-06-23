import '../../../models/course_models.dart';

final Trail padrao3 = Trail(
  id: 'padrao3',
  title: 'DRE — Cálculo de reservas (exercícios)',
  description: 'Exercícios práticos: a partir da Demonstração do Resultado (receitas e despesas) calcule o valor destinado às reservas (80% do lucro, quando houver lucro). Preencha o resultado sem cifrão, sem centavos, sem pontos e sem vírgulas.',
  lessons: [
    Lesson(
      id: 'n3l3',
      title: 'Cálculo de reservas a partir do DRE — 10 questões',
      questions: [

        DREQuestion(
          id: 'n3q21',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 150000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 40000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 10000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 20000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 30000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 5000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 5000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 10000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 120000
Lucro = 150000 - 120000 = 30000
Dividendos (20%) = 6000
Reservas (80%) = 24000
''',
        ),

        DREQuestion(
          id: 'n3q22',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 200000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 60000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 15000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 25000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 40000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 8000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 6000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 12000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 166000
Lucro = 200000 - 166000 = 34000
Dividendos (20%) = 6800
Reservas (80%) = 27200
''',
        ),

        DREQuestion(
          id: 'n3q23',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 95000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 25000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 8000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 12000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 20000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 3000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 4000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 5000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 77000
Lucro = 95000 - 77000 = 18000
Dividendos (20%) = 3600
Reservas (80%) = 14400
''',
        ),

        DREQuestion(
          id: 'n3q24',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 180000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 70000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 12000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 20000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 40000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 6000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 4000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 9000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 161000
Lucro = 180000 - 161000 = 19000
Dividendos (20%) = 3800
Reservas (80%) = 15200
''',
        ),

        DREQuestion(
          id: 'n3q25',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 130000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 50000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 9000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 15000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 25000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 4000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 3000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 6000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 112000
Lucro = 130000 - 112000 = 18000
Dividendos (20%) = 3600
Reservas (80%) = 14400
''',
        ),

        DREQuestion(
          id: 'n3q26',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 220000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 80000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 20000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 30000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 50000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 10000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 5000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 15000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 210000
Lucro = 220000 - 210000 = 10000
Dividendos (20%) = 2000
Reservas (80%) = 8000
''',
        ),

        DREQuestion(
          id: 'n3q27',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 110000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 30000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 6000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 10000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 25000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 4000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 3000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 7000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 85000
Lucro = 110000 - 85000 = 25000
Dividendos (20%) = 5000
Reservas (80%) = 20000
''',
        ),

        DREQuestion(
          id: 'n3q28',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 175000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 55000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 10000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 25000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 35000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 6000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 4000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 8000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 143000
Lucro = 175000 - 143000 = 32000
Dividendos (20%) = 6400
Reservas (80%) = 25600
''',
        ),

        DREQuestion(
          id: 'n3q29',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 140000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 45000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 11000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 18000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 30000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 5000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 3000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 6000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 118000
Lucro = 140000 - 118000 = 22000
Dividendos (20%) = 4400
Reservas (80%) = 17600
''',
        ),

        DREQuestion(
          id: 'n3q30',
          text: 'A empresa apresentou a seguinte DRE: some as despesas informadas, descubra o lucro líquido do período e calcule quanto será destinado às reservas, sabendo que 80% do lucro ficam nas reservas e 20% vão para dividendos.',
          entries: [
            DREEntry(id: 'r', label: 'Receita', value: 90000, isDebit: false),
            DREEntry(id: 'sal', label: 'Despesa com salários', value: 35000, isDebit: true),
            DREEntry(id: 'eng', label: 'Despesa com energia', value: 7000, isDebit: true),
            DREEntry(id: 'al', label: 'Despesa com aluguel', value: 8000, isDebit: true),
            DREEntry(id: 'imp', label: 'Despesa com impostos', value: 20000, isDebit: true),
            DREEntry(id: 'prop', label: 'Despesa com propaganda', value: 2000, isDebit: true),
            DREEntry(id: 'agua', label: 'Despesa com água', value: 3000, isDebit: true),
            DREEntry(id: 'man', label: 'Despesa com manutenção', value: 4000, isDebit: true),
          ],
          correctMap: {
            'r': 'cred',
            'sal': 'deb',
            'eng': 'deb',
            'al': 'deb',
            'imp': 'deb',
            'prop': 'deb',
            'agua': 'deb',
            'man': 'deb',
          },
          explanation: '''
Despesas totais = 79000
Lucro = 90000 - 79000 = 11000
Dividendos (20%) = 2200
Reservas (80%) = 8800
''',
        ),

      ],
    ),
  ],
);