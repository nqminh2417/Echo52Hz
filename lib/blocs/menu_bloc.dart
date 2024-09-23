import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/menu_item.dart';
import '../services/sqlite_service.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuInitial());

  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is LoadMenuItemsEvent) {
      final menuItems = await SQLiteService.getMenuItemsByRoleCode('ADMIN');
      yield MenuLoaded(menuItems);
    }
  }
}

abstract class MenuEvent {}

class LoadMenuItemsEvent extends MenuEvent {}

class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> menuItems;

  MenuLoaded(this.menuItems);

  // Getter to access menuItems
  // List<MenuItem> getMenuItems() => menuItems;
}
