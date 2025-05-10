import 'package:get/get.dart';
import 'package:cocteles_app/models/user_model.dart';
import 'package:cocteles_app/features/authentication/models/user_credentials.dart';
import 'package:cocteles_app/data/repositories/user/user_repository.dart';

class UserController extends GetxController{


  static UserController get instance => Get.find();
  
  final userRepostory = Get.put(UserRepository());

  Rx<UserModel> user = UserModel.empty().obs;
  UserCredentials?  userCredentials;

  Future<void> getUserStatisticsData() async {
    try {

    } catch (e) {
      print(e);
    }
  }

Future<void> fetchUserData() async {
  try{
    final userData = await userRepostory.getUserDetails(userCredentials!.username, userCredentials!.jwt);
    this.user(userData);

    /*
    if user.profilePicture != null {
      getUserProfilePicture(userData.profilePicture);
    }
    */    

  }catch(e){
    user(UserModel.empty());
    print(e);
  }
}


}