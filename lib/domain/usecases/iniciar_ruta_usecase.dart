
import 'dart:convert';

import '../../data/model/iniciar_ruta_input.dart';
import '../../data/model/iniciar_ruta_response.dart';
import '../entities/iniciar_ruta.dart';
import '../entities/repositories/iniciar_ruta.dart';

class IniciarRutaUseCase {
  final RutaRepository repository;

  IniciarRutaUseCase({required this.repository});

  Future<IniciarRuta> call(IniciarRutaInput input) async {
    IniciarRutaResponse data = await repository.registrarUbicacionMovitracker(input);

    print('INICIAR RUTA RESPONSE: $data');

    return IniciarRuta.fromJson(data as Map<String, dynamic>);
  }
}
