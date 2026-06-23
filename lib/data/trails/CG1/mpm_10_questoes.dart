import 'package:equition/models/course_models.dart';
import 'package:equition/widgets/drag_inventory_method_widget.dart';

final Trail mpm_10_questoes = Trail(
  id: 'mpm_10_questoes',
  title: 'MPM',
  description:
      '10 questões focadas exclusivamente em MPM, organizadas do nível fácil ao difícil.',
  lessons: [
    Lesson(
      id: 'l_mpm_10_questoes',
      title: 'MPM - Nível fácil ao difícil',
      questions: [
        InventoryMethodQuestion(
          id: 'mpm_q1_facil',
          text:
              'A empresa Alfa apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 10 unidades a R\$ 20,00 cada.\n'
              '- 05/01 - Compra de 10 unidades a R\$ 30,00 cada.\n'
              '- 10/01 - Venda de 10 unidades.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm1_u1',
              label: 'Estoque inicial: 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 20,00.',
            ),
            InventoryMethodItem(
              id: 'mpm1_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 30,00.',
            ),
            InventoryMethodItem(
              id: 'mpm1_u3',
              label: 'Venda de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_1', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_1', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm1_u1': 'entrada_mpm_1',
            'mpm1_u2': 'entrada_mpm_1',
            'mpm1_u3': 'saida_mpm_1',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_1': 'Lançamento das entradas no estoque.',
            'saida_mpm_1': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_1'],
            'Saída': ['saida_mpm_1'],
          },
          explanation:
              'No MPM, o custo médio passa a ser R\$ 25,00 e o estoque final fica em 250,00.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q2_facil',
          text:
              'A empresa Beta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 12 unidades a R\$ 18,00 cada.\n'
              '- 04/01 - Compra de 12 unidades a R\$ 24,00 cada.\n'
              '- 09/01 - Venda de 6 unidades.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm2_u1',
              label: 'Estoque inicial: 12 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 18,00.',
            ),
            InventoryMethodItem(
              id: 'mpm2_u2',
              label: 'Compra de 12 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 24,00.',
            ),
            InventoryMethodItem(
              id: 'mpm2_u3',
              label: 'Venda de 6 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_2', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_2', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm2_u1': 'entrada_mpm_2',
            'mpm2_u2': 'entrada_mpm_2',
            'mpm2_u3': 'saida_mpm_2',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_2': 'Lançamento das entradas no estoque.',
            'saida_mpm_2': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_2'],
            'Saída': ['saida_mpm_2'],
          },
          explanation:
              'No MPM, o custo médio fica em R\$ 21,00 e o estoque final fica em 378,00.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q3_facil',
          text:
              'A empresa Gama apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 10 unidades a R\$ 25,00 cada.\n'
              '- 06/01 - Compra de 10 unidades a R\$ 35,00 cada.\n'
              '- 12/01 - Venda de 10 unidades.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm3_u1',
              label: 'Estoque inicial: 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 25,00.',
            ),
            InventoryMethodItem(
              id: 'mpm3_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 35,00.',
            ),
            InventoryMethodItem(
              id: 'mpm3_u3',
              label: 'Venda de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_3', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_3', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm3_u1': 'entrada_mpm_3',
            'mpm3_u2': 'entrada_mpm_3',
            'mpm3_u3': 'saida_mpm_3',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_3': 'Lançamento das entradas no estoque.',
            'saida_mpm_3': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_3'],
            'Saída': ['saida_mpm_3'],
          },
          explanation:
              'No MPM, o custo médio é R\$ 30,00 e o estoque final fica em 300,00.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q4_media',
          text:
              'A empresa Delta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 15 unidades a R\$ 40,00 cada.\n'
              '- 05/01 - Compra de 5 unidades a R\$ 44,00 cada.\n'
              '- 08/01 - Compra de 10 unidades a R\$ 44,00 cada.\n'
              '- 14/01 - Venda de 10 unidades.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm4_u1',
              label: 'Estoque inicial: 15 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 40,00.',
            ),
            InventoryMethodItem(
              id: 'mpm4_u2',
              label: 'Compra de 5 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 44,00.',
            ),
            InventoryMethodItem(
              id: 'mpm4_u3',
              label: 'Compra de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 44,00.',
            ),
            InventoryMethodItem(
              id: 'mpm4_u4',
              label: 'Venda de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_4', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_4', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm4_u1': 'entrada_mpm_4',
            'mpm4_u2': 'entrada_mpm_4',
            'mpm4_u3': 'entrada_mpm_4',
            'mpm4_u4': 'saida_mpm_4',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_4': 'Lançamento das entradas no estoque.',
            'saida_mpm_4': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_4'],
            'Saída': ['saida_mpm_4'],
          },
          explanation:
              'No MPM, o custo médio final fica em R\$ 42,00 e o estoque final fica em 840,00.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q5_media',
          text:
              'A empresa Épsilon apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 20 unidades a R\$ 30,00 cada.\n'
              '- 03/01 - Compra de 10 unidades a R\$ 34,00 cada.\n'
              '- 07/01 - Compra de 5 unidades a R\$ 36,00 cada.\n'
              '- 11/01 - Venda de 18 unidades.\n'
              '- 15/01 - Compra de 6 unidades a R\$ 38,00 cada.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm5_u1',
              label: 'Estoque inicial: 20 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 30,00.',
            ),
            InventoryMethodItem(
              id: 'mpm5_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 34,00.',
            ),
            InventoryMethodItem(
              id: 'mpm5_u3',
              label: 'Compra de 5 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 36,00.',
            ),
            InventoryMethodItem(
              id: 'mpm5_u4',
              label: 'Venda de 18 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
            InventoryMethodItem(
              id: 'mpm5_u5',
              label: 'Compra de 6 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 38,00.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_5', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_5', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm5_u1': 'entrada_mpm_5',
            'mpm5_u2': 'entrada_mpm_5',
            'mpm5_u3': 'entrada_mpm_5',
            'mpm5_u4': 'saida_mpm_5',
            'mpm5_u5': 'entrada_mpm_5',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_5': 'Lançamento das entradas no estoque.',
            'saida_mpm_5': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_5'],
            'Saída': ['saida_mpm_5'],
          },
          explanation:
              'No MPM, o custo médio do saldo após a última compra fica em torno de R\$ 33,57 e o estoque final fica em 772,00.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q6_media',
          text:
              'A empresa Zeta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 30 unidades a R\$ 12,00 cada.\n'
              '- 04/01 - Compra de 20 unidades a R\$ 14,00 cada.\n'
              '- 08/01 - Venda de 25 unidades.\n'
              '- 12/01 - Compra de 10 unidades a R\$ 16,00 cada.\n'
              '- 16/01 - Venda de 5 unidades.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm6_u1',
              label: 'Estoque inicial: 30 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 12,00.',
            ),
            InventoryMethodItem(
              id: 'mpm6_u2',
              label: 'Compra de 20 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 14,00.',
            ),
            InventoryMethodItem(
              id: 'mpm6_u3',
              label: 'Venda de 25 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
            InventoryMethodItem(
              id: 'mpm6_u4',
              label: 'Compra de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 16,00.',
            ),
            InventoryMethodItem(
              id: 'mpm6_u5',
              label: 'Venda de 5 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_6', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_6', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm6_u1': 'entrada_mpm_6',
            'mpm6_u2': 'entrada_mpm_6',
            'mpm6_u3': 'saida_mpm_6',
            'mpm6_u4': 'entrada_mpm_6',
            'mpm6_u5': 'saida_mpm_6',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_6': 'Lançamento das entradas no estoque.',
            'saida_mpm_6': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_6'],
            'Saída': ['saida_mpm_6'],
          },
          explanation:
              'No MPM, o custo médio vai sendo recalculado e o estoque final fica em 411,43.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q7_dificil',
          text:
              'A empresa Teta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 12 unidades a R\$ 50,00 cada.\n'
              '- 05/01 - Compra de 8 unidades a R\$ 54,00 cada.\n'
              '- 09/01 - Compra de 10 unidades a R\$ 58,00 cada.\n'
              '- 15/01 - Venda de 20 unidades.\n'
              '- 18/01 - Compra de 4 unidades a R\$ 60,00 cada.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm7_u1',
              label: 'Estoque inicial: 12 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 50,00.',
            ),
            InventoryMethodItem(
              id: 'mpm7_u2',
              label: 'Compra de 8 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 54,00.',
            ),
            InventoryMethodItem(
              id: 'mpm7_u3',
              label: 'Compra de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 58,00.',
            ),
            InventoryMethodItem(
              id: 'mpm7_u4',
              label: 'Venda de 20 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
            InventoryMethodItem(
              id: 'mpm7_u5',
              label: 'Compra de 4 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 60,00.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_7', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_7', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm7_u1': 'entrada_mpm_7',
            'mpm7_u2': 'entrada_mpm_7',
            'mpm7_u3': 'entrada_mpm_7',
            'mpm7_u4': 'saida_mpm_7',
            'mpm7_u5': 'entrada_mpm_7',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_7': 'Lançamento das entradas no estoque.',
            'saida_mpm_7': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_7'],
            'Saída': ['saida_mpm_7'],
          },
          explanation:
              'No MPM, o custo médio após a última compra fica em R\$ 55,52 e o estoque final fica em 777,33.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q8_dificil',
          text:
              'A empresa Iota apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 15 unidades a R\$ 22,00 cada.\n'
              '- 04/01 - Compra de 12 unidades a R\$ 24,00 cada.\n'
              '- 07/01 - Compra de 8 unidades a R\$ 27,00 cada.\n'
              '- 14/01 - Venda de 18 unidades.\n'
              '- 18/01 - Compra de 5 unidades a R\$ 26,00 cada.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm8_u1',
              label: 'Estoque inicial: 15 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 22,00.',
            ),
            InventoryMethodItem(
              id: 'mpm8_u2',
              label: 'Compra de 12 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 24,00.',
            ),
            InventoryMethodItem(
              id: 'mpm8_u3',
              label: 'Compra de 8 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 27,00.',
            ),
            InventoryMethodItem(
              id: 'mpm8_u4',
              label: 'Venda de 18 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
            InventoryMethodItem(
              id: 'mpm8_u5',
              label: 'Compra de 5 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 26,00.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_8', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_8', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm8_u1': 'entrada_mpm_8',
            'mpm8_u2': 'entrada_mpm_8',
            'mpm8_u3': 'entrada_mpm_8',
            'mpm8_u4': 'saida_mpm_8',
            'mpm8_u5': 'entrada_mpm_8',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_8': 'Lançamento das entradas no estoque.',
            'saida_mpm_8': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_8'],
            'Saída': ['saida_mpm_8'],
          },
          explanation:
              'No MPM, o saldo final após as movimentações fica em 535,09.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q9_dificil',
          text:
              'A empresa Kappa apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 40 unidades a R\$ 25,00 cada.\n'
              '- 03/01 - Compra de 30 unidades a R\$ 28,00 cada.\n'
              '- 08/01 - Venda de 35 unidades.\n'
              '- 12/01 - Compra de 20 unidades a R\$ 30,00 cada.\n'
              '- 18/01 - Venda de 15 unidades.\n'
              '- 22/01 - Compra de 10 unidades a R\$ 32,00 cada.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm9_u1',
              label: 'Estoque inicial: 40 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 25,00.',
            ),
            InventoryMethodItem(
              id: 'mpm9_u2',
              label: 'Compra de 30 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 28,00.',
            ),
            InventoryMethodItem(
              id: 'mpm9_u3',
              label: 'Venda de 35 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
            InventoryMethodItem(
              id: 'mpm9_u4',
              label: 'Compra de 20 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 30,00.',
            ),
            InventoryMethodItem(
              id: 'mpm9_u5',
              label: 'Venda de 15 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
            InventoryMethodItem(
              id: 'mpm9_u6',
              label: 'Compra de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 32,00.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_9', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_9', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm9_u1': 'entrada_mpm_9',
            'mpm9_u2': 'entrada_mpm_9',
            'mpm9_u3': 'saida_mpm_9',
            'mpm9_u4': 'entrada_mpm_9',
            'mpm9_u5': 'saida_mpm_9',
            'mpm9_u6': 'entrada_mpm_9',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_9': 'Lançamento das entradas no estoque.',
            'saida_mpm_9': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_9'],
            'Saída': ['saida_mpm_9'],
          },
          explanation:
              'No MPM, o custo médio vai sendo atualizado até o fim do período e o estoque final fica em 1425,45.',
        ),

        InventoryMethodQuestion(
          id: 'mpm_q10_dificil',
          text:
              'A empresa Lambda apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 18 unidades a R\$ 60,00 cada.\n'
              '- 04/01 - Compra de 12 unidades a R\$ 62,00 cada.\n'
              '- 09/01 - Compra de 10 unidades a R\$ 65,00 cada.\n'
              '- 15/01 - Venda de 15 unidades.\n'
              '- 18/01 - Compra de 8 unidades a R\$ 68,00 cada.\n'
              '- 21/01 - Venda de 10 unidades.\n\n'
              'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'mpm10_u1',
              label: 'Estoque inicial: 18 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 60,00.',
            ),
            InventoryMethodItem(
              id: 'mpm10_u2',
              label: 'Compra de 12 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 62,00.',
            ),
            InventoryMethodItem(
              id: 'mpm10_u3',
              label: 'Compra de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 65,00.',
            ),
            InventoryMethodItem(
              id: 'mpm10_u4',
              label: 'Venda de 15 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
            InventoryMethodItem(
              id: 'mpm10_u5',
              label: 'Compra de 8 unidades',
              correctMethod: 'mpm',
              detail: 'Preço unitário de R\$ 68,00.',
            ),
            InventoryMethodItem(
              id: 'mpm10_u6',
              label: 'Venda de 10 unidades',
              correctMethod: 'mpm',
              detail: 'Saída pelo custo médio ponderado móvel.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_mpm_10', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_mpm_10', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'mpm10_u1': 'entrada_mpm_10',
            'mpm10_u2': 'entrada_mpm_10',
            'mpm10_u3': 'entrada_mpm_10',
            'mpm10_u4': 'saida_mpm_10',
            'mpm10_u5': 'entrada_mpm_10',
            'mpm10_u6': 'saida_mpm_10',
          },
          methodNotes: {
            'mpm': 'MPM: custo médio ponderado móvel.',
            'entrada_mpm_10': 'Lançamento das entradas no estoque.',
            'saida_mpm_10': 'Saída pelo custo médio do período.',
          },
          groups: {
            'Entradas': ['entrada_mpm_10'],
            'Saída': ['saida_mpm_10'],
          },
          explanation:
              'No MPM, o custo médio é recalculado a cada movimentação e o estoque final fica em 1456,84.',
        ),
      ],
    ),
  ],
);