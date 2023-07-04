final: prev:
let
  common = import ../common.nix final prev;
  callPythonPackage = common.callPythonPackage;
  filter_python_plugins = common.filter_python_plugins;
in rec {
    #manual compile
    wwxd            = prev.callPackage ./manual/wwxd.nix { };
    edgefixer       = prev.callPackage ./manual/edgefixer { };
    surfaceblur     = prev.callPackage ./manual/surfaceblur.nix { };
    arearesize      = prev.callPackage ./manual/arearesize.nix { };
    autocrop        = prev.callPackage ./manual/autocrop.nix { };
    continuityfixer = prev.callPackage ./manual/continuityfixer.nix { };
    morpho          = prev.callPackage ./manual/morpho.nix { };
    rgsf            = prev.callPackage ./manual/rgsf.nix { };
    dotkill         = prev.callPackage ./manual/dotkill.nix { }; # fixx
    planestatsmod   = prev.callPackage ./manual/planestatsmod.nix { }; # fixx

    #meson A refers to plugins that would install normally where we need to override the install location
    tedgemask           = prev.callPackage ./mesonA/tedgemask.nix { };
    decross             = prev.callPackage ./mesonA/decross.nix { };
    asharp              = prev.callPackage ./mesonA/asharp.nix { };
    temporalmedian      = prev.callPackage ./mesonA/temporalmedian.nix { };
    tbilateral          = prev.callPackage ./mesonA/tbilateral.nix { };
    vcm                 = prev.callPackage ./mesonA/vcm.nix { };
    temporalsoften2     = prev.callPackage ./mesonA/temporalsoften2.nix { };
    motionmask          = prev.callPackage ./mesonA/motionmask.nix { };
    minideen            = prev.callPackage ./mesonA/minideen.nix { };
    cmedian             = prev.callPackage ./mesonA/cmedian.nix { };
    tcomb               = prev.callPackage ./mesonA/tcomb.nix { };
    dedot               = prev.callPackage ./mesonA/dedot.nix { };
    matchhistogram      = prev.callPackage ./mesonA/matchhistogram.nix { };
    smoothuv            = prev.callPackage ./mesonA/smoothuv.nix { };
    frfun7              = prev.callPackage ./mesonA/frfun7.nix { };
    awarpsharp2         = prev.callPackage ./mesonA/awarpsharp2.nix { };
    fillborders         = prev.callPackage ./mesonA/fillborders.nix { };
    median              = prev.callPackage ./mesonA/median.nix { };
    sangnom             = prev.callPackage ./mesonA/sangnom.nix { };
    tivtc               = prev.callPackage ./mesonA/tivtc.nix { };

    vfrtocfr            = prev.callPackage ./mesonA/vfrtocfr.nix { };
    fix-telecined-fades = prev.callPackage ./mesonA/fix-telecined-fades.nix { };


    #meson b refers to plugins that specify a install_dir we need to patch
    deblock              = prev.callPackage ./mesonB/deblock.nix { };
    miscfilters-obsolete = prev.callPackage ./mesonB/miscfilters-obsolete.nix { }; # but dep.get_pkgconfig....
    bm3d                 = prev.callPackage ./mesonB/bm3d.nix { };
    lghost               = prev.callPackage ./mesonB/lghost.nix { };
    bestsource           = prev.callPackage ./mesonB/bestsource.nix { };
    akarin               = prev.callPackage ./mesonB/akarin.nix { };
    cas                  = prev.callPackage ./mesonB/cas.nix { };
    ctmf                 = prev.callPackage ./mesonB/ctmf.nix { };
    tcolormask           = prev.callPackage ./mesonB/tcolormask.nix { };
    dctfilter            = prev.callPackage ./mesonB/dctfilter.nix { };
    dfttest              = prev.callPackage ./mesonB/dfttest.nix { };
    eedi2                = prev.callPackage ./mesonB/eedi2.nix { };
    eedi3m               = prev.callPackage ./mesonB/eedi3m.nix { };
    fft3dfilter          = prev.callPackage ./mesonB/fft3dfilter.nix { };
    libp2p               = prev.callPackage ./mesonB/libp2p.nix { };
    nnedi3cl             = prev.callPackage ./mesonB/nnedi3cl.nix { };
    ocr                  = prev.callPackage ./mesonB/ocr.nix { };
    placebo              = prev.callPackage ./mesonB/placebo.nix { };
    removegrain          = prev.callPackage ./mesonB/removegrain.nix { };
    retinex              = prev.callPackage ./mesonB/retinex.nix { };
    subtext              = prev.callPackage ./mesonB/subtext.nix { };
    tdeintmod            = prev.callPackage ./mesonB/tdeintmod.nix { };
    vivtc                = prev.callPackage ./mesonB/vivtc.nix { };
    vsrawsource          = prev.callPackage ./mesonB/vsrawsource.nix { };
    dpid                 = prev.callPackage ./mesonB/dpid.nix { };
    fftspectrum          = prev.callPackage ./mesonB/fftspectrum.nix { };
    deblockpp7           = prev.callPackage ./mesonB/deblockpp7.nix { };
    mvtools-sf           = prev.callPackage ./mesonB/mvtools-sf.nix { };# but vs.get_pkgconfig....
    butteraugli          = prev.callPackage ./mesonB/butteraugli.nix { };



    #meson C (lto)
    # there is one plugins that for some reason does not work with lto so I created a category for those
    # but most of them seem to work fine with lto even enabled ??? 
    bwdif        = prev.callPackage ./mesonC/bwdif.nix { };
    ttempsmooth  = prev.callPackage ./mesonC/ttempsmooth.nix { };
    addgrain     = prev.callPackage ./mesonC/addgrain.nix { };
    readmpls     = prev.callPackage ./mesonC/readmpls.nix { };
    imwri        = prev.callPackage ./mesonC/imwri.nix { };
    vmaf         = prev.callPackage ./mesonC/vmaf.nix { };
    rife         = prev.callPackage ./mesonC/rife.nix { };

    #tcanny is weird because it needs clangstdenv ???
    tcanny       = prev.callPackage ./other/tcanny.nix { };

    #automake
    cnr2           = prev.callPackage ./automake/cnr2.nix { };
    colorbars      = prev.callPackage ./automake/colorbars.nix { };
    degrainmedian  = prev.callPackage ./automake/degrainmedian.nix { };
    ssiq           = prev.callPackage ./automake/ssiq.nix { };
    histogram      = prev.callPackage ./automake/histogram.nix { };
    tonemap        = prev.callPackage ./automake/tonemap.nix { };
    bifrost        = prev.callPackage ./automake/bifrost.nix { };
    d2vsource      = prev.callPackage ./automake/d2vsource.nix { };
    fluxsmooth     = prev.callPackage ./automake/fluxsmooth.nix { };
    hqdn3d         = prev.callPackage ./automake/hqdn3d.nix { };
    nnedi3         = prev.callPackage ./automake/nnedi3.nix { };
    fieldhint      = prev.callPackage ./automake/fieldhint.nix { };
    scxvid         = prev.callPackage ./automake/scxvid.nix { };
    msmoosh        = prev.callPackage ./automake/msmoosh.nix { };
    fmtconv        = prev.callPackage ./automake/fmtconv.nix { }; # sourceroot
    chickendream   = prev.callPackage ./automake/chickendream.nix { }; # sourceroot


    #Irrational-Encoding-Wizardry
    vs-deband       = callPythonPackage ./iew/vs-deband.nix { };
    vs-rgtools      = callPythonPackage ./iew/vs-rgtools.nix { };
    vs-exprtools    = callPythonPackage ./iew/vs-exprtools.nix { };
    vs-kernels      = callPythonPackage ./iew/vs-kernels.nix { };
    vs-parsedvd     = callPythonPackage ./iew/vs-parsedvd.nix { };
    vs-pyplugin     = callPythonPackage ./iew/vs-pyplugin.nix { };
    vs-masktools    = callPythonPackage ./iew/vs-masktools.nix { };
    vs-tools        = callPythonPackage ./iew/vs-tools.nix { };
    vsmask          = callPythonPackage ./iew/vsmask.nix { };
    vs-dehalo       = callPythonPackage ./iew/vs-dehalo.nix { };
    vs-denoise      = callPythonPackage ./iew/vs-denoise.nix { };
    vs-aa           = callPythonPackage ./iew/vs-aa.nix {  };
    vs-scale        = callPythonPackage ./iew/vs-scale.nix { };
    vsutil          = callPythonPackage ./iew/vsutil { };
    vs-dfft         = callPythonPackage ./iew/vs-dfft.nix { };
    vs-deinterlace  = callPythonPackage ./iew/vs-deinterlace.nix { };

    #type other
    fvsfunc         = callPythonPackage ./funcs/fvsfunc.nix { };
    havsfunc        = callPythonPackage ./funcs/havsfunc.nix { };
    kagefunc        = callPythonPackage ./funcs/kagefunc { };
    muvsfunc        = callPythonPackage ./funcs/muvsfunc.nix { };
    xaa             = callPythonPackage ./funcs/xaa.nix { };
    Vine            = callPythonPackage ./funcs/Vine.nix { };
    Plum            = callPythonPackage ./funcs/Plum.nix { };
    atomchtools     = callPythonPackage ./funcs/atomchtools.nix { };
    cooldegrain     = callPythonPackage ./funcs/cooldegrain.nix { };
    wss             = callPythonPackage ./funcs/wss.nix { };
    maskdetail      = callPythonPackage ./funcs/maskdetail.nix { };
    Oyster          = callPythonPackage ./funcs/Oyster.nix { };
    dfmderainbow    = callPythonPackage ./funcs/dfmderainbow.nix { };
    astdr           = callPythonPackage ./funcs/astdr.nix { };
    hysteria        = callPythonPackage ./funcs/hysteria.nix { };
    adjust          = callPythonPackage ./funcs/adjust.nix { };
    edi_rpow2       = callPythonPackage ./funcs/edi_rpow2 { };
    mt_lutspa       = callPythonPackage ./funcs/mt_lutspa { };
    nnedi3_resample = callPythonPackage ./funcs/nnedi3_resample.nix { };
    nnedi3_rpow2    = callPythonPackage ./funcs/nnedi3_rpow2.nix { };
    vsTAAmbk        = callPythonPackage ./funcs/vsTAAmbk {  };
    xvs             = callPythonPackage ./funcs/xvs.nix {  };
    notvlc          = callPythonPackage ./funcs/notvlc.nix { };
    insaneAA        = callPythonPackage ./funcs/insaneAA.nix { };
    BalanceBorders  = callPythonPackage ./funcs/BalanceBorders.nix { };

    #type setuptools
    awsmfunc        = callPythonPackage ./funcs/awsmfunc.nix { };
    mvsfunc         = callPythonPackage ./funcs/mvsfunc.nix { };
    lvsfunc         = callPythonPackage ./funcs/lvsfunc.nix { };
    zzfunc          = callPythonPackage ./funcs/zzfunc.nix { };

    #packages
    rekt    = callPythonPackage ./pypackages/rekt.nix { };
    dnfunc  = callPythonPackage ./pypackages/dnfunc.nix { };

    vsgan   = callPythonPackage ./plugins/vsgan { };

    #python and binary plugin
    descale = prev.callPackage ./plugins/descale { };
    ccd     = prev.callPackage ./plugins/ccd { };



    #already in nixpkgs
    ffms2 = prev.callPackage ./other/ffms2.nix { };
    mvtools = prev.vapoursynth-mvtools;

    #rust
    adaptivegrain = prev.callPackage ./rust/adaptivegrain.nix { };
    bdngsp        = prev.callPackage ./rust/bdngsp.nix { };
    mpeg2stinx    = prev.callPackage ./rust/mpeg2stinx { };
    average       = prev.callPackage ./rust/average { };
    vs-nlq        = prev.callPackage ./rust/vs-nlq { };

    #waf
    f3kdb = prev.callPackage ./plugins/f3kdb { };

    #++++++++++++++++can use meson on update++++++++++++++++++++++++++++++++++++
    knlmeanscl = prev.callPackage ./plugins/knlmeanscl { };
    vstrt = prev.callPackage ./plugins/vstrt { };


    #meson normal install is correct folder
    beziercurve = prev.callPackage ./plugins/beziercurve { };
    remap = prev.callPackage ./plugins/remap { };


    #cmake
    dhce     = prev.callPackage ./plugins/dhce { };
    delogohd = prev.callPackage ./plugins/delogohd { };
    w2xnvk   = prev.callPackage ./plugins/w2xnvk { };

    #Gnumakefile + diy ./configure
    vaguedenoiser = prev.callPackage ./plugins/vaguedenoiser { };
    IT            = prev.callPackage ./plugins/IT { };
    combmask      = prev.callPackage ./plugins/combmask { };
    lsmashsource  = prev.callPackage ./plugins/lsmashsource { };
    tnlmeans      = prev.callPackage ./plugins/tnlmeans { }; # + patchShebangs

    #weird configure/special
    ReduceFlicker = prev.callPackage ./plugins/ReduceFlicker { };
    znedi3        = prev.callPackage ./plugins/znedi3 { };
    realsr        = prev.callPackage ./plugins/realsr { };
    bilateral     = prev.callPackage ./plugins/bilateral { }; # few oddities

    #not a plugin rather a library
    vapoursynth-plusplus = prev.callPackage ./plugins/vapoursynth-plusplus { };

    #single file python gist
    finedehalo = callPythonPackage ./plugins/finedehalo { };

    #overrides
    lsmashsource_akarin = ((prev.callPackage ./plugins/lsmashsource { }).overrideAttrs ( prev: rec {
      nativeBuildInputs = prev.nativeBuildInputs ++ [ final.meson final.ninja ];
      src = final.fetchFromGitHub {
        owner = "AkarinVS";
        repo = "L-SMASH-Works";
        rev = "e6ea8d9dd569e54e215558520c5efd429de14c62";
        sha256 = "sha256-pO8H2pv8TBAmlIu0bzWy2V6JgjOc2NARyPK6sKi/SLE=";
      };
      postPatch = ''
        substituteInPlace VapourSynth/meson.build \
            --replace "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
      '';
    }));

    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (python-final: python-prev: {
        styler00dollar-vsgan-trt = callPythonPackage ./tools/styler00dollar-vsgan-trt { };
      })
    ];
}