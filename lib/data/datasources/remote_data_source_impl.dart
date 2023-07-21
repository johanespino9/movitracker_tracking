import 'dart:convert';

import '../model/iniciar_ruta_input.dart';
import 'api_manager.dart';
import 'remote_data_source.dart';

const _authUrl = '/enviar-gps-solicitud-movil';
const _headers = {
  'Accept': '*/*',
};

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiClient apiClient;

  RemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<Map<String, dynamic>> registrarUbicacionMovitracker(IniciarRutaInput input) async {
     
    try {
      
      var form = new Map<String, dynamic>();
      form['latitud'] = input.latitude;
      form['longitud'] = input.longitude;
      form['usuario_id'] = input.usuarioID;
      form['solicitud_id'] = input.solicitudID;

      final response = await apiClient.post(
        _authUrl,
        body: form,
        headers: _headers,
      );

      print('RESPONSE: $response');

      if (response.isEmpty) {
        throw Exception('Empty response from the server');
      }

      return response;

    } catch (error) {
      throw Exception('Failed error: $error');
    }
  }
}