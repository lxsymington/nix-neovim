{ inputs, system }: final: prev:
with final.pkgs.lib; let
  inherit (builtins) elem;

  pkgs = final;

  isDarwin = elem system pkgs.lib.platforms.darwin;

  # Use this to create a plugin from an input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  mkNeovim = pkgs.callPackage ./mkNeovim.nix { };

  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    nvim-treesitter.withAllGrammars
    luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    # nvim-cmp (autocompletion) and extensions
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions
    cmp-git # cmp git suggestions | https://github.com/petertriho/cmp-git/
    # ^ nvim-cmp extensions
    (mkNvimPlugin inputs.copilot "copilot") # AI coding assistance | https://github.com/zbirenbaum/copilot.lua
    (mkNvimPlugin inputs.copilot-cmp "copilot-cmp") # Copilot Completion | https://github.com/zbirenbaum/copilot.lua
    # git integration plugins
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    octo-nvim # httpd://github.com/pwntester/octo.nvim/
    vim-fugitive # https://github.com/tpope/vim-fugitive/
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    (mkNvimPlugin inputs.telescope-frecency "telescope-frecency") # https://github.com/nvim-telescope/telescope-frecency.nvim/
    telescope-symbols-nvim # https://github.com/nvim-telescope/telescope-symbols.nvim/
    # ^ telescope and extensions
    # UI
    lush-nvim # colorscheme | https://github.com/rktjmp/lush.nvim/
    rose-pine # colorscheme | https://github.com/rose-pine/neovim
    (mkNvimPlugin inputs.nougat "nougat") # A vim statusline plugin | https://github.com/MunifTanjim/nougat.nvim
    aerial-nvim # Document Outline | https://github.com/stevearc/aerial.nvim
    (mkNvimPlugin inputs.statuscol "statuscol") # Status column | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # nvim-treesitter-context
    nvim-notify # Editor notification | https://github.com/rcarriga/nvim-notify/
    dressing-nvim # UI Enhancements | https://github.com/stevearc/dressing.nvim/
    which-key-nvim # keymap hints | https://github.com/folke/which-key.nvim/
    todo-comments-nvim # Smarter comments | https://github.com/folke/todo-comments.nvim/
    indent-blankline-nvim # Indent guides | https://github.com/lukas-reineke/indent-blankline.nvim/
    marks-nvim # Mark enhancements | https://github.com/chentoast/marks.nvim/
    satellite-nvim # Mini map | https://github.com/lewis6991/satellite.nvim/
    nvim-bqf # Better quickfix | https://github.com/kevinhwang91/nvim-bqf/
    # ^ UI
    # language support
    neodev-nvim # adds support for Neovim's Lua API to lua-language-server | https://github.com/folke/neodev.nvim/
    nvim-lint # An asynchronous linter plugin | https://github.com/mfussenegger/nvim-lint/
    conform-nvim # An asynchronous formatter | https://github.com/stevearc/conform.nvim/
    refactoring-nvim # Language agnostic refactors | https://github.com/ThePrimeagen/refactoring.nvim/
    SchemaStore-nvim # JSON Schema support | https://github.com/b0o/SchemaStore.nvim/
    trouble-nvim # diagnostic aggregator panel | https://github.com/folke/trouble.nvim/
    comment-nvim # Comment helper | https://github.com/numtostr/comment.nvim
    neogen # Doc comment helper | https://github.com/danymat/neogen/
    # ^ language support
    # navigation/editing enhancement plugins
    oil-nvim # A vim-vinegar like file explorer | https://github.com/stevearc/oil.nvim/
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    # ^ navigation/editing enhancement plugins
    # Code running
    neotest # Testing framework | https://github.com/nvim-neotest/neotest/
    neotest-jest # Jest support | https://github.com/nvim-neotest/neotest-jest/
    sniprun # Repl | https://github.com/michaelb/sniprun 
    vim-test # Testing framework | https://github.com/vim-test/vim-test/
    (mkNvimPlugin inputs.neotest-vim-test "neotest-vim-test") # Test adapter | https://github.com/nvim-neotest/neotest-vim-test/
    overseer-nvim # task management | https://github.com/stevearc/overseer.nvim/
    # ^ Code running
    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    vim-startuptime # Profile startup time | https://github.com/dstein64/vim-startuptime
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    # ^ libraries that other plugins depend on
    # Vim utilities
    (mkNvimPlugin inputs.nvim-luaref "nvim-luaref") # Lua reference for Nvim | https://github.com/milisims/nvim-luaref
    # ^ Vim utilities
    # Miscellaneous
    vim-markdown-composer # Markdown support | https://github.com/euclio/vim-markdown-composer/
    # ^ Miscellaneous
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    deno
    fzf
    gh
    gopls
    lua-language-server
    nil # Nix LSP
    nodePackages_latest.prettier
    nodePackages_latest.ts-node
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-langservers-extracted # HTML/CSS/JSON/ESLint LSP
    nodePackages_latest.yaml-language-server
    prettierd
    rust-analyzer # Rust LSP
    selene # Lua linter
    stylua
    terraform
    terraform-ls
    typescript
    (mkYarnPackage {
      name = "tslint";
      version = "6.1.3";

      src = inputs.tslint.outPath;
      packageJson = "${inputs.tslint.outPath}/package.json";
      yarnLock = "${inputs.tslint.outPath}/yarn.lock";

      offlineCache = pkgs.fetchYarnDeps {
        yarnLock = inputs.tslint.outPath + "/yarn.lock";
        hash = "sha256-xfN1nZXPspHtQnCxNtGBVRrX7I3X8H20gXbslqzp9Io=";
      };

      packageResolutions = {
        "tslint-test-config-non-relative" = "${inputs.tslint.outPath}/test/external/tslint-test-config-non-relative";
      };

      buildPhase = ''
        runHook preBuild
           
        yarn --offline compile

        runHook postBuild
      '';

      meta = with pkgs.lib; {
        description = "An extensible linter for the TypeScript language";
        homepage = "https://github.com/palantir/tslint";
        license = licenses.mit;
        maintainers = with maintainers; [ lxsymington ];
      };
    })
    vale
    vim-vint # Vim linter
  ];
in
{
  # This is the neovim derivation
  # returned by the overlay
  lxs-nvim = mkNeovim {
    neovimPackage = inputs.neovim-nightly.packages.${system}.default;
    plugins = all-plugins;
    inherit extraPackages isDarwin;
  };

  # You can add as many derivations as you like.
}
