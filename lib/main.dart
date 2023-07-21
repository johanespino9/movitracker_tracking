import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/api_manager.dart';
import 'data/datasources/remote_data_source_impl.dart';
import 'data/model/iniciar_ruta_input.dart';
import 'data/repository/iniciar_ruta_repository_impl.dart';
import 'domain/usecases/iniciar_ruta_usecase.dart';
import 'presentation/bloc/iniciar_ruta_bloc.dart';


void main() {
  final apiClient = ApiClient(
    baseUrl: 'https://movilat.com/appmovilat',
    httpClient: http.Client(),
  );

  final remoteDataSource = RemoteDataSourceImpl(apiClient: apiClient);
  final rutaRepository = RutaRepositoryImpl(remoteDataSource: remoteDataSource);
  final iniciarRutaUseCase = IniciarRutaUseCase(repository: rutaRepository);

  runApp(MyApp(
    inciarRutaCubit: IniciarRutaCubit(iniciarRutaUseCase: iniciarRutaUseCase),
  ));
}

class MyApp extends StatelessWidget {
  final IniciarRutaCubit inciarRutaCubit;

  const MyApp({Key? key, required this.inciarRutaCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 204, 0)),
        useMaterial3: true,
      ),
      home: BlocProvider<IniciarRutaCubit>(
        create: (context) => inciarRutaCubit,
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocationData? _currentLocation;
  Location location = Location();

  late TextEditingController _usuarioIDController;
  late TextEditingController _solicitudIDController;
  late TextEditingController _segundosController;

  late Timer _timer;
  bool rutaDetenida = true; 
  String tituloBoton = 'Iniciar Ruta'; 
  int _interval = 5; // Default interval in seconds

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _usuarioIDController = TextEditingController();
    _solicitudIDController = TextEditingController();
    _segundosController = TextEditingController();
  }

  @override
  void dispose() {
    _timer.cancel();
    _usuarioIDController.dispose();
    _solicitudIDController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    print(status.isGranted);
    if (!status.isGranted) {
      _getLocation();
    } else {
      _getLocation();
    }
  }

  Future<void> _getLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        _currentLocation = locationData;
        print('location: ${_currentLocation?.latitude}');
        print('location: ${_currentLocation?.latitude}');
      });
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  void _showAlert(String title, String message, String buttonText) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  Future<void> _iniciarRuta() async {
    try {
      IniciarRutaInput input = IniciarRutaInput(
        latitude: '${_currentLocation?.latitude ?? 0.0}',
        longitude: '${_currentLocation?.longitude ?? 0.0}',
        usuarioID: _usuarioIDController.text,
        solicitudID: _solicitudIDController.text,
      );

      print('INPUTS: ${input.latitude}');
      print('INPUTS: ${input.longitude}');
      print('INPUTS: ${input.usuarioID}');
      print('INPUTS: ${input.solicitudID}');

      final data = await context.read<IniciarRutaCubit>().iniciarRuta(input);
    } catch (error) {
      print('ERROR $error');
      _showAlert(
        'Error!',
        'Input is empty',
        'Got it',
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: int.parse(_segundosController.text)), (_) {
      if (_currentLocation != null) {
        _getLocation();
        _iniciarRuta();
      }
    });
  }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _currentLocation != null
          ? Column(
              children: [
                Text('Latitud: ${_currentLocation!.latitude}'),
                Text('Longitud: ${_currentLocation!.longitude}'),
              ],
            )
          : Text('Obteniendo ubicación...'),
    );
  }

  Widget _buildUserIdTextField() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _usuarioIDController,
          readOnly: !rutaDetenida,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            labelText: 'ID de usuario',
          ),
        ),
      ),
    );
  }

  Widget _buildSolicitudIdTextField() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _solicitudIDController,
          readOnly: !rutaDetenida,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            labelText: 'ID de solicitud',
          ),
        ),
      ),
    );
  }

  Widget _buildSegundosTextField() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _segundosController,
          readOnly: !rutaDetenida,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            labelText: 'Timer (Ingresar segundos)',
          ),
        ),
      ),
    );
  }

  Widget _buildIniciarRuta() {
    return BlocConsumer<IniciarRutaCubit, IniciarRutaState>(
      listener: (context, state) {
        if (state is IniciarRutaSuccess) {
          // Handle success if needed
        } else if (state is IniciarRutaFailure) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(
          //         'Failed: ${state.error}'), // Show error message here
          //   ),
          // );
        }
      },
      builder: (context, state) {
        
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Color.fromARGB(255, 255, 204, 0),
                  ),
                  onPressed: () {
                    print('Estoy logueandome');
                    if (rutaDetenida) { 
                      _iniciarRuta();
                      _startTimer();
                      rutaDetenida = false;

                      setState(() {
                        tituloBoton = 'Detener Ruta';  
                      });
                    } else { 
                      _timer.cancel();
                      rutaDetenida = true;

                      setState(() {
                        tituloBoton = 'Iniciar Ruta';  
                      });
                    }
                  },
                  child: Text(
                    tituloBoton,
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 48, 27, 100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              (state is IniciarRutaLoading ? CircularProgressIndicator() : SizedBox()),
              const SizedBox(height: 24.0),
              (state is IniciarRutaLoading ? Text('Enviando ubiación...') : SizedBox()),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movitracker - Movilat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 48, 27, 100),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 204, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              _buildLocationInfo(),
              _buildUserIdTextField(),
              _buildSolicitudIdTextField(),
              _buildSegundosTextField(),
              _buildIniciarRuta(),
            ],
          ),
        ),
      ),
    );
  }
}
