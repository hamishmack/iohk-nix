{ system, compiler, flags, pkgs, hsPkgs, pkgconfPkgs, ... }:
  {
    flags = { ghci = false; };
    package = {
      specVersion = "1.10";
      identifier = { name = "ghci"; version = "8.4.4"; };
      license = "BSD-3-Clause";
      copyright = "";
      maintainer = "ghc-devs@haskell.org";
      author = "";
      homepage = "";
      url = "";
      synopsis = "The library supporting GHC's interactive interpreter";
      description = "This library offers interfaces which mediate interactions between the\n@ghci@ interactive shell and @iserv@, GHC's out-of-process interpreter\nbackend.";
      buildType = "Simple";
      };
    components = {
      "library" = {
        depends = [
          (hsPkgs.array)
          (hsPkgs.base)
          (hsPkgs.binary)
          (hsPkgs.bytestring)
          (hsPkgs.containers)
          (hsPkgs.deepseq)
          (hsPkgs.filepath)
          (hsPkgs.ghc-boot)
          (hsPkgs.ghc-boot-th)
          (hsPkgs.template-haskell)
          (hsPkgs.transformers)
          ] ++ (pkgs.lib).optional (!system.isWindows) (hsPkgs.unix);
        };
      };
    } // rec { src = pkgs.fetchurl { url = http://releases.mobilehaskell.org/ghc-packages/ghci-8.4.4.tar.gz; sha256 = "08mwiffslm4dlxykfpwhzq6qbxq30dm9bdp5pd04jw411hfwgnxi"; }; }
