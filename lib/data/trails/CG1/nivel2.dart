// lib/data/trails/nivel2.dart
import '../../../models/course_models.dart';

final Trail nivel2 = Trail(
  id: 'nivel2',
  title: 'Passivos',
  description: 'Questões sobre classificação, mensuração e características de passivos.',
  lessons: [
    Lesson(
      id: 'n2l1',
      title: 'Passivos',
      questions: [
        Question(
          id: 'n2q1',
          text: 'O que caracteriza um passivo na contabilidade?',
          options: [
            'Um direito a receber valor no futuro',
            'Uma obrigação presente da entidade que resulta em saída de recursos',
            'Um aumento no patrimônio líquido',
            'Uma receita diferida',
          ],
          correctIndex: 1,
          explanation: 'Passivo é uma obrigação presente que provavelmente exigirá saída de recursos econômicos no futuro.',
        ),
        Question(
          id: 'n2q2',
          text: 'Qual a diferença principal entre Passivo Circulante e Passivo Não Circulante?',
          options: [
            'Circulante são receitas; Não Circulante são despesas',
            'Circulante vence no curto prazo; Não Circulante vence após o exercício seguinte',
            'Não Circulante é inventário; Circulante é imobilizado',
            'Não existe diferença contábil entre eles',
          ],
          correctIndex: 1,
          explanation: 'Passivo Circulante refere-se a obrigações exigíveis no curto prazo; o Não Circulante ao longo prazo.',
        ),
        Question(
          id: 'n2q3',
          text: 'Empréstimos bancários com vencimento em 18 meses devem ser classificados como:',
          options: [
            'Ativo Circulante',
            'Passivo Circulante',
            'Passivo Não Circulante (exigível a longo prazo)',
            'Patrimônio Líquido',
          ],
          correctIndex: 2,
          explanation: 'Vencimentos após o exercício seguinte caracterizam passivo não circulante (longo prazo).',
        ),
        Question(
          id: 'n2q4',
          text: 'Provisões (ex.: provisão para garantias) são registradas pois:',
          options: [
            'Representam ativos intangíveis',
            'São estimativas de obrigações presentes prováveis e mensuráveis',
            'Aumentam automaticamente o patrimônio líquido',
            'Devem ser classificadas como receita',
          ],
          correctIndex: 1,
          explanation: 'Provisões reconhecem obrigações prováveis cuja quantia ou prazo é incerto, mas pode ser estimada.',
        ),
        Question(
          id: 'n2q5',
          text: 'Qual conta melhor representa uma obrigação de curto prazo com fornecedores?',
          options: [
            'Caixa',
            'Contas a Receber',
            'Fornecedores (Passivo Circulante)',
            'Reserva de Lucros',
          ],
          correctIndex: 2,
          explanation: 'Dívidas com fornecedores são obrigações de curto prazo e ficam no Passivo Circulante.',
        ),
        Question(
          id: 'n2q6',
          text: 'Como se classifica uma dívida que a empresa tem e que foi renegociada para pagamento em 36 meses?',
          options: [
            'Passivo Não Circulante (reclassificado conforme prazo renegociado)',
            'Ativo Não Circulante',
            'Passivo Circulante (sempre curto prazo)',
            'Patrimônio Líquido',
          ],
          correctIndex: 0,
          explanation: 'Se o prazo foi alongado para 36 meses, a obrigação deve ser apresentada como passivo de longo prazo.',
        ),
        Question(
          id: 'n2q7',
          text: 'Receita recebida antecipadamente (adiantamento de clientes) deve ser apresentada como:',
          options: [
            'Receita do período',
            'Ativo Circulante',
            'Passivo (receita diferida) até o serviço ser prestado',
            'Patrimônio Líquido',
          ],
          correctIndex: 2,
          explanation: 'Valores recebidos antecipadamente representam obrigações até que a empresa entregue bens/serviços.',
        ),
        Question(
          id: 'n2q8',
          text: 'Juros a pagar acumulados no fim do período são contabilizados em:',
          options: [
            'Ativo Não Circulante',
            'Passivo Circulante — Juros a Pagar',
            'Redução do estoque',
            'Reserva de lucros retidos',
          ],
          correctIndex: 1,
          explanation: 'Juros incorridos e ainda não pagos são obrigações de curto prazo (juros a pagar).',
        ),
        Question(
          id: 'n2q9',
          text: 'Uma obrigação contingente provável de pagamento e mensurável deve ser:',
          options: [
            'Reconhecida como provisão (passivo) nas demonstrações',
            'Ignorada até o pagamento efetivo',
            'Registrada como aumento de ativo',
            'Apresentada como receita diferida',
          ],
          correctIndex: 0,
          explanation: 'Quando provável e mensurável, a obrigação contingente deve ser reconhecida por provisão no passivo.',
        ),
        Question(
          id: 'n2q10',
          text: 'Qual elemento distingue um passivo financeiro (ex.: empréstimo) de uma obrigação operacional (ex.: salários a pagar)?',
          options: [
            'Passivos financeiros envolvem instrumentos financeiros e custo explícito de juros; operacionais advêm do negócio corrente',
            'Não há diferença — ambos são sempre classificados como patrimônio',
            'Passivos operacionais sempre são não circulantes',
            'Passivos financeiros não geram saída de caixa',
          ],
          correctIndex: 0,
          explanation: 'Passivos financeiros são originados de instrumentos financeiros (juros, contratos de dívida); operacionais decorrem da atividade operacional corrente.',
        ),
      ],
    ),
  ],
);