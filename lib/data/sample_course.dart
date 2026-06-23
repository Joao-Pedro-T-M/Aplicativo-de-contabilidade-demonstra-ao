// lib/data/sample_course.dart
import '../models/course_models.dart';

// importa os índices por curso (aliases)
import 'trails/CG1/trails_index.dart' as cg1;
import 'trails/CG2/trails_index.dart' as cg2;
import 'trails/CG3/trails_index.dart' as cg3;

final course1 = Course(
  id: 'c1',
  title: 'Contabilidade Geral 1',
  description: '',
  trails: [
    cg1.padrao_ac_pl,      // AC + PL
    cg1.balancopatrimonial, // BP completo / mistura de todos os grupos
    cg1.padrao3,           // DRE / reservas
    cg1.dfc,

    cg1.peps_10_questoes
  ],
);

final courses = [course1];
final sampleCourse = course1;