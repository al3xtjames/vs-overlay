{ lib, vapoursynthPlugins, buildPythonPackage, fetchFromGitHub, rich, toolz, vapoursynth, pythonOlder }:
let
  propagatedBinaryPlugins = with vapoursynthPlugins; [
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
in
buildPythonPackage rec {
  pname = "lvsfunc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fHvG3zqXJvX7PQ7X+ITqUIuYj32qlCSiOXG1T6nHai0=";
  };

  postPatch = ''
    # This does not depend on vapoursynth (since this is used from within
    # vapoursynth).
    substituteInPlace requirements.txt \
        --replace "VapourSynth>=59" "" \
  '';

  propagatedBuildInputs = [
    rich
    toolz
  ] ++ (with vapoursynthPlugins; [
    #debandshit TODO: replace with vs-deband
    edi_rpow2
    havsfunc
    kagefunc
    mvsfunc
    vsTAAmbk
    vsutil
    vs-scale
    vs-parsedvd
  ]);

  checkInputs = [ (vapoursynth.withPlugins propagatedBinaryPlugins) ];
  pythonImportsCheck = [ "lvsfunc" ];

  meta = with lib; {
    description = "A collection of LightArrowsEXE’s VapourSynth functions and wrappers";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/lvsfunc";
    license = licenses.mit; # no license
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
    broken = pythonOlder "3.10";
  };
}