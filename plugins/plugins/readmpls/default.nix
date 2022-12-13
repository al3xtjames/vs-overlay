{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, libbluray, vapoursynth }:

stdenv.mkDerivation rec {
  pname = "VapourSynth-ReadMpls";
  version = "5";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-cQaGasNRI0p6sz1hecErDrw6lf6G3vk98SshGdRMn+Y=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libbluray vapoursynth ];

  postPatch = ''
      substituteInPlace meson.build \
        --replace "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"

      substituteInPlace meson.build \
          --replace "b_lto=true" "b_lto=false"
  '';


  doInstallCheck = true;
  installCheckPhase = vapoursynth.installCheckPhasePluginExistanceCheck vapoursynth "mpls";

  meta = with lib; {
    description = "ReadMpls filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-ReadMpls";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
