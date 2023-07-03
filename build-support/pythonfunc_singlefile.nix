{ lib, stdenv, buildPythonPackage, python, vapoursynth, filter_python_plugins }:
{ pname,
  version,
  meta,
  src,

  propagatedBuildInputs ? [],
  postPatch ? "",
  doCheck ? true,

  checkPhase ? "",
  nativeCheckInputs ? [],
  checkInputs ? [],

  installPhase ? "",
  pythonImportsCheck ? [],

  #custom stuff
  vs_pythondeps,
  vs_binarydeps,
  importname,

  remove_vapoursynth_dep_pyproject ? 0,
  remove_vapoursynth_dep_reqtxt ? 0,
  remove_vapoursynth_dep_setupy ? 0,

  format,

  ...
}@args:
let

  #https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/libraries/vapoursynth/plugin-interface.nix
  getRecursivePropagatedBuildInputs = pkgs: lib.flatten
    (map
      (pkg: let cleanPropagatedBuildInputs = lib.filter lib.isDerivation pkg.propagatedBuildInputs;
        in cleanPropagatedBuildInputs ++ (getRecursivePropagatedBuildInputs cleanPropagatedBuildInputs))
      pkgs);

  deepPlugins = plugins: filter_python_plugins (lib.unique (plugins ++ (getRecursivePropagatedBuildInputs plugins)));

  all_prop = vs_pythondeps ++ vs_binarydeps ++ propagatedBuildInputs;

in
buildPythonPackage (args // {
  propagatedBuildInputs = all_prop;

  format = format;

  installPhase = if format == "other" then ''
    runHook preInstall
    install -D ${importname}.py $out/${python.sitePackages}/${importname}.py
    runHook postInstall
  '' else installPhase;

  postPatch =
  (if remove_vapoursynth_dep_pyproject != 0 then ''
    substituteInPlace pyproject.toml \
        --replace "\"VapourSynth >= ${toString remove_vapoursynth_dep_pyproject}\"," ""
  '' else "") +
  (if remove_vapoursynth_dep_reqtxt != 0 then ''
    substituteInPlace requirements.txt \
        --replace "VapourSynth>=${toString remove_vapoursynth_dep_reqtxt}" ""
  '' else "") +
  (if remove_vapoursynth_dep_setupy != 0 then ''
    substituteInPlace setup.py \
        --replace 'VapourSynth>=${toString remove_vapoursynth_dep_setupy}' ""
  '' else "") + postPatch;


  nativeCheckInputs = nativeCheckInputs;
  #TODO: recursion
  checkInputs = [ (vapoursynth.withPlugins2 (deepPlugins (all_prop))) ] ++ checkInputs;

  checkPhase = if !doCheck then "" else ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '' + checkPhase;
  pythonImportsCheck = (if !doCheck then [] else [ importname ]) ++ pythonImportsCheck;
})
