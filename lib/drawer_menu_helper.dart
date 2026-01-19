part of 'drawer_menu_screen.dart';

class DrawerMenuHelper {

  late SignOutCubit signOutCubit;

  initializeDrawerMenu(){
    signOutCubit = SignOutCubit();
  }    
  
  disposeDrawerMenu(){
    signOutCubit.close();
  } 

  void callSignOutAPI() {
    final authHelper = AuthHelper();
    authHelper.callSignOutAPI(signOutCubit: signOutCubit);
  }

  void onSignOutSuccess() async {
    SharedPrefUtils.onLogout();
    navigateToPageAndRemoveAllPage(const SigninScreen());
  }
}