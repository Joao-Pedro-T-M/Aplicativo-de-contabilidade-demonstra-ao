import '../../../models/course_models.dart';

final Trail padrao2 = Trail(
  id: 'padrao2',
  title: 'Equação Patrimonial',
  description: 'Questões sobre a equação fundamental da contabilidade: Ativo = Passivo + Patrimônio Líquido.',
  lessons: [
    Lesson(
      id: 'n3l2',
      title: 'Cálculo do Patrimônio Líquido',
      questions: [

        Question(
          id: 'n3q11',
          text: 'O Balanço Patrimonial da empresa Atlas S.A. apresentou um ativo de R\$ 950.000,00 e um passivo de R\$ 700.000,00. Em relação ao patrimônio líquido da empresa, é correto afirmar que:',
          options: [
            'apresentou um valor positivo de R\$ 1.650.000,00.',
            'apresentou um valor positivo de R\$ 250.000,00.',
            'apresentou um valor negativo de R\$ 250.000,00.',
            'apresentou valor igual a zero.',
          ],
          correctIndex: 1,
          explanation: 'Ativo = Passivo + PL\n950.000 = 700.000 + PL\nPL = 250.000',
        ),

        Question(
          id: 'n3q12',
          text: 'A empresa Horizonte Ltda. apresentou ativo total de R\$ 400.000,00 e passivo total de R\$ 520.000,00. O patrimônio líquido é:',
          options: [
            'positivo em R\$ 120.000,00.',
            'negativo em R\$ 120.000,00.',
            'igual a R\$ 520.000,00.',
            'igual a zero.',
          ],
          correctIndex: 1,
          explanation: 'Ativo = Passivo + PL\n400.000 = 520.000 + PL\nPL = -120.000',
        ),

        Question(
          id: 'n3q13',
          text: 'A empresa Solaris apresentou ativo de R\$ 1.200.000,00 e passivo de R\$ 1.200.000,00. Nesse caso, o patrimônio líquido:',
          options: [
            'é positivo em R\$ 1.200.000,00.',
            'é negativo em R\$ 1.200.000,00.',
            'é igual a zero.',
            'é positivo em R\$ 2.400.000,00.',
          ],
          correctIndex: 2,
          explanation: 'Ativo = Passivo + PL\n1.200.000 = 1.200.000 + PL\nPL = 0',
        ),

        Question(
          id: 'n3q14',
          text: 'O Balanço da empresa Delta Ltda. apresentou ativo de R\$ 760.000,00 e passivo de R\$ 500.000,00. O patrimônio líquido é:',
          options: [
            'R\$ 260.000 positivo.',
            'R\$ 260.000 negativo.',
            'R\$ 500.000 positivo.',
            'R\$ 1.260.000 positivo.',
          ],
          correctIndex: 0,
          explanation: 'Ativo = Passivo + PL\n760.000 = 500.000 + PL\nPL = 260.000',
        ),

        Question(
          id: 'n3q15',
          text: 'A empresa Litoral S.A. apresentou ativo de R\$ 300.000,00 e passivo de R\$ 450.000,00. O patrimônio líquido da empresa:',
          options: [
            'é negativo em R\$ 150.000,00.',
            'é positivo em R\$ 150.000,00.',
            'é igual a R\$ 300.000,00.',
            'é igual a R\$ 450.000,00.',
          ],
          correctIndex: 0,
          explanation: 'Ativo = Passivo + PL\n300.000 = 450.000 + PL\nPL = -150.000',
        ),

        Question(
          id: 'n3q16',
          text: 'A empresa Horizonte Azul apresentou ativo de R\$ 1.050.000,00 e passivo de R\$ 820.000,00. O patrimônio líquido é:',
          options: [
            'R\$ 230.000 positivo.',
            'R\$ 230.000 negativo.',
            'R\$ 820.000 positivo.',
            'R\$ 1.870.000 positivo.',
          ],
          correctIndex: 0,
          explanation: 'Ativo = Passivo + PL\n1.050.000 = 820.000 + PL\nPL = 230.000',
        ),

        Question(
          id: 'n3q17',
          text: 'A empresa Monte Verde apresentou ativo total de R\$ 680.000,00 e passivo total de R\$ 900.000,00. Nesse caso, o patrimônio líquido é:',
          options: [
            'positivo em R\$ 220.000.',
            'negativo em R\$ 220.000.',
            'igual a R\$ 680.000.',
            'igual a R\$ 900.000.',
          ],
          correctIndex: 1,
          explanation: 'Ativo = Passivo + PL\n680.000 = 900.000 + PL\nPL = -220.000',
        ),

        Question(
          id: 'n3q18',
          text: 'O balanço da empresa Prisma indicou ativo de R\$ 540.000,00 e passivo de R\$ 300.000,00. O patrimônio líquido corresponde a:',
          options: [
            'R\$ 240.000 positivo.',
            'R\$ 240.000 negativo.',
            'R\$ 840.000 positivo.',
            'R\$ 300.000 positivo.',
          ],
          correctIndex: 0,
          explanation: 'Ativo = Passivo + PL\n540.000 = 300.000 + PL\nPL = 240.000',
        ),

        Question(
          id: 'n3q19',
          text: 'A empresa Orion Ltda. apresentou ativo total de R\$ 900.000,00 e passivo total de R\$ 1.050.000,00. O patrimônio líquido da empresa é:',
          options: [
            'positivo em R\$ 150.000.',
            'negativo em R\$ 150.000.',
            'igual a R\$ 900.000.',
            'igual a R\$ 1.050.000.',
          ],
          correctIndex: 1,
          explanation: 'Ativo = Passivo + PL\n900.000 = 1.050.000 + PL\nPL = -150.000',
        ),

        Question(
          id: 'n3q20',
          text: 'O Balanço da empresa Aurora apresentou ativo de R\$ 1.500.000,00 e passivo de R\$ 1.100.000,00. O patrimônio líquido é:',
          options: [
            'R\$ 400.000 positivo.',
            'R\$ 400.000 negativo.',
            'R\$ 1.100.000 positivo.',
            'R\$ 2.600.000 positivo.',
          ],
          correctIndex: 0,
          explanation: 'Ativo = Passivo + PL\n1.500.000 = 1.100.000 + PL\nPL = 400.000',
        ),

      ],
    ),
  ],
);