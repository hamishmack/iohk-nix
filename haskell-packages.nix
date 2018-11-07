{ pkgs
, forceDontCheck
, enableProfiling
, enablePhaseMetrics
, enableBenchmarks
, fasterBuild
, enableDebugging
, filter
, requiredOverlay
}:

with pkgs.lib;

let
  # the GHC we are using
  ghc = pkgs.haskell.compiler.ghc822;

  # This will yield a set of haskell packages, based on the given compiler.
  kgsBase = ((import ../pkgs { inherit pkgs; }).override {
    inherit ghc;
  });

  # Overlay logic for *haskell* packages.
  requiredOverlay    = import requiredOverlay             { inherit pkgs enableProfiling; };
  benchmarkOverlay   = import ./overlays/benchmark.nix    { inherit pkgs filter; };
  debugOverlay       = import ./overlays/debug.nix        { inherit pkgs; };
  fasterBuildOverlay = import ./overlays/faster-build.nix { inherit pkgs filter; };
  dontCheckOverlay   = import ./overlays/dont-check.nix   { inherit pkgs; };
  metricOverlay      = import ./overlays/metric.nix       { inherit pkgs; };

  activeOverlays = [ requiredOverlay ]
      ++ optional enablePhaseMetrics metricOverlay
      ++ optional enableBenchmarks benchmarkOverlay
      ++ optional enableDebugging debugOverlay
      ++ optional forceDontCheck dontCheckOverlay
      ++ optional fasterBuild fasterBuildOverlay;

in
  # Apply all the overlays on top of the base package set generated by stack2nix
  builtins.foldl' (pkgs: overlay: pkgs.extend overlay) pkgsBase activeOverlays