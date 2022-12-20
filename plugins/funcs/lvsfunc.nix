{ lib, vapoursynthPlugins, mkVapoursynthPythonSetuptools, fetchFromGitHub, rich, toolz, pymediainfo, vapoursynth, pythonOlder, fetchPypi }:
let
  #6.0.1 only in latest unstable
  #TODO: remove
  pymediainfou = pymediainfo.overrideAttrs (old: rec {
    version = "6.0.1";
    src = fetchPypi {
      pname = "pymediainfo";
      version = "6.0.1";
      sha256 = "sha256-luBLrA38tya+1wwxSxIZEhxLk0TGapj0Js4n1/mr/7A=";
    };
  });
in
mkVapoursynthPythonSetuptools rec {
  pname = "lvsfunc";
  version = "0.5.1";
  importname = "lvsfunc";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tsqRyP5dXcm8qIiR0QCu7CQUs3OhiTK4C1TL02PH5fs=";
  };

  remove_vapoursynth_dep_reqtxt = 59;

  propagatedBuildInputs = [
    rich
    toolz
    pymediainfou
  ];

  vs_pythondeps = with vapoursynthPlugins; [
    vs-deband
    edi_rpow2
    havsfunc
    kagefunc
    mvsfunc
    vsTAAmbk
    vsutil
    vs-scale
    vs-parsedvd
  ];

  vs_binarydeps = with vapoursynthPlugins; [
    adaptivegrain
    combmask
    continuityfixer
    d2vsource
    descale
    eedi3m
    fmtconv
    knlmeanscl
    nnedi3
    readmpls
    retinex
    #rgsf
    tcanny
    znedi3
  ];

  meta = with lib; {
    description = "A collection of LightArrowsEXE’s VapourSynth functions and wrappers";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/lvsfunc";
    license = licenses.mit; # no license
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
    broken = pythonOlder "3.10";
  };
}