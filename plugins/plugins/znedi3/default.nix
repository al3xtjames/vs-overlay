{ lib, stdenv, fetchFromGitHub, vapoursynth }:

stdenv.mkDerivation rec {
  pname = "znedi3";
  ##version = ">2.1";
  #version = "unstable-2022-12-11";
  version = "2";
  #more changes needed in buildscipt to update

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = pname;
    rev = "r${version}";
    sha256 = "1p6563s1b52qisvvwid047jd376sz737lggwfhanci0sqxxphhrb";
    #rev = "4e88a5d0c805b066ae84b29e55b648fb336cb2a4";
    #sha256 = "sha256-OSfliEuVka/tU+KobqTFmL6UTHzPRIm0E7cmp++boVc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # use system vapoursynth headers (adapted from AUR PKGBUILD)
    rm -rf vsxx/{VapourSynth,VSScript,VSHelper}.h

    substituteInPlace vsxx/VapourSynth++.hpp \
        --replace '"VapourSynth.h"' '<VapourSynth.h>' \
        --replace '"VSHelper.h"' '<VSHelper.h>'

    substituteInPlace Makefile \
        --replace "VSScript.h" "" \
        --replace "VapourSynth.h" "" \
        --replace "VSHelper.h" ""
  '';

  buildInputs = [ vapoursynth ];

  makeFlags = (lib.optional stdenv.isx86_64 "X86=1");

  CPPFLAGS = lib.concatStringsSep " " [
    "-I${vapoursynth}/include/vapoursynth"
    "-DNNEDI3_WEIGHTS_PATH=\\\"\"${placeholder "out"}/share/znedi3/nnedi3_weights.bin\"\\\""
  ];

  installPhase = ''
    install -D vsznedi3.so $out/lib/vapoursynth/libvsznedi3.so
    install -D nnedi3_weights.bin $out/share/znedi3/nnedi3_weights.bin
  '';

  doInstallCheck = true;
  installCheckPhase = vapoursynth.installCheckPhasePluginExistanceCheck vapoursynth "znedi3";

  meta = with lib; {
    description = "A CPU optimised nnedi3 filter for VapourSynth";
    homepage = "https://github.com/sekrit-twc/znedi3";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
