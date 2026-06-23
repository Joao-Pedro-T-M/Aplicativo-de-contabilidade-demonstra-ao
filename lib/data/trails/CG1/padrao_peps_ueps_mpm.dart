import 'package:equition/models/course_models.dart';
import 'package:equition/widgets/drag_inventory_method_widget.dart';

final Trail padrao_peps_ueps_mpm = Trail(
  id: 'padrao_peps_ueps_mpm',
  title: 'PEPS, UEPS e MPM',
  description:
      'Questões separadas para identificar e comparar os métodos de avaliação de estoque.',
  lessons: [
    Lesson(
  id: 'l_peps_ueps_mpm_basico',
  title: 'Métodos de avaliação de estoque',
  questions: [
    InventoryMethodQuestion(
      id: 'ueps_q2_exata',
      text:
          'A empresa ABC apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
          '- 01/01 - Estoque inicial: 18 unidades avaliadas a R\$ 2.160 (valor total).\n'
          '- 10/01 - Compras: 25 unidades pelo preço unitário de R\$ 142.\n'
          '- 15/01 - Devolução de 10 unidades adquiridas no dia 10/01.\n'
          '- 20/01 - Venda de 20 unidades. O preço de venda foi de R\$ 300 por unidade.\n'
          '- 25/01 - Devolução de 5 unidades vendidas no dia 20/01.\n\n'
          'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
          'Obs.: preencha o resultado com número, sem cifrão.',
      items: [
        InventoryMethodItem(
          id: 'u1',
          label: 'Estoque inicial: 18 unidades',
          correctMethod: 'ueps',
          detail: 'Valor total de R\$ 2.160.',
        ),
        InventoryMethodItem(
          id: 'u2',
          label: 'Compra de 25 unidades',
          correctMethod: 'ueps',
          detail: 'Preço unitário de R\$ 142.',
        ),
        InventoryMethodItem(
          id: 'u3',
          label: 'Devolução de 10 unidades da compra',
          correctMethod: 'ueps',
          detail: 'Retorno ao estoque da mercadoria comprada.',
        ),
        InventoryMethodItem(
          id: 'u4',
          label: 'Venda de 20 unidades',
          correctMethod: 'ueps',
          detail: 'Saída pelo custo das últimas unidades que entraram.',
        ),
        InventoryMethodItem(
          id: 'u5',
          label: 'Devolução de 5 unidades vendidas',
          correctMethod: 'ueps',
          detail: 'Retorno ao estoque pelo custo das unidades devolvidas.',
        ),
      ],
      targets: [
        MatchTarget(id: 'entrada_ueps', label: 'Etapa 1 — Entradas/Compra'),
        MatchTarget(id: 'devolucao_compra_ueps', label: 'Etapa 2 — Devolução de compra'),
        MatchTarget(id: 'saida_ueps', label: 'Etapa 3 — Venda/saída'),
        MatchTarget(id: 'devolucao_venda_ueps', label: 'Etapa 4 — Devolução de venda'),
      ],
      correctMap: {
        'u1': 'entrada_ueps',
        'u2': 'entrada_ueps',
        'u3': 'devolucao_compra_ueps',
        'u4': 'saida_ueps',
        'u5': 'devolucao_venda_ueps',
      },
      methodNotes: {
        'ueps': 'UEPS: último que entra, primeiro que sai.',
        'entrada_ueps': 'Lançamento das entradas no estoque.',
        'devolucao_compra_ueps': 'Retirada da devolução da compra.',
        'saida_ueps': 'Saída avaliada pelos custos mais recentes.',
        'devolucao_venda_ueps': 'Retorno ao estoque pelo custo das unidades devolvidas.',
      },
      groups: {
        'Entradas': ['entrada_ueps'],
        'Ajustes': ['devolucao_compra_ueps', 'devolucao_venda_ueps'],
        'Saída': ['saida_ueps'],
      },
      explanation:
          'No UEPS, as últimas unidades que entram são as primeiras a sair. '
          'A devolução da compra volta ao estoque pelo mesmo custo da entrada. '
          'A devolução da venda também retorna ao estoque pelo custo das unidades devolvidas. '
          'Nesse caso, o estoque final fica em 18 unidades a R\$ 120, totalizando 2160.',
          ),



        Lesson(
  id: 'l_peps_ueps_mpm_basico',
  title: 'Métodos de avaliação de estoque',
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
      id: 'ueps_q2_facil',
      text:
          'A empresa Beta apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
          '- 01/01 - Estoque inicial: 12 unidades a R\$ 18,00 cada.\n'
          '- 04/01 - Compra de 8 unidades a R\$ 20,00 cada.\n'
          '- 09/01 - Venda de 10 unidades.\n\n'
          'Considerando o inventário permanente e o UEPS, informe o valor do estoque final.\n'
          'Obs.: preencha o resultado com número, sem cifrão.',
      items: [
        InventoryMethodItem(
          id: 'ueps2_u1',
          label: 'Estoque inicial: 12 unidades',
          correctMethod: 'ueps',
          detail: 'Preço unitário de R\$ 18,00.',
        ),
        InventoryMethodItem(
          id: 'ueps2_u2',
          label: 'Compra de 8 unidades',
          correctMethod: 'ueps',
          detail: 'Preço unitário de R\$ 20,00.',
        ),
        InventoryMethodItem(
          id: 'ueps2_u3',
          label: 'Venda de 10 unidades',
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
          'No UEPS, a venda sai pelos custos mais recentes. O estoque final fica em 180,00.',
    ),

    InventoryMethodQuestion(
      id: 'mpm_q3_facil',
      text:
          'A empresa Gama apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
          '- 01/01 - Estoque inicial: 10 unidades a R\$ 25,00 cada.\n'
          '- 06/01 - Compra de 10 unidades a R\$ 35,00 cada.\n'
          '- 12/01 - Venda de 12 unidades.\n\n'
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
          label: 'Venda de 12 unidades',
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
          'No MPM, o custo médio é recalculado a cada movimentação. O estoque final fica em 240,00.',
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
      id: 'ueps_q5_media',
      text:
          'A empresa Épsilon apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
          '- 01/01 - Estoque inicial: 20 unidades a R\$ 30,00 cada.\n'
          '- 03/01 - Compra de 10 unidades a R\$ 34,00 cada.\n'
          '- 07/01 - Compra de 5 unidades a R\$ 36,00 cada.\n'
          '- 11/01 - Venda de 18 unidades.\n\n'
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
          'No UEPS, a saída usa primeiro os últimos custos que entraram. O estoque final fica em 510,00.',
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
          'No MPM, o custo médio é atualizado a cada compra e saída. O estoque final fica em 480,00.',
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
          'No UEPS, a devolução da compra ajusta o lote mais recente e a venda sai pelos custos mais novos. O estoque final fica em 264,00.',
    ),

    InventoryMethodQuestion(
      id: 'mpm_q9_dificil',
      text:
          'A empresa Kappa apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
          '- 01/01 - Estoque inicial: 40 unidades a R\$ 18,00 cada.\n'
          '- 03/01 - Compra de 30 unidades a R\$ 20,00 cada.\n'
          '- 08/01 - Venda de 25 unidades.\n'
          '- 11/01 - Devolução de 10 unidades da compra de 03/01.\n'
          '- 15/01 - Compra de 20 unidades a R\$ 22,00 cada.\n\n'
          'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
          'Obs.: preencha o resultado com número, sem cifrão.',
      items: [
        InventoryMethodItem(
          id: 'mpm9_u1',
          label: 'Estoque inicial: 40 unidades',
          correctMethod: 'mpm',
          detail: 'Preço unitário de R\$ 18,00.',
        ),
        InventoryMethodItem(
          id: 'mpm9_u2',
          label: 'Compra de 30 unidades',
          correctMethod: 'mpm',
          detail: 'Preço unitário de R\$ 20,00.',
        ),
        InventoryMethodItem(
          id: 'mpm9_u3',
          label: 'Venda de 25 unidades',
          correctMethod: 'mpm',
          detail: 'Saída pelo custo médio ponderado móvel.',
        ),
        InventoryMethodItem(
          id: 'mpm9_u4',
          label: 'Devolução de 10 unidades da compra',
          correctMethod: 'mpm',
          detail: 'Retorno ao estoque pelo custo médio do período.',
        ),
        InventoryMethodItem(
          id: 'mpm9_u5',
          label: 'Compra de 20 unidades',
          correctMethod: 'mpm',
          detail: 'Preço unitário de R\$ 22,00.',
        ),
      ],
      targets: [
        MatchTarget(id: 'entrada_mpm_9', label: 'Etapa 1 — Entradas/Compra'),
        MatchTarget(id: 'ajuste_mpm_9', label: 'Etapa 2 — Devolução de compra'),
        MatchTarget(id: 'saida_mpm_9', label: 'Etapa 3 — Venda/saída'),
      ],
      correctMap: {
        'mpm9_u1': 'entrada_mpm_9',
        'mpm9_u2': 'entrada_mpm_9',
        'mpm9_u3': 'saida_mpm_9',
        'mpm9_u4': 'ajuste_mpm_9',
        'mpm9_u5': 'entrada_mpm_9',
      },
      methodNotes: {
        'mpm': 'MPM: custo médio ponderado móvel.',
        'entrada_mpm_9': 'Lançamento das entradas no estoque.',
        'ajuste_mpm_9': 'Devolução tratada pelo custo médio.',
        'saida_mpm_9': 'Saída pelo custo médio do período.',
      },
      groups: {
        'Entradas': ['entrada_mpm_9'],
        'Ajustes': ['ajuste_mpm_9'],
        'Saída': ['saida_mpm_9'],
      },
      explanation:
          'No MPM, as saídas e devoluções ajustam o estoque pelo custo médio corrente. O estoque final fica em 1100,00.',
    ),

    InventoryMethodQuestion(
      id: 'mpm_q10_dificil',
      text:
          'A empresa Lambda apresentou as seguintes movimentações em seu estoque de Mercadorias para Revenda:\n'
          '- 01/01 - Estoque inicial: 25 unidades a R\$ 40,00 cada.\n'
          '- 04/01 - Compra de 15 unidades a R\$ 44,00 cada.\n'
          '- 09/01 - Compra de 10 unidades a R\$ 46,00 cada.\n'
          '- 12/01 - Venda de 20 unidades.\n'
          '- 16/01 - Compra de 5 unidades a R\$ 48,00 cada.\n'
          '- 20/01 - Venda de 10 unidades.\n\n'
          'Considerando o inventário permanente e o MPM, informe o valor do estoque final.\n'
          'Obs.: preencha o resultado com número, sem cifrão.',
      items: [
        InventoryMethodItem(
          id: 'mpm10_u1',
          label: 'Estoque inicial: 25 unidades',
          correctMethod: 'mpm',
          detail: 'Preço unitário de R\$ 40,00.',
        ),
        InventoryMethodItem(
          id: 'mpm10_u2',
          label: 'Compra de 15 unidades',
          correctMethod: 'mpm',
          detail: 'Preço unitário de R\$ 44,00.',
        ),
        InventoryMethodItem(
          id: 'mpm10_u3',
          label: 'Compra de 10 unidades',
          correctMethod: 'mpm',
          detail: 'Preço unitário de R\$ 46,00.',
        ),
        InventoryMethodItem(
          id: 'mpm10_u4',
          label: 'Venda de 20 unidades',
          correctMethod: 'mpm',
          detail: 'Saída pelo custo médio ponderado móvel.',
        ),
        InventoryMethodItem(
          id: 'mpm10_u5',
          label: 'Compra de 5 unidades',
          correctMethod: 'mpm',
          detail: 'Preço unitário de R\$ 48,00.',
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
          'No MPM, o custo médio é recalculado após cada compra e saída. O estoque final fica em 1080,00.',
    ),
  ],
)
      ],
    ),
  ],
);