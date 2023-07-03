{ lib,  fetchFromGitHub, libdovi, libplacebo,  vulkan-headers, vulkan-loader, mkVapoursynthMesonB }:

mkVapoursynthMesonB rec {
  pname = "vs-placebo";
  version = "1.4.4";
  namespace = "placebo";

  src = fetchFromGitHub {
    owner = "Lypheo";
    repo = pname;
    rev = version;
    sha256 = "sha256-1DTdllP+Y4s+t2PMnpcgeLjOxOyyV/yhFSxPP9/Gy9M=";
    fetchSubmodules = true;
  };

  modeb_replace = "vapoursynth_dep.get_variable(pkgconfig: 'libdir')";
  buildInputs = [ libdovi libplacebo vulkan-headers vulkan-loader ];

  meta = with lib; {
    description = "A libplacebo-based debanding, scaling and color mapping plugin for VapourSynth";
    homepage = "https://github.com/Lypheo/vs-placebo";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
