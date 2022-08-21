import 'package:get/get.dart';

import '../modules/absensi/bindings/absensi_binding.dart';
import '../modules/absensi/views/absensi_view.dart';
import '../modules/akses/bindings/akses_binding.dart';
import '../modules/akses/views/akses_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/informasi/bindings/informasi_binding.dart';
import '../modules/informasi/views/informasi_view.dart';
import '../modules/jadwal/bindings/jadwal_binding.dart';
import '../modules/jadwal/views/jadwal_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/matapelajaran/bindings/matapelajaran_binding.dart';
import '../modules/matapelajaran/views/matapelajaran_view.dart';
import '../modules/siswa/bindings/siswa_binding.dart';
import '../modules/siswa/views/siswa_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(
        mapel: '',
      ),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.AKSES,
      page: () => AksesView(),
      binding: AksesBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => Dashboard(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.SISWA,
      page: () => const SiswaView(),
      binding: SiswaBinding(),
    ),
    GetPage(
      name: _Paths.MATAPELAJARAN,
      page: () => const MatapelajaranView(),
      binding: MatapelajaranBinding(),
    ),
    GetPage(
      name: _Paths.JADWAL,
      page: () => const JadwalView(),
      binding: JadwalBinding(),
    ),
    GetPage(
      name: _Paths.ABSENSI,
      page: () => const AbsensiView(),
      binding: AbsensiBinding(),
    ),
    GetPage(
      name: _Paths.INFORMASI,
      page: () => const InformasiView(),
      binding: InformasiBinding(),
    ),
  ];
}
