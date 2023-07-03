final: prev:
let
  common = import ./common.nix final prev;
  filter_python_plugins = common.filter_python_plugins;
in
{
  #example
  #plugin_list = with pkgs.vapoursynthPlugins; [ ... ];
  #vap_with_stubs = (pkgs.vapoursynth.withPlugins (plugin_list ++ [ (pkgs.generate_vapoursynth_stubs plugin_list) ]));
  #pkgs.mkShell { buildInputs = with pkgs; [ vscodium vap_with_stubs.python3 vap_with_stubs ] }
  generate_vapoursynth_stubs = common.generate_stubs;

  #wrapper for vapoursynth plugins and functions
  mkVapoursynthMeson = prev.callPackage ./build-support/meson.nix {};
  mkVapoursynthMesonA = attrs: final.mkVapoursynthMeson ( attrs // {
    mode = "A";
  });
  mkVapoursynthMesonB = attrs: final.mkVapoursynthMeson ( attrs // {
    mode = "B";
  });
  mkVapoursynthAutomake = prev.callPackage ./build-support/automake.nix {};
  mkVapoursynthPython = common.callPythonPackage ./build-support/pythonfunc_singlefile.nix { inherit filter_python_plugins; };
  mkVapoursynthPythonSinglefileFunc = attrs: final.mkVapoursynthPython ( attrs // { format = "other"; });
  mkVapoursynthPythonSetuptools = attrs: (final.mkVapoursynthPython) ( attrs // { format = "setuptools"; });
  mkVapoursynthPythonPyproject  = attrs: (final.mkVapoursynthPython) ( attrs // { format = "pyproject"; });


  buildVapoursynthConfigFile = (prev.callPackage ./make_vap_config_file.nix {});

  #todo: use new mk_config file thing
  #script that checks if namespace exists in the derivation output
  vapoursynthInstallCheckPhase = vap: namespace: ''
#or loop manually and std.LoadPlugin
echo "UserPluginDir=$out/lib/vapoursynth" > test.conf
VAPOURSYNTH_CONF_PATH=test.conf PYTHONPATH=${vap}/${vap.python3.sitePackages}:$PYTHONPATH ${vap.python3}/bin/python -c '
import vapoursynth
import sys
to_srch = "${namespace}"
fnd= False
for a in vapoursynth.core.plugins():
  print("Got module: {} {}".format(a.namespace,a.name))
  if a.namespace == to_srch:
    print("GOT module break;")
    fnd = True
    break
if fnd == False:
  print("Could not find {}".format(to_srch))
  sys.exit(1)
'
'';



  #todo: look for "getPluginById" in source and  find dependecyies of binary plugins to binary plugins
  #override vapoursynth from nixkgs with our veriosn
  vapoursynth = (prev.callPackage ./vapoursynth {
    ApplicationServices = prev.ApplicationServices;
  }).overrideAttrs (old: rec {
    #add our script from above to passthru so we can easlly use it without adding it in {..}
    passthru = (old.passthru) // (rec {  installCheckPhasePluginExistanceCheck = final.vapoursynthInstallCheckPhase; } );
  });

  vapoursynthPlugins = import ./plugins final prev;

  #tools
  getnative    = common.callPythonPackage ./tools/getnative { };
  getfnative   = common.callPythonPackage ./tools/getFnative { };
  vspreview-rs = prev.callPackage ./tools/vspreview-rs { };
  d2vwitch     = prev.libsForQt5.callPackage ./tools/d2vwitch { };
  wobbly       = prev.libsForQt5.callPackage ./tools/wobbly { };
  vspreview    = common.callPythonPackage ./tools/vspreview { python_call = common.callPythonPackage; };
  concatfs     = prev.callPackage ./tools/concatfs { }; #maybe useful for vob files
  vasviewer    = prev.callPackage ./tools/vasviewer { };
  dovi_tool    = prev.callPackage ./tools/dovi_tool { inherit (prev.darwin.apple_sdk_11_0.frameworks) CoreText; };


  #mpv wrapper
  #needs recompilation of mpv for every plugin combination
  mpv_vs = vap: (final.mpv-unwrapped.override {
    #pass through ffmpeg with vapoursynth enable so we can use stuff like the lavf vapoursynth input
    ffmpeg_5 = (prev.ffmpeg_5.overrideAttrs (old: rec {
      configureFlags = old.configureFlags ++ [ "--enable-vapoursynth" ];
      buildInputs = old.buildInputs ++ [ final.vapoursynth ];
    }));
    #enable vapoursynth in mpv
    vapoursynthSupport = true;
    vapoursynth = vap;
  });


  #mpv wrapper that does not rebuild mpv on plugins changes by replacing the  vapoursynth derivation in runtime
  mpv_vs_wrapped = plugins:
  let
    mpv_simple = (final.mpv_vs final.vapoursynth);
    vap = final.vapoursynth.withPlugins plugins;
  in
  prev.runCommand "mpv-vapour-with-plugins" {
    buildInputs = [ final.makeWrapper mpv_simple ];
  } ''
    mkdir -p $out/bin

    ln -s ${mpv_simple}/etc $out/etc
    ln -s ${mpv_simple}/lib $out/lib
    ln -s ${mpv_simple}/share $out/share

    makeWrapper ${mpv_simple}/bin/mpv $out/bin/mpv \
        --prefix PYTHONPATH : ${vap}/${vap.python3.sitePackages} \
        --prefix LD_LIBRARY_PATH : ${vap}/lib
    makeWrapper ${mpv_simple}/bin/umpv $out/bin/umpv \
        --prefix PYTHONPATH : ${vap}/${vap.python3.sitePackages} \
        --prefix LD_LIBRARY_PATH : ${vap}/lib
  '';


}
