{ lib, stdenv, fetchFromGitHub, mkVapoursynthMesonA }:

mkVapoursynthMesonA rec {
  pname = "vapoursynth-decross";
  #version = "2";
  version = "unstable-2022-12-11";
  namespace = "decross";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    #rev = "v${version}";
    rev = "889fd9ca913867bfacbd5ac2b7ea1edaf8154889";
    sha256 = "sha256-EkcS7XpySsVDOJ8GSefbU8b6Nh5utSgkH85A4nE0Los=";
  };

  meta = with lib; {
    description = "spatio-temporal cross color (rainbow) reduction filter";
    homepage = "https://github.com/dubhater/vapoursynth-decross";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
