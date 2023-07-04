{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, fontconfig
, pkg-config
, CoreText
, makeFontsConf
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ ];
  };
in
rustPlatform.buildRustPackage rec {
  pname = "hdr10plus_tool";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = pname;
    rev = version;
    hash = "sha256-EyKCdrilb6Ha9avEe5L4Snbufq8pEiTvr8tcdj0M6Zs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "plotters-0.3.5" = "sha256-cz8/chdq8C/h1q5yFcQp0Rzg89XHnQhIN1Va52p6Z2Y=";
    };
  };

  postPatch = lib.optionals stdenv.isDarwin ''
    substituteInPlace tests/metadata/plot.rs --replace \
      "assert.success().stderr(predicate::str::is_empty());" \
      "assert.success();"
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    fontconfig
  ] ++ lib.optionals stdenv.isDarwin [
    CoreText
  ];

  # This is needed for the plot tests with sandboxing enabled.
  __impureHostDeps = lib.optionals stdenv.isDarwin [
    "/System/Library/Fonts/Supplemental/Arial.ttf"
  ];

  preCheck = lib.optionals stdenv.isLinux ''
    # Fontconfig error: Cannot load default config file: No such file: (null)
    export FONTCONFIG_FILE="${fontsConf}"
    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "CLI tool combining multiple utilities for working with Dolby Vision";
    homepage = "https://github.com/quietvoid/dovi_tool";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
