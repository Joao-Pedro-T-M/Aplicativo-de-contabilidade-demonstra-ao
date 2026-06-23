import 'package:equition/models/course_models.dart';
import 'package:equition/widgets/drag_inventory_method_widget.dart';

final Trail ueps_10_questoes = Trail(
  id: 'ueps_10_questoes',
  title: 'UEPS',
  description:
      '10 questões focadas exclusivamente em UEPS, organizadas do nível fácil ao difícil.',
  lessons: [
    Lesson(
      id: 'l_ueps_10_questoes',
      title: 'UEPS - Nível fácil ao difícil',
      questions: [
        InventoryMethodQuestion(
          id: 'ueps_q1_facil',
          text:
              'A empresa Alfa apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 12 unidades a R\$ 18,00 cada.\n'
              '- 05/01 - Compra de 8 unidades a R\$ 20,00 cada.\n'
              '- 10/01 - Venda de 10 unidades.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps1_u1',
              label: 'Estoque inicial: 12 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 18,00.',
            ),
            InventoryMethodItem(
              id: 'ueps1_u2',
              label: 'Compra de 8 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 20,00.',
            ),
            InventoryMethodItem(
              id: 'ueps1_u3',
              label: 'Venda de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_1', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_ueps_1', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'ueps1_u1': 'entrada_ueps_1',
            'ueps1_u2': 'entrada_ueps_1',
            'ueps1_u3': 'saida_ueps_1',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_1': 'Lançamento das entradas no estoque.',
            'saida_ueps_1': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_1'],
            'Saída': ['saida_ueps_1'],
          },
          explanation:
              'No UEPS, a venda sai pelos custos mais recentes. O estoque final fica em 180,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q2_facil',
          text:
              'A empresa Beta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 15 unidades a R\$ 22,00 cada.\n'
              '- 04/01 - Compra de 5 unidades a R\$ 24,00 cada.\n'
              '- 09/01 - Venda de 12 unidades.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps2_u1',
              label: 'Estoque inicial: 15 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 22,00.',
            ),
            InventoryMethodItem(
              id: 'ueps2_u2',
              label: 'Compra de 5 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 24,00.',
            ),
            InventoryMethodItem(
              id: 'ueps2_u3',
              label: 'Venda de 12 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_2', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_ueps_2', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'ueps2_u1': 'entrada_ueps_2',
            'ueps2_u2': 'entrada_ueps_2',
            'ueps2_u3': 'saida_ueps_2',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_2': 'Lançamento das entradas no estoque.',
            'saida_ueps_2': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_2'],
            'Saída': ['saida_ueps_2'],
          },
          explanation:
              'No UEPS, a saída consome primeiro as unidades mais recentes. O estoque final fica em 176,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q3_facil',
          text:
              'A empresa Gama apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 10 unidades a R\$ 30,00 cada.\n'
              '- 06/01 - Compra de 10 unidades a R\$ 34,00 cada.\n'
              '- 12/01 - Venda de 12 unidades.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps3_u1',
              label: 'Estoque inicial: 10 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 30,00.',
            ),
            InventoryMethodItem(
              id: 'ueps3_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 34,00.',
            ),
            InventoryMethodItem(
              id: 'ueps3_u3',
              label: 'Venda de 12 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_3', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_ueps_3', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'ueps3_u1': 'entrada_ueps_3',
            'ueps3_u2': 'entrada_ueps_3',
            'ueps3_u3': 'saida_ueps_3',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_3': 'Lançamento das entradas no estoque.',
            'saida_ueps_3': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_3'],
            'Saída': ['saida_ueps_3'],
          },
          explanation:
              'No UEPS, a venda consome primeiro as unidades compradas por último. O estoque final fica em 402,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q4_media',
          text:
              'A empresa Delta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 15 unidades a R\$ 40,00 cada.\n'
              '- 05/01 - Compra de 10 unidades a R\$ 44,00 cada.\n'
              '- 08/01 - Devolução de 4 unidades da compra de 05/01.\n'
              '- 14/01 - Venda de 12 unidades.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps4_u1',
              label: 'Estoque inicial: 15 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 40,00.',
            ),
            InventoryMethodItem(
              id: 'ueps4_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 44,00.',
            ),
            InventoryMethodItem(
              id: 'ueps4_u3',
              label: 'Devolução de 4 unidades da compra',
              correctMethod: 'ueps',
              detail: 'Retirada da devolução da compra.',
            ),
            InventoryMethodItem(
              id: 'ueps4_u4',
              label: 'Venda de 12 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_4', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'devolucao_compra_ueps_4', label: 'Etapa 2 — Devolução de compra'),
            MatchTarget(id: 'saida_ueps_4', label: 'Etapa 3 — Venda/saída'),
          ],
          correctMap: {
            'ueps4_u1': 'entrada_ueps_4',
            'ueps4_u2': 'entrada_ueps_4',
            'ueps4_u3': 'devolucao_compra_ueps_4',
            'ueps4_u4': 'saida_ueps_4',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_4': 'Lançamento das entradas no estoque.',
            'devolucao_compra_ueps_4': 'Retirada da devolução da compra.',
            'saida_ueps_4': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_4'],
            'Ajustes': ['devolucao_compra_ueps_4'],
            'Saída': ['saida_ueps_4'],
          },
          explanation:
              'No UEPS, a devolução da compra ajusta o lote mais recente antes da venda. O estoque final fica em 165,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q5_media',
          text:
              'A empresa Épsilon apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 20 unidades a R\$ 30,00 cada.\n'
              '- 03/01 - Compra de 10 unidades a R\$ 34,00 cada.\n'
              '- 07/01 - Compra de 5 unidades a R\$ 36,00 cada.\n'
              '- 11/01 - Venda de 18 unidades.\n'
              '- 15/01 - Compra de 6 unidades a R\$ 38,00 cada.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps5_u1',
              label: 'Estoque inicial: 20 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 30,00.',
            ),
            InventoryMethodItem(
              id: 'ueps5_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 34,00.',
            ),
            InventoryMethodItem(
              id: 'ueps5_u3',
              label: 'Compra de 5 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 36,00.',
            ),
            InventoryMethodItem(
              id: 'ueps5_u4',
              label: 'Venda de 18 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
            InventoryMethodItem(
              id: 'ueps5_u5',
              label: 'Compra de 6 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 38,00.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_5', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_ueps_5', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'ueps5_u1': 'entrada_ueps_5',
            'ueps5_u2': 'entrada_ueps_5',
            'ueps5_u3': 'entrada_ueps_5',
            'ueps5_u4': 'saida_ueps_5',
            'ueps5_u5': 'entrada_ueps_5',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_5': 'Lançamento das entradas no estoque.',
            'saida_ueps_5': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_5'],
            'Saída': ['saida_ueps_5'],
          },
          explanation:
              'No UEPS, a venda consome primeiro os lotes mais recentes. O estoque final fica em 460,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q6_media',
          text:
              'A empresa Zeta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 30 unidades a R\$ 12,00 cada.\n'
              '- 04/01 - Compra de 20 unidades a R\$ 14,00 cada.\n'
              '- 08/01 - Venda de 25 unidades.\n'
              '- 12/01 - Compra de 10 unidades a R\$ 16,00 cada.\n'
              '- 16/01 - Venda de 5 unidades.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps6_u1',
              label: 'Estoque inicial: 30 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 12,00.',
            ),
            InventoryMethodItem(
              id: 'ueps6_u2',
              label: 'Compra de 20 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 14,00.',
            ),
            InventoryMethodItem(
              id: 'ueps6_u3',
              label: 'Venda de 25 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
            InventoryMethodItem(
              id: 'ueps6_u4',
              label: 'Compra de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 16,00.',
            ),
            InventoryMethodItem(
              id: 'ueps6_u5',
              label: 'Venda de 5 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_6', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_ueps_6', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'ueps6_u1': 'entrada_ueps_6',
            'ueps6_u2': 'entrada_ueps_6',
            'ueps6_u3': 'saida_ueps_6',
            'ueps6_u4': 'entrada_ueps_6',
            'ueps6_u5': 'saida_ueps_6',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_6': 'Lançamento das entradas no estoque.',
            'saida_ueps_6': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_6'],
            'Saída': ['saida_ueps_6'],
          },
          explanation:
              'No UEPS, as saídas saem pelos custos mais recentes e o saldo final preserva os lotes mais antigos. O estoque final fica em 400,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q7_dificil',
          text:
              'A empresa Teta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 12 unidades a R\$ 50,00 cada.\n'
              '- 05/01 - Compra de 8 unidades a R\$ 54,00 cada.\n'
              '- 09/01 - Compra de 10 unidades a R\$ 58,00 cada.\n'
              '- 11/01 - Devolução de 3 unidades da compra de 09/01.\n'
              '- 15/01 - Venda de 20 unidades.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps7_u1',
              label: 'Estoque inicial: 12 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 50,00.',
            ),
            InventoryMethodItem(
              id: 'ueps7_u2',
              label: 'Compra de 8 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 54,00.',
            ),
            InventoryMethodItem(
              id: 'ueps7_u3',
              label: 'Compra de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 58,00.',
            ),
            InventoryMethodItem(
              id: 'ueps7_u4',
              label: 'Devolução de 3 unidades da compra',
              correctMethod: 'ueps',
              detail: 'Retirada da devolução da compra.',
            ),
            InventoryMethodItem(
              id: 'ueps7_u5',
              label: 'Venda de 20 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_7', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'devolucao_compra_ueps_7', label: 'Etapa 2 — Devolução de compra'),
            MatchTarget(id: 'saida_ueps_7', label: 'Etapa 3 — Venda/saída'),
          ],
          correctMap: {
            'ueps7_u1': 'entrada_ueps_7',
            'ueps7_u2': 'entrada_ueps_7',
            'ueps7_u3': 'entrada_ueps_7',
            'ueps7_u4': 'devolucao_compra_ueps_7',
            'ueps7_u5': 'saida_ueps_7',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_7': 'Lançamento das entradas no estoque.',
            'devolucao_compra_ueps_7': 'Retirada da devolução da compra.',
            'saida_ueps_7': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_7'],
            'Ajustes': ['devolucao_compra_ueps_7'],
            'Saída': ['saida_ueps_7'],
          },
          explanation:
              'No UEPS, a devolução da compra ajusta o lote mais recente e a venda consome primeiro esses lotes. O estoque final fica em 350,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q8_dificil',
          text:
              'A empresa Iota apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 15 unidades a R\$ 22,00 cada.\n'
              '- 04/01 - Compra de 12 unidades a R\$ 24,00 cada.\n'
              '- 07/01 - Compra de 8 unidades a R\$ 27,00 cada.\n'
              '- 10/01 - Devolução de 5 unidades da compra de 07/01.\n'
              '- 14/01 - Venda de 18 unidades.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps8_u1',
              label: 'Estoque inicial: 15 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 22,00.',
            ),
            InventoryMethodItem(
              id: 'ueps8_u2',
              label: 'Compra de 12 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 24,00.',
            ),
            InventoryMethodItem(
              id: 'ueps8_u3',
              label: 'Compra de 8 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 27,00.',
            ),
            InventoryMethodItem(
              id: 'ueps8_u4',
              label: 'Devolução de 5 unidades da compra',
              correctMethod: 'ueps',
              detail: 'Retirada da devolução da compra.',
            ),
            InventoryMethodItem(
              id: 'ueps8_u5',
              label: 'Venda de 18 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_8', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'devolucao_compra_ueps_8', label: 'Etapa 2 — Devolução de compra'),
            MatchTarget(id: 'saida_ueps_8', label: 'Etapa 3 — Venda/saída'),
          ],
          correctMap: {
            'ueps8_u1': 'entrada_ueps_8',
            'ueps8_u2': 'entrada_ueps_8',
            'ueps8_u3': 'entrada_ueps_8',
            'ueps8_u4': 'devolucao_compra_ueps_8',
            'ueps8_u5': 'saida_ueps_8',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_8': 'Lançamento das entradas no estoque.',
            'devolucao_compra_ueps_8': 'Retirada da devolução da compra.',
            'saida_ueps_8': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_8'],
            'Ajustes': ['devolucao_compra_ueps_8'],
            'Saída': ['saida_ueps_8'],
          },
          explanation:
              'No UEPS, a devolução ajusta o lote mais recente antes da saída. O estoque final fica em 264,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q9_dificil',
          text:
              'A empresa Kappa apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 40 unidades a R\$ 25,00 cada.\n'
              '- 03/01 - Compra de 30 unidades a R\$ 28,00 cada.\n'
              '- 08/01 - Venda de 35 unidades.\n'
              '- 12/01 - Compra de 20 unidades a R\$ 30,00 cada.\n'
              '- 18/01 - Venda de 15 unidades.\n'
              '- 22/01 - Compra de 10 unidades a R\$ 32,00 cada.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps9_u1',
              label: 'Estoque inicial: 40 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 25,00.',
            ),
            InventoryMethodItem(
              id: 'ueps9_u2',
              label: 'Compra de 30 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 28,00.',
            ),
            InventoryMethodItem(
              id: 'ueps9_u3',
              label: 'Venda de 35 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
            InventoryMethodItem(
              id: 'ueps9_u4',
              label: 'Compra de 20 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 30,00.',
            ),
            InventoryMethodItem(
              id: 'ueps9_u5',
              label: 'Venda de 15 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
            InventoryMethodItem(
              id: 'ueps9_u6',
              label: 'Compra de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 32,00.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_9', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_ueps_9', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'ueps9_u1': 'entrada_ueps_9',
            'ueps9_u2': 'entrada_ueps_9',
            'ueps9_u3': 'saida_ueps_9',
            'ueps9_u4': 'entrada_ueps_9',
            'ueps9_u5': 'saida_ueps_9',
            'ueps9_u6': 'entrada_ueps_9',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_9': 'Lançamento das entradas no estoque.',
            'saida_ueps_9': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_9'],
            'Saída': ['saida_ueps_9'],
          },
          explanation:
              'No UEPS, as vendas consomem primeiro os lotes mais recentes e o saldo final fica concentrado nos custos antigos. O estoque final fica em 1345,00.',
        ),

        InventoryMethodQuestion(
          id: 'ueps_q10_dificil',
          text:
              'A empresa Lambda apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 18 unidades a R\$ 60,00 cada.\n'
              '- 04/01 - Compra de 12 unidades a R\$ 62,00 cada.\n'
              '- 09/01 - Compra de 10 unidades a R\$ 65,00 cada.\n'
              '- 12/01 - Devolução de 4 unidades da compra de 09/01.\n'
              '- 15/01 - Venda de 15 unidades.\n'
              '- 18/01 - Compra de 8 unidades a R\$ 68,00 cada.\n'
              '- 21/01 - Venda de 10 unidades.\n\n'
              'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'ueps10_u1',
              label: 'Estoque inicial: 18 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 60,00.',
            ),
            InventoryMethodItem(
              id: 'ueps10_u2',
              label: 'Compra de 12 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 62,00.',
            ),
            InventoryMethodItem(
              id: 'ueps10_u3',
              label: 'Compra de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 65,00.',
            ),
            InventoryMethodItem(
              id: 'ueps10_u4',
              label: 'Devolução de 4 unidades da compra',
              correctMethod: 'ueps',
              detail: 'Retirada da devolução da compra.',
            ),
            InventoryMethodItem(
              id: 'ueps10_u5',
              label: 'Venda de 15 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
            InventoryMethodItem(
              id: 'ueps10_u6',
              label: 'Compra de 8 unidades',
              correctMethod: 'ueps',
              detail: 'Preço unitário de R\$ 68,00.',
            ),
            InventoryMethodItem(
              id: 'ueps10_u7',
              label: 'Venda de 10 unidades',
              correctMethod: 'ueps',
              detail: 'Saída pelo custo das unidades mais recentes.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_ueps_10', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'devolucao_compra_ueps_10', label: 'Etapa 2 — Devolução de compra'),
            MatchTarget(id: 'saida_ueps_10', label: 'Etapa 3 — Venda/saída'),
          ],
          correctMap: {
            'ueps10_u1': 'entrada_ueps_10',
            'ueps10_u2': 'entrada_ueps_10',
            'ueps10_u3': 'entrada_ueps_10',
            'ueps10_u4': 'devolucao_compra_ueps_10',
            'ueps10_u5': 'saida_ueps_10',
            'ueps10_u6': 'entrada_ueps_10',
            'ueps10_u7': 'saida_ueps_10',
          },
          methodNotes: {
            'ueps': 'UEPS: último que entra, primeiro que sai.',
            'entrada_ueps_10': 'Lançamento das entradas no estoque.',
            'devolucao_compra_ueps_10': 'Retirada da devolução da compra.',
            'saida_ueps_10': 'Saída avaliada pelos custos mais recentes.',
          },
          groups: {
            'Entradas': ['entrada_ueps_10'],
            'Ajustes': ['devolucao_compra_ueps_10'],
            'Saída': ['saida_ueps_10'],
          },
          explanation:
              'No UEPS, as saídas consomem os custos mais novos, a devolução ajusta o lote mais recente e o saldo final preserva os custos antigos. O estoque final fica em 1142,00.',
        ),
      ],
    ),
  ],
);