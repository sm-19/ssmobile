import 'package:get/get.dart';

import '../modules/absensi/bindings/absensi_binding.dart';
import '../modules/absensi/views/absensi_view.dart';
import '../modules/absensiguru/bindings/absensiguru_binding.dart';
import '../modules/absensiguru/views/absensiguru_view.dart';
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
import '../modules/materi/bindings/materi_binding.dart';
import '../modules/materi/views/materi_view.dart';
import '../modules/nilai/bindings/nilai_binding.dart';
import '../modules/nilai/views/nilai_view.dart';
import '../modules/nilaitugas/bindings/nilaitugas_binding.dart';
import '../modules/nilaitugas/views/nilaitugas_view.dart';
import '../modules/nilaiulangan/bindings/nilaiulangan_binding.dart';
import '../modules/nilaiulangan/views/nilaiulangan_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/raport/bindings/raport_binding.dart';
import '../modules/raport/views/raport_view.dart';
import '../modules/siswa/bindings/siswa_binding.dart';
import '../modules/siswa/views/siswa_view.dart';
import '../modules/tugas/bindings/tugas_binding.dart';
import '../modules/tugas/views/tugas_view.dart';
import '../modules/ujian/bindings/ujian_binding.dart';
import '../modules/ujian/views/ujian_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
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
      page: () => AbsensiView(),
      binding: AbsensiBinding(),
    ),
    GetPage(
      name: _Paths.INFORMASI,
      page: () => const InformasiView(),
      binding: InformasiBinding(),
    ),
    GetPage(
      name: _Paths.UJIAN,
      page: () => const UjianView(),
      binding: UjianBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL,
      page: () => const ProfilView(),
      binding: ProfilBinding(),
    ),
    GetPage(
      name: _Paths.NILAI,
      page: () => NilaiView(),
      binding: NilaiBinding(),
    ),
    GetPage(
      name: _Paths.MATERI,
      page: () => MateriView(),
      binding: MateriBinding(),
    ),
    GetPage(
      name: _Paths.TUGAS,
      page: () => TugasView(),
      binding: TugasBinding(),
    ),
    GetPage(
      name: _Paths.NILAITUGAS,
      page: () => NilaitugasView(),
      binding: NilaitugasBinding(),
    ),
    GetPage(
      name: _Paths.NILAIULANGAN,
      page: () => NilaiulanganView(),
      binding: NilaiulanganBinding(),
    ),
    GetPage(
      name: _Paths.RAPORT,
      page: () => RaportView(),
      binding: RaportBinding(),
    ),
    GetPage(
      name: _Paths.ABSENSIGURU,
      page: () => AbsensiguruView(),
      binding: AbsensiguruBinding(),
    ),
  ];
}
