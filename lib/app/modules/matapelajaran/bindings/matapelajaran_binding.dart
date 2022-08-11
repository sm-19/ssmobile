import 'package:get/get.dart';

import '../controllers/matapelajaran_controller.dart';

class MatapelajaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatapelajaranController>(
      () => MatapelajaranController(),
    );
  }
}
