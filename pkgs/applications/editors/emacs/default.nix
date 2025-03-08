{ lib, pkgs }:

lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
    inheritedArgs = {
      inherit (pkgs.darwin) sigtool;
      inherit (pkgs.darwin.apple_sdk.frameworks)
        Accelerate
        AppKit
        Carbon
        Cocoa
        GSS
        ImageCaptureCore
        ImageIO
        IOKit
        OSAKit
        Quartz
        QuartzCore
        WebKit
        ;
      inherit (pkgs.darwin.apple_sdk_11_0.frameworks) UniformTypeIdentifiers;
    };
  in
  {
    sources = import ./sources.nix {
      inherit lib;
      inherit (pkgs)
        fetchFromBitbucket
        fetchFromSavannah
        ;
    };

    emacs28 = callPackage (self.sources.emacs28) inheritedArgs;

  ...
  }
)
