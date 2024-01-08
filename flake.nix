{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

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

    hover-hints = {
      url = "github:soulis-1256/hoverhints.nvim";
      flake = false;
    };

    neotest-vim-test = {
      url = "github:vim-test/vim-test";
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
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , flake-utils
    , gen-luarc
    , copilot
    , copilot-cmp
    , hover-hints
    , neotest-vim-test
    , neovim-nightly
    , nvim-luaref
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
            # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
            (neovim-overlay { inherit system; })
            # This adds a function can be used to generate a .luarc.json
            # containing the Neovim API all plugins in the workspace directory.
            # The generated file can be symlinked in the devShell's shellHook.
            gen-luarc.overlays.default
          ];
        };
        shell = pkgs.mkShell {
          name = "nvim-devShell";
          buildInputs = with pkgs; [
            # Tools for Lua and Nix development, useful for editing files in this repo
            lua-language-server
            nil
            stylua
            luajitPackages.luacheck
          ];
          shellHook = ''
            # symlink the .luarc.json generated in the overlay
            ln -fs ${pkgs.nvim-luarc-json} .luarc.json
          '';
        };
      in
      {
        devShells = {
          default = shell;
        };
        packages = rec {
          default = nvim;
          nvim = pkgs.nvim-pkg;
        };
        # You can add this overlay to your NixOS configuration
        overlays = {
          default = (neovim-overlay { inherit system; });
        };
      });
}
