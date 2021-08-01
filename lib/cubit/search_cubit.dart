import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<String>{
  SearchCubit(String state) : super(state);
  //Pass new vsearch value function 
  passNewSearchValue(String value){
    emit(value);
  }
}

//Sorry np o y u beim soorry, Okay 
//You can't launch actually have to fix a bug 