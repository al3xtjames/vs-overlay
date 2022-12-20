{ lib, vapoursynthPlugins, buildPythonPackage, mkVapoursynthPythonSetuptools, fetchFromGitHub, python3, vapoursynth }:
let
  pytimeconv = buildPythonPackage rec {
    pname = "pytimeconv";
    version = "0.0.2";

    src = fetchFromGitHub {
      owner = "Ichunjo";
      repo = pname;
      rev = "${version}";
      sha256 = "sha256-qb3EvstohPBBZYkJDVh+TpK2lNVpjK+wGQTMuZoxl9w=";
    };
  };
in

mkVapoursynthPythonSetuptools rec {
  pname = "vardefunc";
  version = "0.7.2";
  importname = "vardefunc";

  src = fetchFromGitHub {
    owner = "Ichunjo";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-8bWdC9JD4WufcbvBnw0o8Lws9qZKOV3PYOT3lTSJsvA=";
  };

  remove_vapoursynth_dep_reqtxt = 59;

  propagatedBuildInputs = [
    pytimeconv
  ];

  vs_pythondeps = with vapoursynthPlugins; [
    fvsfunc
    havsfunc
    lvsfunc
    vsutil
  ];

  vs_binarydeps = with vapoursynthPlugins; [
    adaptivegrain
    bilateral
    eedi3m
    f3kdb
    ffms2
    nnedi3cl
    scxvid
    wwxd
    d2vsource
  ];

  meta = with lib; {
    description = " Some functions that may be useful ";
    homepage = "https://github.com/Ichunjo/vardefunc";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}