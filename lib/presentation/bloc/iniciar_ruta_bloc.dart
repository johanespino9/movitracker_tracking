import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/iniciar_ruta_input.dart';
import '../../domain/entities/iniciar_ruta.dart';
import '../../domain/usecases/iniciar_ruta_usecase.dart';

// Estado base para el cubit
abstract class IniciarRutaState {}

class IniciarRutaInitial extends IniciarRutaState {}

class IniciarRutaLoading extends IniciarRutaState {}

class IniciarRutaFailure extends IniciarRutaState {
  final String error;

  IniciarRutaFailure({required this.error});
}

class IniciarRutaSuccess extends IniciarRutaState {
  final IniciarRuta iniciarRuta;

  IniciarRutaSuccess({required this.iniciarRuta});
}

class IniciarRutaCubit extends Cubit<IniciarRutaState> {
  final IniciarRutaUseCase iniciarRutaUseCase;

  IniciarRutaCubit({required this.iniciarRutaUseCase}) : super(IniciarRutaInitial());

  // Método para iniciar la ruta
  Future<void> iniciarRuta(IniciarRutaInput iniciarRutaInput) async {
    emit(IniciarRutaLoading());
    try {
      final iniciarRuta = await iniciarRutaUseCase.call(iniciarRutaInput);

      // Comprueba el resultado de la solicitud
      if (iniciarRuta.status) {
        emit(IniciarRutaSuccess(iniciarRuta: iniciarRuta));
      } else {
        emit(IniciarRutaFailure(error: 'User not active'));
      }
    } catch (error) {
      emit(IniciarRutaFailure(error: error.toString()));
    }
  }
}