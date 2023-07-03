{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, vapoursynth
}:

let
  ext = stdenv.targetPlatform.extensions.sharedLibrary;
in
rustPlatform.buildRustPackage rec {
  pname = "vs-nlq";
  version = "e2b17dedbfb8323cf5a5c465a087d9307dd7c250";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = pname;
    rev = version;
    hash = "sha256-PzKfV8PE75noE4tsGuWnAGEfHVQ0WZkZojJQUlFu2Rs=";
  };

  buildInputs = [
    vapoursynth
  ];

  cargoPatches = [
    ./add_cargo_lock.patch
  ];

  cargoHash = "sha256-NE3bxxEgDXfNmf5Eqsu4BF0GgqEpw0J4f9YN803pTzY=";

  postInstall = ''
    mkdir $out/lib/vapoursynth
    mv $out/lib/libvs_nlq${ext} $out/lib/vapoursynth/
  '';

  doInstallCheck = true;
  installCheckPhase = vapoursynth.installCheckPhasePluginExistanceCheck vapoursynth "vsnlq";

  meta = with lib; {
    description = "Dolby Vision reconstruction for VapourSynth";
    homepage = "https://github.com/quietvoid/vs-nlq";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
