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
      # This is where the Neovim derivation is built.
      neovim-overlay = { system ? "x86_64-linux" }:
        (import ./nix/neovim-overlay.nix { inherit inputs system; });
    in
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (neovim-overlay { inherit system; })
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
        devShells = {
          default = shell;
        };
        packages = rec {
          default = nvim;
          nvim = pkgs.lxs-nvim;
        };
      })
    // {
      # You can add this overlay to your NixOS configuration
      overlays.default = (neovim-overlay { });
    };
}
