import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectionStatus> {
  final Dio _dio;
  Timer? _pollingTimer;
  Timer? _bannerTimer;
  bool _wasDisconnected = false;

  ConnectivityCubit(this._dio) : super(ConnectionStatus.initial) {
    _startPolling();
  }

  void _startPolling() {
    _checkConnectivity();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      const fallbackUrl = "https://one.one.one.one/";
      final response = await _dio.get(fallbackUrl);

      if (response.statusCode == 200) {
        if (_wasDisconnected) {
          _showConnectedBanner();
          _wasDisconnected = false;
        } else if (state == ConnectionStatus.initial) {
          emit(ConnectionStatus.connected);
        }
      } else {
        _handleDisconnection();
      }
    } catch (e) {
      _handleDisconnection();
    }
  }

  void _handleDisconnection() {
    _wasDisconnected = true;
    emit(ConnectionStatus.disconnected);
  }

  void _showConnectedBanner() {
    emit(ConnectionStatus.connectedBannerVisible);
    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(seconds: 3), () {
      if (!isClosed) emit(ConnectionStatus.connected);
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    _bannerTimer?.cancel();
    return super.close();
  }
}
