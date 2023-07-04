{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, ffmpeg_6-full
, zlib
}:

stdenv.mkDerivation rec {
  pname = "ffms";
  version = "cf7c4b250d5e60b7c7ddaae20f362e365bc33f30";

  src = fetchFromGitHub {
    owner = "FFMS";
    repo = "ffms2";
    rev = version;
    hash = "sha256-tEfuUld5eVnlMqBRg1ivbMmwb/VFSOsM6z/kAMmEJCc=";
  };

  env.NIX_CFLAGS_COMPILE = "-fPIC";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preAutoreconf = ''
    mkdir src/config
  '';

  buildInputs = [
    ffmpeg_6-full
    zlib
  ];

  # ffms includes a built-in vapoursynth plugin, see:
  # https://github.com/FFMS/ffms2#avisynth-and-vapoursynth-plugin
  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libffms2.so $out/lib/vapoursynth/libffms2.so
  '';

  meta = with lib; {
    homepage = "https://github.com/FFMS/ffms2/";
    description = "FFmpeg based source library for easy frame accurate access";
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.unix;
  };
}
