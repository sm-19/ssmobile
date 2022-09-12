import 'package:get/get.dart';

import '../controllers/nilaiulangan_controller.dart';

class NilaiulanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NilaiulanganController>(
      () => NilaiulanganController(),
    );
  }
}
