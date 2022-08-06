{ lib, ... }:
let
  inherit (lib) isString mkOption mkOptionType options types;
  isFloat = x: isString x && builtins.match "^[+-]?([0-9]*[.])?[0-9]+$" x != null;

  float = mkOptionType {
    name = "float";
    description = "float";
    check = isFloat;
    merge = options.mergeOneOption;
  };
in {
  imports = [];
  options = {
    system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" =
      mkOption {
        type = types.nullOr float;
        default = null;
        description = ''
          Sets the mouse tracking speed. Found in the "Mouse" section of
          "System Preferences". Set to -1 to disable mouse acceleration.
        '';
      };
  };
}
