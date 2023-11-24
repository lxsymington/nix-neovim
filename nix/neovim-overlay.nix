# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
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
    # ^ nvim-cmp extensions
    (mkNvimPlugin inputs.copilot "copilot") # AI coding assistance | https://github.com/zbirenbaum/copilot.lua
    (mkNvimPlugin inputs.copilot-cmp "copilot-cmp") # Copilot Completion | https://github.com/zbirenbaum/copilot.lua
    # git integration plugins
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    vim-fugitive # https://github.com/tpope/vim-fugitive/
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions
    # UI
    everforest # colorscheme | https://github.com/sainnhe/everforest/
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    aerial-nvim # Document Outline | https://github.com/stevearc/aerial.nvim
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # nvim-treesitter-context
    nvim-notify # Editor notification | https://github.com/rcarriga/nvim-notify/
    dressing-nvim # UI Enhancements | https://github.com/stevearc/dressing.nvim/
    # ^ UI
    # language support
    nvim-lint # An asynchronous linter plugin | https://github.com/mfussenegger/nvim-lint/
    conform-nvim # An asynchronous formatter | https://github.com/stevearc/conform.nvim/
    refactoring-nvim # Language agnostic refactors | https://github.com/ThePrimeagen/refactoring.nvim/
    SchemaStore-nvim # JSON Schema support | https://github.com/b0o/SchemaStore.nvim/
    # ^ language support
    # navigation/editing enhancement plugins
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    oil-nvim # A vim-vinegar like file explorer | https://github.com/stevearc/oil.nvim/
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    # ^ navigation/editing enhancement plugins
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
    # bleeding-edge plugins from flake inputs
    # ^ bleeding-edge plugins from flake inputs
    which-key-nvim
    # Vim utilities
    (mkNvimPlugin inputs.nvim-luaref "nvim-luaref") # Lua reference for Nvim | https://github.com/milisims/nvim-luaref
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    deno
    gopls
    lua-language-server
    nil # Nix LSP
    nodePackages_latest.prettier
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-langservers-extracted # HTML/CSS/JSON/ESLint LSP
    nodePackages_latest.yaml-language-server
    prettierd
    rust-analyzer # Rust LSP
    selene # Lua linter
    stylua
    # TODO: Sort this out!
    # (mkYarnPackage {
    #   name = "tslint";

    #   src = inputs.tslint.outPath;

    #   packageJSON = builtins.trace "${inputs.tslint.outPath}/package.json" "${inputs.tslint.outPath}/package.json";

    #   yarnLock = builtins.trace "${inputs.tslint.outPath}/yarn.lock" "${inputs.tslint.outPath}/yarn.lock";

    #   buildPhase = ''
    #     echo "BUILDING"
    #     export HOME=$(mktemp -d)
    #     yarn --offline compile:core
    #   '';
    # })
    vim-vint # Vim linter
  ];
in
{
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
