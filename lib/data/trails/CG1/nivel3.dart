// lib/data/trails/nivel3.dart
import '../../../models/course_models.dart';

final Trail nivel3 = Trail(
  id: 'nivel3',
  title: 'Patrimônio Líquido',
  description: 'Questões avançadas sobre composição, mensuração e movimentações do Patrimônio Líquido.',
  lessons: [
    Lesson(
      id: 'n3l1',
      title: 'Patrimônio Líquido',
      questions: [
        Question(
          id: 'n3q1',
          text: 'O que representa o Patrimônio Líquido de uma entidade?',
          options: [
            'A diferença entre Ativo e Passivo (recursos próprios da entidade)',
            'O total de receitas do período',
            'Somente o capital social integralizado',
            'O total de todas as dívidas da empresa',
          ],
          correctIndex: 0,
          explanation: 'Patrimônio Líquido é, conceitualmente, Ativo menos Passivo — os recursos pertencentes aos proprietários.',
        ),
        Question(
          id: 'n3q2',
          text: 'O que é capital social?',
          options: [
            'O montante subscrito e integralizado pelos sócios/acionistas como aporte inicial/extra',
            'Reservas constituídas a partir de lucros',
            'Resultados negativos acumulados',
            'Uma conta de ativo imobilizado',
          ],
          correctIndex: 0,
          explanation: 'Capital social é o valor aportado pelos sócios/acionistas que representa sua participação na empresa.',
        ),
        Question(
          id: 'n3q3',
          text: 'Qual das alternativas identifica corretamente uma reserva de lucros?',
          options: [
            'Reserva legal constituída com parcela do lucro para proteção do capital',
            'Ágio por emissão de ações',
            'Ações em tesouraria',
            'Prejuízos acumulados',
          ],
          correctIndex: 0,
          explanation: 'Reservas de lucros (ex.: legal, estatutária, estatística) são constituídas a partir do lucro da empresa.',
        ),
        Question(
          id: 'n3q4',
          text: 'Como são classificados os "lucros acumulados" quando não distribuídos?',
          options: [
            'Parte do Patrimônio Líquido — representam lucros retidos para reinvestimento',
            'Passivo Circulante',
            'Ativo Não Circulante',
            'Receitas diferidas',
          ],
          correctIndex: 0,
          explanation: 'Lucros acumulados são resultados retidos que integram o PL para financiar a empresa ou distribuir futuramente.',
        ),
        Question(
          id: 'n3q5',
          text: 'Quando os dividendos passam a ser reconhecidos como passivo na contabilidade?',
          options: [
            'Quando são aprovados pela assembleia/órgão competente (ou declarados formalmente)',
            'No encerramento do exercício, automaticamente',
            'Somente quando pagos em dinheiro',
            'Nunca — são sempre uma redução direta do capital social',
          ],
          correctIndex: 0,
          explanation: 'Após a declaração/aprovação formal, os dividendos tornam-se obrigação (passivo) até o pagamento.',
        ),
        Question(
          id: 'n3q6',
          text: 'A incorporação de reservas ao capital social (aumento por incorporação) tem o efeito de:',
          options: [
            'Transferir valores de reservas para capital social sem alterar o total do PL',
            'Reduzir o total do Patrimônio Líquido',
            'Criar um novo passivo exigível',
            'Aumentar o ativo da empresa',
          ],
          correctIndex: 0,
          explanation: 'A incorporação converte reservas em capital (reclassificação dentro do PL), mantendo o total do PL.',
        ),
        Question(
          id: 'n3q7',
          text: 'A posição de "ações em tesouraria" normalmente aparece como:',
          options: [
            'Redutor do Patrimônio Líquido (conta dedutora do PL)',
            'Um ativo circulante',
            'Uma receita excepcional',
            'Um passivo contingente',
          ],
          correctIndex: 0,
          explanation: 'Ações em tesouraria reduzem o PL enquanto estiverem em tesouraria (são apresentadas como dedução do PL).',
        ),
        Question(
          id: 'n3q8',
          text: 'Ganho por reavaliação de ativo (ex.: reavaliação de imóvel) é normalmente reconhecido em:',
          options: [
            'Reserva de reavaliação no Patrimônio Líquido (até realização)',
            'Resultado do período como receita operacional',
            'Passivo Não Circulante',
            'Caixa e equivalentes de caixa',
          ],
          correctIndex: 0,
          explanation: 'A valorização geralmente é registrada em reserva de reavaliação no PL, não como resultado até que seja realizada.',
        ),
        Question(
          id: 'n3q9',
          text: 'O ágio na emissão de ações (preço recebido acima do valor nominal) é tipicamente classificado como:',
          options: [
            'Reserva de capital (fonte de PL vinculada a integralização acima do nominal)',
            'Lucro acumulado',
            'Passivo financeiro',
            'Despesa do exercício',
          ],
          correctIndex: 0,
          explanation: 'O ágio de emissão é contabilizado em reservas de capital (não resultando de lucro operacional).',
        ),
        Question(
          id: 'n3q10',
          text: 'Prejuízos acumulados afetam o Patrimônio Líquido como:',
          options: [
            'Redução do Patrimônio Líquido (conta negativa no PL)',
            'Aumento das reservas de lucros',
            'Conta de ativo realizável a longo prazo',
            'Não impactam o PL até a distribuição',
          ],
          correctIndex: 0,
          explanation: 'Prejuízos acumulados diminuem o PL e são apresentados como conta redutora do patrimônio próprio.',
        ),
      ],
    ),
  ],
);