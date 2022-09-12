import 'package:get/get.dart';

import '../controllers/nilaitugas_controller.dart';

class NilaitugasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NilaitugasController>(
      () => NilaitugasController(),
    );
  }
}
