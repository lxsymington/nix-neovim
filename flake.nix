{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    gen-luarc = {
      url = "github:mrcjkb/nix-gen-luarc-json";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blink-cmp = {
      url = "github:Saghen/blink.cmp";
      flake = true;
    };

    blink-cmp-copilot = {
      url = "github:giuxtaposition/blink-cmp-copilot";
      flake = false;
    };

    blink-compat = {
      url = "github:Saghen/blink.compat";
      flake = false;
    };

    /* bqf = {
      url = "github:kevinhwang91/nvim-bqf";
      flake = false;
    }; */

    copilot = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };

    copilot-chat = {
      url = "github:CopilotC-Nvim/CopilotChat.nvim";
      flake = false;
    };

    copilot-cmp = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };

    csvview = {
      url = "github:hat0uma/csvview.nvim";
      flake = false;
    };

    dbee-binary = {
      url = "github:kndndrj/nvim-dbee?dir=dbee";
      flake = false;
    };

    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    helpview = {
      url = "github:OXY2DEV/helpview.nvim";
      flake = false;
    };

    hurl-nvim = {
      url = "github:jellydn/hurl.nvim";
      flake = false;
    };

    lazydev = {
      url = "github:folke/lazydev.nvim";
      flake = false;
    };

    luasnip = {
      url = "github:L3MON4D3/LuaSnip?ref=v2.3.0";
      flake = false;
    };

    luvit-meta = {
      url = "github:Bilal2453/luvit-meta";
      flake = false;
    };

    markview = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
    };

    mini-git = {
      url = "github:echasnovski/mini-git";
      flake = false;
    };

    mini-hipatterns = {
      url = "github:echasnovski/mini.hipatterns";
      flake = false;
    };

    mini-icons = {
      url = "github:echasnovski/mini.icons";
      flake = false;
    };

    mini-pairs = {
      url = "github:echasnovski/mini.pairs";
      flake = false;
    };

    mini-starter = {
      url = "github:echasnovski/mini.starter";
      flake = false;
    };

    mini-surround = {
      url = "github:echasnovski/mini.surround";
      flake = false;
    };

    neogit = {
      url = "github:NeogitOrg/neogit?ref=master";
      flake = false;
    };

    /* neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    }; */

    neotest-mocha = {
      url = "github:adrigzr/neotest-mocha";
      flake = false;
    };

    neotest-vim-test = {
      url = "github:nvim-neotest/neotest-vim-test";
      flake = false;
    };

    nougat = {
      url = "github:MunifTanjim/nougat.nvim";
      flake = false;
    };

    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    nvim-luaref = {
      url = "github:milisims/nvim-luaref";
      flake = false;
    };

    quicker = {
      url = "github:stevearc/quicker.nvim";
      flake = false;
    };

    reactive = {
      url = "github:rasulomaroff/reactive.nvim";
      flake = false;
    };

    resession = {
      url = "github:stevearc/resession.nvim";
      flake = false;
    };

    screenkey = {
      url = "github:NStefan002/screenkey.nvim";
      flake = false;
    };

    statuscol = {
      url = "github:luukvbaal/statuscol.nvim";
      flake = false;
    };

    symbol-usage = {
      url = "github:Wansmer/symbol-usage.nvim";
      flake = false;
    };

    telescope-frecency = {
      url = "github:nvim-telescope/telescope-frecency.nvim";
      flake = false;
    };

    treesj = {
      url = "github:Wansmer/treesj";
      flake = false;
    };

    true-zen = {
      url = "github:Pocco81/true-zen.nvim";
      flake = false;
    };

    tsc-nvim = {
      url = "github:dmmulroy/tsc.nvim";
      flake = false;
    };

    tslint = {
      url = "github:palantir/tslint";
      flake = false;
    };

    nvim-vtsls = {
      url = "github:yioneko/nvim-vtsls";
      flake = false;
    };

    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
  };

  # neorg-overlay
  outputs =
    inputs @ { nixpkgs
    , flake-utils
    , gen-luarc
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
            # neorg-overlay.overlays.default
          ];
        };
        shell = pkgs.mkShell {
          name = "nvim-devShell";
          buildInputs = with pkgs; [
            # Tools for Lua and Nix development, useful for editing files in this repo
            lua-language-server
            nixd
            stylua
            luajitPackages.luacheck
            luajitPackages.tiktoken_core
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
          nvim = pkgs.lxs-nvim;
        };
        # You can add this overlay to your NixOS configuration
        overlays = {
          default = pkgs.lib.composeManyExtensions [
            gen-luarc.overlays.default
            # neorg-overlay.overlays.default
            (neovim-overlay { inherit system; })
          ];
        };
      });
}
