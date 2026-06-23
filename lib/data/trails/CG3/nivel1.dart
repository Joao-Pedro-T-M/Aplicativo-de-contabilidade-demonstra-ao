// substitua/cole este Trail onde achar melhor (ex.: dentro de sample_course.dart ou em lib/data/trails/nivel1.dart)
import '../../../models/course_models.dart';

final Trail nivel1 = Trail(
  id: 'nivel1',
  title: 'Ativos',
  description: 'Questões introdutórias sobre classificação e conceitos de ativo.',
  lessons: [
    Lesson(
      id: 'n1l1',
      title: 'Ativos',
      questions: [
        Question(
          id: 'n1q1',
          text: 'Na contabilidade, o que compõe o Ativo de uma entidade?',
          options: [
            'Apenas os bens tangíveis da empresa',
            'Conjunto de bens, direitos e recursos controlados com benefício econômico',
            'Somente o dinheiro em caixa',
            'As obrigações com terceiros',
          ],
          correctIndex: 1,
          explanation: 'Ativo engloba bens, direitos e outros recursos controlados que trazem benefícios econômicos futuros.',
        ),
        Question(
          id: 'n1q2',
          text: 'Qual das alternativas abaixo é uma conta tipicamente classificada como Ativo Circulante?',
          options: [
            'Empréstimos LP',
            'Capital Social',
            'Caixa e equivalentes de caixa',
            'Provisões para contingências',
          ],
          correctIndex: 2,
          explanation: 'Caixa e equivalentes são disponibilidades realizáveis no curto prazo, portanto Ativo Circulante.',
        ),
        Question(
          id: 'n1q3',
          text: 'Como é classificado um terreno que a empresa mantém para uso permanente?',
          options: [
            'Ativo Circulante',
            'Ativo Não Circulante — Imobilizado',
            'Passivo Não Circulante',
            'Resultado do período',
          ],
          correctIndex: 1,
          explanation: 'Terrenos de uso permanente integram o Imobilizado, que é Ativo Não Circulante.',
        ),
        Question(
          id: 'n1q4',
          text: 'Quando uma conta de Ativo aumenta, qual é a operação contábil correta em partidas dobradas?',
          options: [
            'Creditar a conta de Ativo',
            'Debitar a conta de Ativo',
            'Registrar somente no razão sem débito/crédito',
            'Lançar como receita',
          ],
          correctIndex: 1,
          explanation: 'No sistema de partidas dobradas, aumentos em contas de Ativo são registrados como débitos.',
        ),
        Question(
          id: 'n1q5',
          text: 'Contas a Receber representam, para a empresa, principalmente:',
          options: [
            'Uma obrigação com fornecedores',
            'Um direito a receber valor no futuro (Ativo)',
            'Uma reserva de lucro',
            'Uma conta de resultado',
          ],
          correctIndex: 1,
          explanation: 'Contas a Receber são direitos decorrentes de vendas a prazo — classificadas no Ativo.',
        ),
        Question(
          id: 'n1q6',
          text: 'Qual item abaixo NÃO pertence ao Ativo da empresa?',
          options: [
            'Estoques',
            'Máquinas e equipamentos',
            'Fornecedores a pagar',
            'Contas a Receber',
          ],
          correctIndex: 2,
          explanation: 'Fornecedores a pagar são obrigações (Passivo), não fazem parte do Ativo.',
        ),
        Question(
          id: 'n1q7',
          text: 'A conta "Depreciação Acumulada" é geralmente apresentada como:',
          options: [
            'Um ativo corrente',
            'Uma receita diferida',
            'Uma conta retificadora do ativo (reduz o valor do Imobilizado)',
            'Um passivo exigível',
          ],
          correctIndex: 2,
          explanation: 'Depreciação acumulada é conta redutora do ativo imobilizado, refletindo perda de valor pelo uso.',
        ),
        Question(
          id: 'n1q8',
          text: 'Estoques são normalmente classificados como:',
          options: [
            'Ativo Não Circulante — Imobilizado',
            'Ativo Circulante',
            'Passivo Circulante',
            'Patrimônio Líquido',
          ],
          correctIndex: 1,
          explanation: 'Estoques esperam ser vendidos ou consumidos no ciclo operacional — por isso são AC.',
        ),
        Question(
          id: 'n1q9',
          text: 'Uma contribuição feita por sócios e não resgatável é classificada como:',
          options: [
            'Ativo',
            'Passivo Circulante',
            'Patrimônio Líquido',
            'Receita do período',
          ],
          correctIndex: 2,
          explanation: 'Contribuições não resgatáveis aumentam o Patrimônio Líquido, não o Ativo diretamente.',
        ),
        Question(
          id: 'n1q10',
          text: 'Qual alternativa define melhor o Ativo Não Circulante?',
          options: [
            'Recursos que serão realizados no exercício seguinte',
            'Recursos não destinados à venda e com vida útil longa (ex.: imobilizado, intangível)',
            'Obrigações financeiras a longo prazo',
            'Despesas já incorridas no período',
          ],
          correctIndex: 1,
          explanation: 'Ativo Não Circulante são itens com prazo de realização mais longo e uso contínuo na empresa.',
        ),
      ],
    ),
  ],
);