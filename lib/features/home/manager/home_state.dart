part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoadingData extends HomeState {}
class HomeSuccessData extends HomeState {}
class HomeFailedData extends HomeState {}
class HomeSearchChange extends HomeState {}
class HomeSearchUser extends HomeState {}
class ChangeLastActive extends HomeState {}
class GetMyUser extends HomeState {}
class GetMyFriends extends HomeState {}
class New extends HomeState {}
