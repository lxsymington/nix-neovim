{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs.git?ref=nixpkgs-unstable";

    flake-utils = {
      url = "git+ssh://git@github.com/numtide/flake-utils";
    };

    gen-luarc = {
      url = "git+ssh://git@github.com/mrcjkb/nix-gen-luarc-json";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "git+ssh://git@github.com/nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blink-cmp = {
      url = "git+ssh://git@github.com/Saghen/blink.cmp";
      flake = true;
    };

    blink-copilot = {
      url = "git+ssh://git@github.com/fang2hou/blink-copilot";
      flake = false;
    };

    blink-compat = {
      url = "git+ssh://git@github.com/Saghen/blink.compat";
      flake = false;
    };

    bqf = {
      url = "git+ssh://git@github.com/kevinhwang91/nvim-bqf";
      flake = false;
    };

    copilot = {
      url = "git+ssh://git@github.com/zbirenbaum/copilot.lua";
      flake = false;
    };

    codecompanion = {
      url = "git+ssh://git@github.com/olimorris/codecompanion.nvim";
      flake = false;
    };

    csvview = {
      url = "git+ssh://git@github.com/hat0uma/csvview.nvim";
      flake = false;
    };

    dap-view = {
      url = "git+ssh://git@github.com/igorlfs/nvim-dap-view";
      flake = false;
    };

    nvim-dbee = {
      url = "git+ssh://git@github.com/kndndrj/nvim-dbee";
      flake = false;
    };

    demicolon = {
      url = "git+ssh://git@github.com/mawkler/demicolon.nvim";
      flake = false;
    };

    dial = {
      url = "git+ssh://git@github.com/monaqa/dial.nvim";
      flake = false;
    };

    eyeliner = {
      url = "git+ssh://git@github.com/jinh0/eyeliner.nvim";
      flake = false;
    };

    faster = {
      url = "git+ssh://git@github.com/pteroctopus/faster.nvim";
      flake = false;
    };

    fidget = {
      url = "git+ssh://git@github.com/j-hui/fidget.nvim";
      flake = false;
    };

    gitsigns = {
      url = "git+ssh://git@github.com/lewis6991/gitsigns.nvim";
      flake = false;
    };

    helpview = {
      url = "git+ssh://git@github.com/OXY2DEV/helpview.nvim";
      flake = false;
    };

    hover = {
      url = "git+ssh://git@github.com/lewis6991/hover.nvim";
      flake = false;
    };

    hurl-nvim = {
      url = "git+ssh://git@github.com/jellydn/hurl.nvim";
      flake = false;
    };

    jirac = {
      url = "git+ssh://git@github.com/janBorowy/jirac.nvim";
      flake = false;
    };

    lazydev = {
      url = "git+ssh://git@github.com/folke/lazydev.nvim";
      flake = false;
    };

    lualine = {
      url = "git+ssh://git@github.com/nvim-lualine/lualine.nvim";
      flake = false;
    };

    luasnip = {
      url = "git+ssh://git@github.com/L3MON4D3/LuaSnip.git?ref=refs/tags/v2.4.0";
      flake = false;
    };

    luvit-meta = {
      url = "git+ssh://git@github.com/Bilal2453/luvit-meta";
      flake = false;
    };

    marks = {
      url = "git+ssh://git@github.com/chentoast/marks.nvim";
      flake = false;
    };

    markview = {
      url = "git+ssh://git@github.com/OXY2DEV/markview.nvim";
      flake = false;
    };

    mcp-hub = {
      url = "git+ssh://git@github.com/ravitemer/mcp-hub";
    };

    mcp-hub-nvim = {
      url = "git+ssh://git@github.com/ravitemer/mcphub.nvim";
    };

    mini-diff = {
      url = "git+ssh://git@github.com/echasnovski/mini.diff";
      flake = false;
    };

    mini-git = {
      url = "git+ssh://git@github.com/echasnovski/mini-git";
      flake = false;
    };

    mini-hipatterns = {
      url = "git+ssh://git@github.com/echasnovski/mini.hipatterns";
      flake = false;
    };

    mini-icons = {
      url = "git+ssh://git@github.com/echasnovski/mini.icons";
      flake = false;
    };

    mini-pairs = {
      url = "git+ssh://git@github.com/echasnovski/mini.pairs";
      flake = false;
    };

    mini-starter = {
      url = "git+ssh://git@github.com/echasnovski/mini.starter";
      flake = false;
    };

    mini-surround = {
      url = "git+ssh://git@github.com/echasnovski/mini.surround";
      flake = false;
    };

    neogit = {
      url = "git+ssh://git@github.com/NeogitOrg/neogit?ref=master";
      flake = false;
    };

    neorg-overlay = {
      url = "git+ssh://git@github.com/nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neotest-mocha = {
      url = "git+ssh://git@github.com/adrigzr/neotest-mocha";
      flake = false;
    };

    neotest-vim-test = {
      url = "git+ssh://git@github.com/nvim-neotest/neotest-vim-test";
      flake = false;
    };

    nui-components = {
      url = "git+ssh://git@github.com/grapp-dev/nui-components.nvim";
      flake = false;
    };

    nui-nvim = {
      url = "git+ssh://git@github.com/MunifTanjim/nui.nvim";
      flake = false;
    };

    nvim-luaref = {
      url = "git+ssh://git@github.com/milisims/nvim-luaref";
      flake = false;
    };

    nvim-recorder = {
      url = "git+ssh://git@github.com/chrisgrieser/nvim-recorder";
      flake = false;
    };

    quicker = {
      url = "git+ssh://git@github.com/stevearc/quicker.nvim";
      flake = false;
    };

    reactive = {
      url = "git+ssh://git@github.com/rasulomaroff/reactive.nvim";
      flake = false;
    };

    recall = {
      url = "git+ssh://git@github.com/fnune/recall.nvim";
      flake = false;
    };

    resession = {
      url = "git+ssh://git@github.com/stevearc/resession.nvim";
      flake = false;
    };

    screenkey = {
      url = "git+ssh://git@github.com/NStefan002/screenkey.nvim";
      flake = false;
    };

    shipwright = {
      url = "git+ssh://git@github.com/rktjmp/shipwright.nvim";
      flake = false;
    };

    sonarqube = {
      url = "git+ssh://git@github.com/iamkarasik/sonarqube.nvim";
      flake = false;
    };

    statuscol = {
      url = "git+ssh://git@github.com/luukvbaal/statuscol.nvim";
      flake = false;
    };

    symbol-usage = {
      url = "git+ssh://git@github.com/Wansmer/symbol-usage.nvim";
      flake = false;
    };

    telescope-frecency = {
      url = "git+ssh://git@github.com/nvim-telescope/telescope-frecency.nvim";
      flake = false;
    };

    treesj = {
      url = "git+ssh://git@github.com/Wansmer/treesj";
      flake = false;
    };

    true-zen = {
      url = "git+ssh://git@github.com/Pocco81/true-zen.nvim";
      flake = false;
    };

    tsc-nvim = {
      url = "git+ssh://git@github.com/dmmulroy/tsc.nvim";
      flake = false;
    };

    tslint = {
      url = "git+ssh://git@github.com/palantir/tslint";
      flake = false;
    };

    nvim-vtsls = {
      url = "git+ssh://git@github.com/yioneko/nvim-vtsls";
      flake = false;
    };

    vimade = {
      url = "git+ssh://git@github.com/TaDaa/vimade";
      flake = false;
    };

    which-key = {
      url = "git+ssh://git@github.com/folke/which-key.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-utils,
    gen-luarc,
    neorg-overlay,
    ...
  }: let
    # This is where the Neovim derivation is built.
    neovim-overlay = {system ? builtins.currentSystem}: (import ./nix/neovim-overlay.nix {inherit inputs system;});
  in
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [
          # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
          (neovim-overlay {inherit system;})
          # This adds a function can be used to generate a .luarc.json
          # containing the Neovim API all plugins in the workspace directory.
          # The generated file can be symlinked in the devShell's shellHook.
          gen-luarc.overlays.default
          neorg-overlay.overlays.default
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
    in {
      formatter = pkgs.alejandra;
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
          neorg-overlay.overlays.default
          (neovim-overlay {inherit system;})
        ];
      };
    });
}
