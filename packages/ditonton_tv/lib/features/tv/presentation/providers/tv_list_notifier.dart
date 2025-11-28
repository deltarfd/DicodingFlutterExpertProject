import 'package:ditonton_core/core/utils/state_enum.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/material.dart';

class TvListNotifier extends ChangeNotifier {
  var _onTheAir = <Tv>[];
  List<Tv> get onTheAir => _onTheAir;

  RequestState _onTheAirState = RequestState.Empty;
  RequestState get onTheAirState => _onTheAirState;

  var _popular = <Tv>[];
  List<Tv> get popular => _popular;

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  var _airingToday = <Tv>[];
  List<Tv> get airingToday => _airingToday;

  RequestState _airingTodayState = RequestState.Empty;
  RequestState get airingTodayState => _airingTodayState;

  var _topRated = <Tv>[];
  List<Tv> get topRated => _topRated;

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  String _message = '';
  String get message => _message;

  final GetOnTheAirTv getOnTheAirTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;
  final GetAiringTodayTv getAiringTodayTv;

  TvListNotifier({
    required this.getOnTheAirTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
    required this.getAiringTodayTv,
  });

  Future<void> fetchOnTheAirTv() async {
    _onTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTv.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _onTheAirState = RequestState.Loaded;
        _onTheAir = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTv() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold(
      (failure) {
        _popularState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _popularState = RequestState.Loaded;
        _popular = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTv() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        _topRatedState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _topRatedState = RequestState.Loaded;
        _topRated = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchAiringTodayTv() async {
    _airingTodayState = RequestState.Loading;
    notifyListeners();

    final result = await getAiringTodayTv.execute();
    result.fold(
      (failure) {
        _airingTodayState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _airingTodayState = RequestState.Loaded;
        _airingToday = data;
        notifyListeners();
      },
    );
  }
}
