import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_item.dart';
import '../services/sqlite_service.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuLoading()) {
    // Listen for the LoadMenuItemsEvent and fetch the items
    on<LoadMenuItemsEvent>((event, emit) async {
      emit(MenuLoading());
      try {
        // Fetch the menu items based on roleCode
        final menuItems = await SQLiteService.getMenuItemsByRoleCode(event.roleCode);
        emit(MenuLoaded(menuItems));
      } catch (e) {
        emit(MenuError());
      }
    });
  }

  // Helper method to get menuItems directly from the current state
  List<MenuItem> get menuItems {
    if (state is MenuLoaded) {
      return (state as MenuLoaded).menuItems;
    }
    return [];
  }
}

abstract class MenuEvent {}

class LoadMenuItemsEvent extends MenuEvent {
  final String roleCode;
  LoadMenuItemsEvent({required this.roleCode});
}

abstract class MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> menuItems;
  MenuLoaded(this.menuItems);
}

class MenuError extends MenuState {}
