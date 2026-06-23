import 'package:equition/models/course_models.dart';
import 'package:equition/widgets/drag_inventory_method_widget.dart';

final Trail peps_10_questoes = Trail(
  id: 'peps_10_questoes',
  title: 'PEPS',
  description:
      '10 questões focadas exclusivamente em PEPS, organizadas do nível fácil ao difícil.',
  lessons: [
    Lesson(
      id: 'l_peps_10_questoes',
      title: 'PEPS - Nível fácil ao difícil',
      questions: [
        InventoryMethodQuestion(
          id: 'peps_q1_facil',
          text:
              'A empresa Alfa apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 10 unidades a R\$ 20,00 cada.\n'
              '- 05/01 - Compra de 5 unidades a R\$ 24,00 cada.\n'
              '- 10/01 - Venda de 8 unidades.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps1_u1',
              label: 'Estoque inicial: 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 20,00.',
            ),
            InventoryMethodItem(
              id: 'peps1_u2',
              label: 'Compra de 5 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 24,00.',
            ),
            InventoryMethodItem(
              id: 'peps1_u3',
              label: 'Venda de 8 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_1', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_peps_1', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'peps1_u1': 'entrada_peps_1',
            'peps1_u2': 'entrada_peps_1',
            'peps1_u3': 'saida_peps_1',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_1': 'Lançamento das entradas no estoque.',
            'saida_peps_1': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_1'],
            'Saída': ['saida_peps_1'],
          },
          explanation:
              'No PEPS, a venda sai pelos custos mais antigos. O estoque final fica em 160,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q2_facil',
          text:
              'A empresa Beta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 12 unidades a R\$ 18,00 cada.\n'
              '- 04/01 - Compra de 8 unidades a R\$ 20,00 cada.\n'
              '- 09/01 - Venda de 10 unidades.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps2_u1',
              label: 'Estoque inicial: 12 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 18,00.',
            ),
            InventoryMethodItem(
              id: 'peps2_u2',
              label: 'Compra de 8 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 20,00.',
            ),
            InventoryMethodItem(
              id: 'peps2_u3',
              label: 'Venda de 10 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_2', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_peps_2', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'peps2_u1': 'entrada_peps_2',
            'peps2_u2': 'entrada_peps_2',
            'peps2_u3': 'saida_peps_2',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_2': 'Lançamento das entradas no estoque.',
            'saida_peps_2': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_2'],
            'Saída': ['saida_peps_2'],
          },
          explanation:
              'No PEPS, a venda sai pelos custos mais antigos. O estoque final fica em 196,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q3_facil',
          text:
              'A empresa Gama apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 10 unidades a R\$ 25,00 cada.\n'
              '- 06/01 - Compra de 10 unidades a R\$ 35,00 cada.\n'
              '- 12/01 - Venda de 12 unidades.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps3_u1',
              label: 'Estoque inicial: 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 25,00.',
            ),
            InventoryMethodItem(
              id: 'peps3_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 35,00.',
            ),
            InventoryMethodItem(
              id: 'peps3_u3',
              label: 'Venda de 12 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_3', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_peps_3', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'peps3_u1': 'entrada_peps_3',
            'peps3_u2': 'entrada_peps_3',
            'peps3_u3': 'saida_peps_3',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_3': 'Lançamento das entradas no estoque.',
            'saida_peps_3': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_3'],
            'Saída': ['saida_peps_3'],
          },
          explanation:
              'No PEPS, o custo das 10 primeiras unidades é consumido primeiro. O estoque final fica em 240,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q4_media',
          text:
              'A empresa Delta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 15 unidades a R\$ 40,00 cada.\n'
              '- 05/01 - Compra de 10 unidades a R\$ 44,00 cada.\n'
              '- 08/01 - Devolução de 4 unidades da compra de 05/01.\n'
              '- 14/01 - Venda de 12 unidades.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps4_u1',
              label: 'Estoque inicial: 15 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 40,00.',
            ),
            InventoryMethodItem(
              id: 'peps4_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 44,00.',
            ),
            InventoryMethodItem(
              id: 'peps4_u3',
              label: 'Devolução de 4 unidades da compra',
              correctMethod: 'peps',
              detail: 'Retorno ao estoque da mercadoria comprada.',
            ),
            InventoryMethodItem(
              id: 'peps4_u4',
              label: 'Venda de 12 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_4', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'devolucao_compra_peps_4', label: 'Etapa 2 — Devolução de compra'),
            MatchTarget(id: 'saida_peps_4', label: 'Etapa 3 — Venda/saída'),
          ],
          correctMap: {
            'peps4_u1': 'entrada_peps_4',
            'peps4_u2': 'entrada_peps_4',
            'peps4_u3': 'devolucao_compra_peps_4',
            'peps4_u4': 'saida_peps_4',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_4': 'Lançamento das entradas no estoque.',
            'devolucao_compra_peps_4': 'Retirada da devolução da compra.',
            'saida_peps_4': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_4'],
            'Ajustes': ['devolucao_compra_peps_4'],
            'Saída': ['saida_peps_4'],
          },
          explanation:
              'No PEPS, a devolução da compra volta ao estoque pelo mesmo custo. O estoque final fica em 384,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q5_media',
          text:
              'A empresa Épsilon apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 20 unidades a R\$ 30,00 cada.\n'
              '- 03/01 - Compra de 10 unidades a R\$ 34,00 cada.\n'
              '- 07/01 - Compra de 5 unidades a R\$ 36,00 cada.\n'
              '- 11/01 - Venda de 18 unidades.\n'
              '- 15/01 - Compra de 6 unidades a R\$ 38,00 cada.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps5_u1',
              label: 'Estoque inicial: 20 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 30,00.',
            ),
            InventoryMethodItem(
              id: 'peps5_u2',
              label: 'Compra de 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 34,00.',
            ),
            InventoryMethodItem(
              id: 'peps5_u3',
              label: 'Compra de 5 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 36,00.',
            ),
            InventoryMethodItem(
              id: 'peps5_u4',
              label: 'Venda de 18 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
            InventoryMethodItem(
              id: 'peps5_u5',
              label: 'Compra de 6 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 38,00.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_5', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_peps_5', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'peps5_u1': 'entrada_peps_5',
            'peps5_u2': 'entrada_peps_5',
            'peps5_u3': 'entrada_peps_5',
            'peps5_u4': 'saida_peps_5',
            'peps5_u5': 'entrada_peps_5',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_5': 'Lançamento das entradas no estoque.',
            'saida_peps_5': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_5'],
            'Saída': ['saida_peps_5'],
          },
          explanation:
              'No PEPS, a venda consome primeiro os lotes mais antigos. O estoque final fica em 690,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q6_media',
          text:
              'A empresa Zeta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 30 unidades a R\$ 12,00 cada.\n'
              '- 04/01 - Compra de 20 unidades a R\$ 14,00 cada.\n'
              '- 08/01 - Venda de 25 unidades.\n'
              '- 12/01 - Compra de 10 unidades a R\$ 16,00 cada.\n'
              '- 16/01 - Venda de 5 unidades.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps6_u1',
              label: 'Estoque inicial: 30 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 12,00.',
            ),
            InventoryMethodItem(
              id: 'peps6_u2',
              label: 'Compra de 20 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 14,00.',
            ),
            InventoryMethodItem(
              id: 'peps6_u3',
              label: 'Venda de 25 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
            InventoryMethodItem(
              id: 'peps6_u4',
              label: 'Compra de 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 16,00.',
            ),
            InventoryMethodItem(
              id: 'peps6_u5',
              label: 'Venda de 5 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_6', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_peps_6', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'peps6_u1': 'entrada_peps_6',
            'peps6_u2': 'entrada_peps_6',
            'peps6_u3': 'saida_peps_6',
            'peps6_u4': 'entrada_peps_6',
            'peps6_u5': 'saida_peps_6',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_6': 'Lançamento das entradas no estoque.',
            'saida_peps_6': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_6'],
            'Saída': ['saida_peps_6'],
          },
          explanation:
              'No PEPS, a saída sempre começa pelos lotes mais antigos. O estoque final fica em 370,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q7_dificil',
          text:
              'A empresa Teta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 12 unidades a R\$ 50,00 cada.\n'
              '- 05/01 - Compra de 8 unidades a R\$ 54,00 cada.\n'
              '- 09/01 - Compra de 10 unidades a R\$ 58,00 cada.\n'
              '- 11/01 - Devolução de 3 unidades da compra de 09/01.\n'
              '- 15/01 - Venda de 20 unidades.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps7_u1',
              label: 'Estoque inicial: 12 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 50,00.',
            ),
            InventoryMethodItem(
              id: 'peps7_u2',
              label: 'Compra de 8 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 54,00.',
            ),
            InventoryMethodItem(
              id: 'peps7_u3',
              label: 'Compra de 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 58,00.',
            ),
            InventoryMethodItem(
              id: 'peps7_u4',
              label: 'Devolução de 3 unidades da compra',
              correctMethod: 'peps',
              detail: 'Retorno ao estoque da mercadoria comprada.',
            ),
            InventoryMethodItem(
              id: 'peps7_u5',
              label: 'Venda de 20 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_7', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'devolucao_compra_peps_7', label: 'Etapa 2 — Devolução de compra'),
            MatchTarget(id: 'saida_peps_7', label: 'Etapa 3 — Venda/saída'),
          ],
          correctMap: {
            'peps7_u1': 'entrada_peps_7',
            'peps7_u2': 'entrada_peps_7',
            'peps7_u3': 'entrada_peps_7',
            'peps7_u4': 'devolucao_compra_peps_7',
            'peps7_u5': 'saida_peps_7',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_7': 'Lançamento das entradas no estoque.',
            'devolucao_compra_peps_7': 'Retirada da devolução da compra.',
            'saida_peps_7': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_7'],
            'Ajustes': ['devolucao_compra_peps_7'],
            'Saída': ['saida_peps_7'],
          },
          explanation:
              'No PEPS, a devolução da compra volta pelo custo original e a venda sai pelos lotes mais antigos. O estoque final fica em 406,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q8_dificil',
          text:
              'A empresa Iota apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 15 unidades a R\$ 22,00 cada.\n'
              '- 04/01 - Compra de 12 unidades a R\$ 24,00 cada.\n'
              '- 07/01 - Compra de 8 unidades a R\$ 27,00 cada.\n'
              '- 10/01 - Devolução de 5 unidades da compra de 07/01.\n'
              '- 14/01 - Venda de 18 unidades.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps8_u1',
              label: 'Estoque inicial: 15 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 22,00.',
            ),
            InventoryMethodItem(
              id: 'peps8_u2',
              label: 'Compra de 12 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 24,00.',
            ),
            InventoryMethodItem(
              id: 'peps8_u3',
              label: 'Compra de 8 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 27,00.',
            ),
            InventoryMethodItem(
              id: 'peps8_u4',
              label: 'Devolução de 5 unidades da compra',
              correctMethod: 'peps',
              detail: 'Retirada da devolução da compra.',
            ),
            InventoryMethodItem(
              id: 'peps8_u5',
              label: 'Venda de 18 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_8', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'devolucao_compra_peps_8', label: 'Etapa 2 — Devolução de compra'),
            MatchTarget(id: 'saida_peps_8', label: 'Etapa 3 — Venda/saída'),
          ],
          correctMap: {
            'peps8_u1': 'entrada_peps_8',
            'peps8_u2': 'entrada_peps_8',
            'peps8_u3': 'entrada_peps_8',
            'peps8_u4': 'devolucao_compra_peps_8',
            'peps8_u5': 'saida_peps_8',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_8': 'Lançamento das entradas no estoque.',
            'devolucao_compra_peps_8': 'Retirada da devolução da compra.',
            'saida_peps_8': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_8'],
            'Ajustes': ['devolucao_compra_peps_8'],
            'Saída': ['saida_peps_8'],
          },
          explanation:
              'No PEPS, a devolução da compra ajusta o lote mais recente e a venda sai pelos lotes mais antigos. O estoque final fica em 264,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q9_dificil',
          text:
              'A empresa Kappa apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 40 unidades a R\$ 25,00 cada.\n'
              '- 03/01 - Compra de 30 unidades a R\$ 28,00 cada.\n'
              '- 08/01 - Venda de 35 unidades.\n'
              '- 12/01 - Compra de 20 unidades a R\$ 30,00 cada.\n'
              '- 18/01 - Venda de 15 unidades.\n'
              '- 22/01 - Compra de 10 unidades a R\$ 32,00 cada.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps9_u1',
              label: 'Estoque inicial: 40 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 25,00.',
            ),
            InventoryMethodItem(
              id: 'peps9_u2',
              label: 'Compra de 30 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 28,00.',
            ),
            InventoryMethodItem(
              id: 'peps9_u3',
              label: 'Venda de 35 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
            InventoryMethodItem(
              id: 'peps9_u4',
              label: 'Compra de 20 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 30,00.',
            ),
            InventoryMethodItem(
              id: 'peps9_u5',
              label: 'Venda de 15 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
            InventoryMethodItem(
              id: 'peps9_u6',
              label: 'Compra de 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 32,00.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_9', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'saida_peps_9', label: 'Etapa 2 — Venda/saída'),
          ],
          correctMap: {
            'peps9_u1': 'entrada_peps_9',
            'peps9_u2': 'entrada_peps_9',
            'peps9_u3': 'saida_peps_9',
            'peps9_u4': 'entrada_peps_9',
            'peps9_u5': 'saida_peps_9',
            'peps9_u6': 'entrada_peps_9',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_9': 'Lançamento das entradas no estoque.',
            'saida_peps_9': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_9'],
            'Saída': ['saida_peps_9'],
          },
          explanation:
              'No PEPS, as saídas consomem primeiro os lotes mais antigos e as compras posteriores entram no saldo. O estoque final fica em 1480,00.',
        ),

        InventoryMethodQuestion(
          id: 'peps_q10_dificil',
          text:
              'A empresa Lambda apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
              '- 01/01 - Estoque inicial: 18 unidades a R\$ 60,00 cada.\n'
              '- 04/01 - Compra de 12 unidades a R\$ 62,00 cada.\n'
              '- 09/01 - Compra de 10 unidades a R\$ 65,00 cada.\n'
              '- 12/01 - Devolução de 4 unidades da compra de 09/01.\n'
              '- 15/01 - Venda de 15 unidades.\n'
              '- 18/01 - Compra de 8 unidades a R\$ 68,00 cada.\n'
              '- 21/01 - Venda de 10 unidades.\n\n'
              'Considerando o inventário permanente e o PEPS, informe o valor do estoque final.\n'
              'Obs.: preencha o resultado com número, sem cifrão.',
          items: [
            InventoryMethodItem(
              id: 'peps10_u1',
              label: 'Estoque inicial: 18 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 60,00.',
            ),
            InventoryMethodItem(
              id: 'peps10_u2',
              label: 'Compra de 12 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 62,00.',
            ),
            InventoryMethodItem(
              id: 'peps10_u3',
              label: 'Compra de 10 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 65,00.',
            ),
            InventoryMethodItem(
              id: 'peps10_u4',
              label: 'Devolução de 4 unidades da compra',
              correctMethod: 'peps',
              detail: 'Retorno ao estoque da mercadoria comprada.',
            ),
            InventoryMethodItem(
              id: 'peps10_u5',
              label: 'Venda de 15 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
            InventoryMethodItem(
              id: 'peps10_u6',
              label: 'Compra de 8 unidades',
              correctMethod: 'peps',
              detail: 'Preço unitário de R\$ 68,00.',
            ),
            InventoryMethodItem(
              id: 'peps10_u7',
              label: 'Venda de 10 unidades',
              correctMethod: 'peps',
              detail: 'Saída pelo custo das unidades mais antigas.',
            ),
          ],
          targets: [
            MatchTarget(id: 'entrada_peps_10', label: 'Etapa 1 — Entradas/Compra'),
            MatchTarget(id: 'devolucao_compra_peps_10', label: 'Etapa 2 — Devolução de compra'),
            MatchTarget(id: 'saida_peps_10', label: 'Etapa 3 — Venda/saída'),
          ],
          correctMap: {
            'peps10_u1': 'entrada_peps_10',
            'peps10_u2': 'entrada_peps_10',
            'peps10_u3': 'entrada_peps_10',
            'peps10_u4': 'devolucao_compra_peps_10',
            'peps10_u5': 'saida_peps_10',
            'peps10_u6': 'entrada_peps_10',
            'peps10_u7': 'saida_peps_10',
          },
          methodNotes: {
            'peps': 'PEPS: primeiro que entra, primeiro que sai.',
            'entrada_peps_10': 'Lançamento das entradas no estoque.',
            'devolucao_compra_peps_10': 'Retirada da devolução da compra.',
            'saida_peps_10': 'Saída avaliada pelos custos mais antigos.',
          },
          groups: {
            'Entradas': ['entrada_peps_10'],
            'Ajustes': ['devolucao_compra_peps_10'],
            'Saída': ['saida_peps_10'],
          },
          explanation:
              'No PEPS, a devolução da compra volta pelo custo original, as saídas consomem os lotes mais antigos e as compras mais novas permanecem no saldo. O estoque final fica em 1244,00.',
        ),
      ],
    ),
  ],
);