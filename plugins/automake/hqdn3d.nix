{ lib, fetchFromGitHub, mkVapoursynthAutomake }:

mkVapoursynthAutomake rec {
  pname = "vapoursynth-hqdn3d";
  version = "unstable-2018-06-29";
  namespace = "hqdn3d";

  src = fetchFromGitHub {
    owner = "Hinterwaeldlers";
    repo = pname;
    rev = "eb820cb23f7dc47eb67ea95def8a09ab69251d30";
    sha256 = "05a01ymb5ncxgp5iy6i8ka9ysw9i6n188a2c2na6whf6rrkcgrh4";
  };

  meta = with lib; {
    description = "Vapoursynth port of hqdn3d from avisynth/mplayer";
    homepage = "https://github.com/Hinterwaeldlers/vapoursynth-hqdn3d";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
