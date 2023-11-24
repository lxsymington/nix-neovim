{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    copilot = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };

    copilot-cmp = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };

    nvim-luaref = {
      url = "github:milisims/nvim-luaref";
      flake = false;
    };

    tslint = {
      url = "github:palantir/tslint";
      flake = false;
    };

    wf-nvim = {
      url = "github:Cassin01/wf.nvim";
      flake = false;
    };
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , flake-utils
    , copilot
    , copilot-cmp
    , nvim-luaref
    , tslint
    , wf-nvim
    , ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # This is where the Neovim derivation is built.
      neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };
    in
    flake-utils.lib.eachSystem supportedSystems
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            neovim-overlay
          ];
        };
        shell = pkgs.mkShell {
          name = "nvim-devShell";
          buildInputs = with pkgs; [
            lua-language-server
            nil
            stylua
            luajitPackages.luacheck
          ];
        };
      in
      {
        packages = rec {
          default = nvim;
          nvim = pkgs.lxs-nvim;
        };
        devShells = {
          default = shell;
        };
      })
    // {
      # You can add this overlay to your NixOS configuration
      overlays.default = neovim-overlay;
    };
}
