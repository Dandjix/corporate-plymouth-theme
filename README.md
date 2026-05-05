# Evangelion UI Plymouth Theme

WARNING - SEIZURE RISK - FLASHING LIGHTS

This is a fan made Plymouth splash animation inspired by UI elements from Neon Genesis Evangelion.
Here is a preview of the animation:
![Neon Genesis Evangelion UI Animations](preview.gif)

## Installation & Usage

### Standard Linux distros

```bash
# Run the install script
sh install.sh

# To uninstall:
sh uninstall.sh
```

### NixOS Flake

Add to your flake inputs:

```nix
{
  inputs = {
    evangelion-ui.url = "gitlab:lobstermane/evangelion-ui";
    evangelion-ui.inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then in your NixOS configuration:

```nix
boot.plymouth = {
  enable = true;
  themePackages = [ inputs.evangelion-ui.packages.${pkgs.system}.evangelion-ui ];
  theme = "evangelion-ui";
};
```

Enjoy!
