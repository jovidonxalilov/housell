import '../../data/model/profile_model.dart';

class ProfilePatchParams {
  final String id;
  final ProfileModel profileModel;

  ProfilePatchParams({required this.id, required this.profileModel});
}
