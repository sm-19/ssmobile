import 'package:get/get.dart';

import '../controllers/absensiguru_controller.dart';

class AbsensiguruBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbsensiguruController>(
      () => AbsensiguruController(),
    );
  }
}
