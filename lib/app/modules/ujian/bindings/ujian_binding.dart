import 'package:get/get.dart';

import '../controllers/ujian_controller.dart';

class UjianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UjianController>(
      () => UjianController(),
    );
  }
}
