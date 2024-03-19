{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim-nightly = {
      url = "github:neovim/neovim?dir=contrib";
    };

    copilot = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };

    copilot-cmp = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };

    neotest-vim-test = {
      url = "github:vim-test/vim-test";
      flake = false;
    };

    nougat = {
      url = "github:MunifTanjim/nougat.nvim";
      flake = false;
    };

    nvim-luaref = {
      url = "github:milisims/nvim-luaref";
      flake = false;
    };

    statuscol = {
      url = "github:luukvbaal/statuscol.nvim";
      flake = false;
    };

    telescope-frecency = {
      url = "github:nvim-telescope/telescope-frecency.nvim";
      flake = false;
    };

    tslint = {
      url = "github:palantir/tslint";
      flake = false;
    };
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , flake-utils
    , neovim-nightly
    , tslint
    , ...
    }:
    let
      # This is where the Neovim derivation is built.
      neovim-overlay = { system ? builtins.currentSystem }:
        (import ./nix/neovim-overlay.nix { inherit inputs system; });
    in
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
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
        # You can add this overlay to your NixOS configuration
        overlays = {
          default = (neovim-overlay { inherit system; });
        };
      });
}
