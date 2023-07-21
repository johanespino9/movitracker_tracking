import '../../domain/entities/repositories/iniciar_ruta.dart';
import '../datasources/remote_data_source.dart';
import '../model/iniciar_ruta_input.dart';
import '../model/iniciar_ruta_response.dart';

class RutaRepositoryImpl implements RutaRepository {
  final RemoteDataSource remoteDataSource;

RutaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<IniciarRutaResponse> registrarUbicacionMovitracker(IniciarRutaInput input) async {
    final iniciarRutaResponse = await remoteDataSource.registrarUbicacionMovitracker(input);
    print('INICIAR RUTA RESPONSE ${iniciarRutaResponse}');
    return IniciarRutaResponse.fromJson(iniciarRutaResponse);
  }
}