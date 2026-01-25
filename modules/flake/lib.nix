{ lib, ... }:
{
  flake.lib = lib.extend (
    final: prev: {
      custom = {
        /*
          Recursively merge a list of attrsets into a single attrset.

          nix-repl> recursiveMergeAttrs [ { a = "foo"; } { b = "bar"; } ];
          { a = "foo"; b = "bar"; }
          nix-repl> recursiveMergeAttrs [ { a.b = "foo"; } { a.c = "bar"; } ]
          { a = { b = "foo"; c = "bar"; }; }
        */
        recursiveMergeAttrs = builtins.foldl' lib.recursiveUpdate { };

        /*
          Use path relative to the root of the project
          Copy: https://github.com/EmergentMind/nix-config-starter/blob/master/lib/default.nix
        */
        relativeToRoot = lib.path.append ../../.;
        scanPaths =
          path:
          map (f: (path + "/${f}")) (
            builtins.attrNames (
              lib.attrsets.filterAttrs (
                path: _type:
                (_type == "directory") # include directories
                || (
                  (path != "default.nix") # ignore default.nix
                  && (lib.strings.hasSuffix ".nix" path) # include .nix files
                )
              ) (builtins.readDir path)
            )
          );

        /*
          And etc
          ...
        */

      }; # end of custom
    }
  );
}
