import 'package:get/get.dart';

import '../controllers/akses_controller.dart';

class AksesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AksesController>(
      () => AksesController(),
    );
  }
}
