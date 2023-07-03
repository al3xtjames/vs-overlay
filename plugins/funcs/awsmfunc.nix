{ lib, vapoursynthPlugins, mkVapoursynthPythonSetuptools, fetchFromGitHub, numpy, vapoursynth }:

mkVapoursynthPythonSetuptools rec {
  pname = "awsmfunc";
  version = "1.3.4";
  importname = "awsmfunc";

  src = fetchFromGitHub {
    owner = "OpusGang";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-7J7s/SdnA5/A/q4SaBfIWG+qOwHpjSrUzWkY1r63wwc=";
  };

  remove_vapoursynth_dep_pyproject = 57;

  propagatedBuildInputs = [
    numpy
  ];

  vs_binarydeps = with vapoursynthPlugins; [
    fmtconv
    mvtools

    descale
    fillborders
    placebo
    remap
    vs-nlq
  ];

  vs_pythondeps = with vapoursynthPlugins; [
    rekt
    vsutil
  ];


  meta = with lib; {
    description = "A VapourSynth function collection";
    homepage = "https://github.com/OpusGang/awsmfunc";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}