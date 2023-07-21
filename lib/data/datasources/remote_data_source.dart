
import '../model/iniciar_ruta_input.dart';

abstract class RemoteDataSource {
  Future<Map<String, dynamic>> registrarUbicacionMovitracker(IniciarRutaInput input);
}