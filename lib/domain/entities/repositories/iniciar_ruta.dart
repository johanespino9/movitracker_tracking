
import '../../../data/model/iniciar_ruta_input.dart';
import '../../../data/model/iniciar_ruta_response.dart';

abstract class RutaRepository {
  Future<IniciarRutaResponse> registrarUbicacionMovitracker(IniciarRutaInput input);
}