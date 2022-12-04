{ lib, stdenv, fetchFromGitHub, vapoursynth }:

let
  ext = stdenv.targetPlatform.extensions.sharedLibrary;
in stdenv.mkDerivation rec {
  pname = "VS-ContinuityFixer";
  version = "7";

  src = fetchFromGitHub {
    owner = "MonoS";
    repo = pname;
    rev = "V${version}";
    sha256 = "sha256-goqq+312d8/a7lA2qyOqN/2RxAH+U2bmXu8oLjggejI=";
  };

  buildInputs = [ vapoursynth ];

  buildPhase = ''
    c++ -shared -fPIC -O2 -msse2 -mfpmath=sse -I${vapoursynth}/include/vapoursynth \
        continuity.cpp -o continuity${ext}
  '';

  installPhase = ''
    install -D continuity${ext} $out/lib/vapoursynth/continuity${ext}
  '';

  doInstallCheck = true;
  installCheckPhase = vapoursynth.installCheckPhasePluginExistanceCheck vapoursynth "cf";

  meta = with lib; {
    description = "Continuity Fixer port for Vapoursynth";
    homepage = "https://github.com/MonoS/VS-ContinuityFixer";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
