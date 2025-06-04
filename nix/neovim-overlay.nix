# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{
  inputs,
  system,
}: final: prev: let
  inherit (builtins) elem;
  inherit (inputs.blink-cmp.packages.${system}) blink-cmp;

  pkgs = final;

  isDarwin = elem system pkgs.lib.platforms.darwin;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = {
    buildInputs ? [],
    dependencies ? [],
    nvimSkipModule ? [],
    passthru ? {},
    propagatedBuildInputs ? [],
    pname,
    src,
  }:
    pkgs.vimUtils.buildVimPlugin {
      inherit buildInputs dependencies nvimSkipModule passthru propagatedBuildInputs pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {inherit pkgs-wrapNeovim;};

  nui = mkNvimPlugin {
    pname = "nui";
    src = inputs.nui-nvim;
  };
  nui-components = mkNvimPlugin {
    dependencies = [
      nui
    ];
    pname = "nui-components";
    src = inputs.nui-components;
  };
  luasnip = mkNvimPlugin {
    pname = "luasnip";
    src = inputs.luasnip;
  };
  copilot = mkNvimPlugin {
    pname = "copilot";
    src = inputs.copilot;
  };
  blink-compat = mkNvimPlugin {
    pname = "blink-compat";
    src = inputs.blink-compat;
  };
  blink-copilot = mkNvimPlugin {
    dependencies = [copilot];
    pname = "blink-copilot";
    src = inputs.blink-copilot;
  };
  neogit = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.diffview-nvim
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.telescope-nvim
    ];
    nvimSkipModule = [
      "neogit.integrations.diffview"
      "neogit.popups.diff.init"
      "neogit.popups.diff.actions"
    ];
    pname = "neogit";
    src = inputs.neogit;
  };
  gitsigns = mkNvimPlugin {
    nvimSkipModule = [
      "lualsreport"
    ];
    pname = "gitsigns";
    src = inputs.gitsigns;
  };
  mini-diff = mkNvimPlugin {
    pname = "mini-diff";
    src = inputs.mini-diff;
  };
  mini-git = mkNvimPlugin {
    pname = "mini-git";
    src = inputs.mini-git;
  };
  telescope-frecency = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.plenary-nvim
    ];
    nvimSkipModule = [
      "frecency.types"
    ];
    pname = "telescope-frecency";
    src = inputs.telescope-frecency;
  };
  statuscol = mkNvimPlugin {
    pname = "statuscol";
    src = inputs.statuscol;
  };
  which-key = mkNvimPlugin {
    nvimSkipModule = [
      "which-key.docs"
    ];
    pname = "which-key";
    src = inputs.which-key;
  };
  reactive = mkNvimPlugin {
    pname = "reactive";
    src = inputs.reactive;
  };
  screenkey = mkNvimPlugin {
    pname = "screenkey";
    src = inputs.screenkey;
  };
  true-zen = mkNvimPlugin {
    pname = "true-zen";
    src = inputs.true-zen;
  };
  mini-starter = mkNvimPlugin {
    pname = "mini-starter";
    src = inputs.mini-starter;
  };
  lualine = mkNvimPlugin {
    pname = "lualine";
    src = inputs.lualine;
  };
  markview = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      pkgs.vimPlugins.nvim-treesitter-textobjects
    ];
    pname = "markview";
    src = inputs.markview;
  };
  helpview = mkNvimPlugin {
    nvimSkipModule = [
      "definitions.__vimdoc"
    ];
    pname = "helpview";
    src = inputs.helpview;
  };
  mini-hipatterns = mkNvimPlugin {
    pname = "mini-hipatterns";
    src = inputs.mini-hipatterns;
  };
  symbol-usage = mkNvimPlugin {
    pname = "symbol-usage";
    src = inputs.symbol-usage;
  };
  nvim-vtsls = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.nvim-lspconfig
    ];
    pname = "nvim-vtsls";
    src = inputs.nvim-vtsls;
  };
  treesj = mkNvimPlugin {
    pname = "treesj";
    src = inputs.treesj;
  };
  mini-pairs = mkNvimPlugin {
    pname = "mini-pairs";
    src = inputs.mini-pairs;
  };
  resession = mkNvimPlugin {
    pname = "resession";
    src = inputs.resession;
  };
  mini-surround = mkNvimPlugin {
    pname = "mini-surround";
    src = inputs.mini-surround;
  };
  neotest-mocha = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.neotest
      pkgs.vimPlugins.nvim-nio
      pkgs.vimPlugins.plenary-nvim
    ];
    pname = "neotest-mocha";
    src = inputs.neotest-mocha;
  };
  neotest-vim-test = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.neotest
      pkgs.vimPlugins.nvim-nio
      pkgs.vimPlugins.plenary-nvim
    ];
    pname = "neotest-vim-test";
    src = inputs.neotest-vim-test;
  };
  mini-icons = mkNvimPlugin {
    pname = "mini-icons";
    src = inputs.mini-icons;
  };
  bqf = mkNvimPlugin {
    pname = "bqf";
    src = inputs.bqf;
  };
  quicker = mkNvimPlugin {
    pname = "quicker";
    src = inputs.quicker;
  };
  nvim-luaref = mkNvimPlugin {
    pname = "nvim-luaref";
    src = inputs.nvim-luaref;
  };
  luvit-meta = mkNvimPlugin {
    pname = "luvit-meta";
    src = inputs.luvit-meta;
  };
  lazydev = mkNvimPlugin {
    pname = "lazydev";
    src = inputs.lazydev;
  };
  hurl-nvim = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.plenary-nvim
      nui
    ];
    nvimSkipModule = [
      "hurl.popup"
      "hurl.split"
    ];
    pname = "hurl-nvim";
    src = inputs.hurl-nvim;
  };
  csvview = mkNvimPlugin {
    pname = "csvview";
    src = inputs.csvview;
  };
  demicolon = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      pkgs.vimPlugins.nvim-treesitter-textobjects
    ];
    pname = "demicolon";
    src = inputs.demicolon;
  };
  eyeliner = mkNvimPlugin {
    pname = "eyeliner";
    src = inputs.eyeliner;
  };
  codecompanion = mkNvimPlugin {
    dependencies = [
      blink-cmp
      mini-diff
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.telescope-nvim
    ];
    nvimSkipModule = [
      "codecompanion.actions.init"
      "codecompanion.actions.static"
      "codecompanion.providers.actions.fzf_lua"
      "codecompanion.providers.actions.mini_pick"
      "codecompanion.providers.actions.snacks"
      "codecompanion.providers.completion.cmp.setup"
      "minimal"
    ];
    pname = "codecompanion";
    src = inputs.codecompanion;
  };
  shipwright = mkNvimPlugin {
    pname = "shipwright";
    src = inputs.shipwright;
  };
  vimade = mkNvimPlugin {
    nvimSkipModule = [
      "vimade.focus.providers.hlchunk"
      "vimade.focus.providers.snacks"
      "vimade.focus.providers.mini"
    ];
    pname = "vimade";
    src = inputs.vimade;
  };
  dial = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.plenary-nvim
    ];
    pname = "dial";
    src = inputs.dial;
  };
  jirac = mkNvimPlugin {
    dependencies = [
      pkgs.vimPlugins.plenary-nvim
      nui
      nui-components
    ];
    pname = "jirac";
    src = inputs.jirac;
  };
  fidget = mkNvimPlugin {
    pname = "fidget";
    src = inputs.fidget;
  };
  hover = mkNvimPlugin {
    pname = "hover";
    src = inputs.hover;
    nvimSkipModule = [
      "hover.providers.fold_preview"
    ];
  };
  nvim-dap-view = mkNvimPlugin {
    pname = "nvim-dap-view";
    src = inputs.dap-view;
    dependencies = [
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.nvim-dap
    ];
  };
  faster = mkNvimPlugin {
    pname = "faster";
    src = inputs.faster;
  };
  recorder = mkNvimPlugin {
    pname = "recorder";
    src = inputs.nvim-recorder;
  };
  recall = mkNvimPlugin {
    pname = "recall";
    src = inputs.recall;
  };
  mcp-hub = mkNvimPlugin {
    pname = "mcp-hub";
    src = inputs.mcp-hub-nvim;
    dependencies = [
      pkgs.vimPlugins.plenary-nvim
      codecompanion
      lualine
    ];
    nvimSkipModule = [
      "bundled_build"
    ];
  };
  marks = mkNvimPlugin {
    pname = "marks";
    src = inputs.marks;
  };

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
    nvim-lspconfig # LSP client configs | https://github.com/neovim/nvim-lspconfig/
    # Autocompletion and extensions
    # nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    blink-cmp # Performant, batteries-included completion plugin for Neovim | https://github.com/Saghen/blink.cmp
    blink-copilot # Copilot source for blink-cmp | htttps://github.com/giuxtaposition/blink-cmp-copilot
    blink-compat # Compatibility layer for blink-cmp | htttps://github.com/Saghen/blink-compat
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-git # cmp git suggestions | https://github.com/petertriho/cmp-git/
    # ^ Autocompletion and extensions
    copilot # AI coding assistance | https://github.com/zbirenbaum/copilot.lua
    codecompanion # Assistant Chat | https://github.com/olimorris/codecompanion.nvim
    mcp-hub # MCP Hub | https://github.com/ravitemer/mcp-hub.nvim
    # git integration plugins
    diffview-nvim # Rich Diffing | https://github.com/sindrets/diffview.nvim/
    neogit # Git Client | https://github.com/TimUntersberger/neogit/
    gitsigns # Diff Editor Integration | https://github.com/lewis6991/gitsigns.nvim/
    mini-diff # Diff helper | https://github.com/echasnovski/mini.diff/
    mini-git # Git Editor Integration | https://github.com/echasnovski/mini-git/
    octo-nvim # GitHub Integration | https://github.com/pwntester/octo.nvim/
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    telescope-frecency # https://github.com/nvim-telescope/telescope-frecency.nvim/
    telescope-symbols-nvim # https://github.com/nvim-telescope/telescope-symbols.nvim/
    # ^ telescope and extensions
    # UI
    lush-nvim # colorscheme | https://github.com/rktjmp/lush.nvim/
    shipwright # build system | https://github.com/rktjmp/shipwright.nvim/
    rose-pine # colorscheme | https://github.com/rose-pine/neovim
    aerial-nvim # Document Outline | https://github.com/stevearc/aerial.nvim
    statuscol # Status column | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # nvim-treesitter-context
    nvim-notify # Editor notification | https://github.com/rcarriga/nvim-notify/
    dressing-nvim # UI Enhancements | https://github.com/stevearc/dressing.nvim/
    which-key # Keybindings helper | https://github.com/folke/which-key.nvim/
    todo-comments-nvim # Smarter comments | https://github.com/folke/todo-comments.nvim/
    indent-blankline-nvim # Indent guides | https://github.com/lukas-reineke/indent-blankline.nvim/
    satellite-nvim # Mini map | https://github.com/lewis6991/satellite.nvim/
    reactive # Contextual highlighting | https://github.com/rasulomaroff/reactive.nvim/
    screenkey # Screenkey | https://github.com/NStefan002/screenkey.nvim/
    true-zen # Zen mode | https://github.com/Pocco81/true-zen.nvim/
    mini-starter # Dashboard | https://github.com/echasnovski/mini.starter/
    lualine # Statusline & Tabline | https://github.com/nvim-lualine/lualine.nvim/
    markview # Mark view | https://github.com/OXY2DEV/markview.nvim/
    helpview # help view | https://github.com/OXY2DEV/helpview.nvim/
    mini-hipatterns # highlighting | https://github.com/echasnovski/mini.hipatterns/
    symbol-usage # Usage hints | https://github.com/Wansmer/symbol-usage.nvim/
    vimade # Pane focus contrast | https://github.com/TaDaa/vimade/
    fidget # progress | https://github.com/j-hui/fidget.nvim/
    hover # hover | https://github.com/lewis6991/hover.nvim/
    # ^ UI
    # language support
    nvim-lint # An asynchronous linter plugin | https://github.com/mfussenegger/nvim-lint/
    conform-nvim # An asynchronous formatter | https://github.com/stevearc/conform.nvim/
    refactoring-nvim # Language agnostic refactors | https://github.com/ThePrimeagen/refactoring.nvim/
    SchemaStore-nvim # JSON Schema support | https://github.com/b0o/SchemaStore.nvim/
    trouble-nvim # diagnostic aggregator panel | https://github.com/folke/trouble.nvim/
    comment-nvim # Comment helper | https://github.com/numtostr/comment.nvim
    neogen # Doc comment helper | https://github.com/danymat/neogen/
    nvim-vtsls # VTSLS | httpe://github.com/yioneko/nvim-vtsls/
    # ^ language support
    # navigation/editing enhancement plugins
    oil-nvim # A vim-vinegar like file explorer | https://github.com/stevearc/oil.nvim/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    treesj # https://github.com/Wansmer/treesj/
    mini-pairs # Auto pairs | https://github.com/echasnovski/mini.pairs/
    resession # Session management | https://github.com/stevearc/resession.nvim/
    mini-surround # Surround operator | https://github.com/echasnovski/mini.surround/
    demicolon # Semicolon helper | https://github.com/mawkler/demicolon.nvim/
    eyeliner # Visual cues | https://github.com/jinh0/eyeliner.nvim/
    dial # Increment/Decrement enhancement | https://github.com/monaqa/dial.nvim/
    # ^ navigation/editing enhancement plugins
    # Code running
    neotest # Testing framework | https://github.com/nvim-neotest/neotest/
    neotest-jest # Jest support | https://github.com/nvim-neotest/neotest-jest/
    neotest-mocha # Mocha support | https://github.com/nvim-neotest/neotest-mocha/
    {
      plugin = sniprun; # Repl | https://github.com/michaelb/sniprun
      optional = true;
    }
    vim-test # Testing framework | https://github.com/vim-test/vim-test/
    neotest-vim-test # Test adapter | https://github.com/nvim-neotest/neotest-vim-test/
    {
      plugin = overseer-nvim; # task management | https://github.com/stevearc/overseer.nvim/
      optional = true;
    }
    {
      plugin = compiler-nvim; # Compiler support | https://github.com/Zeioth/compiler.nvim ;
      optional = true;
    }
    # ^ Code running
    # Debugging
    # TODO: make these optional dependencies
    nvim-dap
    nvim-dap-view
    nvim-dap-virtual-text
    # ^ Debugging
    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    vim-startuptime # Profile startup time | https://github.com/dstein64/vim-startuptime
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    mini-icons # Additional icons | https://github.com/echasnovski/mini.icons/
    vim-repeat
    nui # Nvim UI component library| https://github.com/MunifTanjim/nui.nvim/
    bqf
    quicker
    # ^ libraries that other plugins depend on
    # Vim utilities
    nvim-luaref # Lua reference for Nvim | https://github.com/milisims/nvim-luaref
    luvit-meta # vim.uv types | htttps://github.com/Bilal2453/luvit-meta
    lazydev
    # ^ Vim utilities
    # Miscellaneous
    marks # Marks enhancement | https://github.com/chentoast/marks.nvim
    recorder # Macro recorder | https://github.com/chrisgrieser/nvim-recorder
    recall # Marks enhancement | https://github.com/fnune/recall.nvim
    faster # Performance | https://github.com/pteroctopus/faster.nvim
    hurl-nvim # Rest testing suite | https://github.com/jellydn/hurl.nvim/
    rest-nvim # Rest Client | https://github.com/rest-nvim/rest.nvim/
    neorg # Note taking | https://github.com/nvim-neorg/neorg/
    neorg-telescope # Neorg telescope integration
    nvim-dbee # Database client | https://github.com/kndndrj/nvim-dbee/
    {
      plugin = csvview; # CSV Display | https://github.com/hat0uma/csvview.nvim ;
      optional = true;
    }
    {
      plugin = jirac;
      optional = true;
    }
    # ^ Miscellaneous
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    actionlint
    biome
    deno
    fd
    fzf
    gh
    gojq
    gopls
    harper
    hurl
    inputs.mcp-hub.packages.${system}.default
    lua-language-server
    (luajit.withPackages (p: [
      p.luarocks
      p.luacheck
      p.mimetypes
      p.tiktoken_core
      p.xml2lua
    ]))
    nixd
    nodePackages_latest.jsonlint
    nodePackages_latest.nodejs
    nodePackages_latest.prettier
    nodePackages_latest.ts-node
    nodePackages_latest.yaml-language-server
    prettierd
    rust-analyzer # Rust LSP
    selene # Lua linter
    shellcheck
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

      offlineCache = fetchYarnDeps {
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
        maintainers = with maintainers; [lxsymington];
      };
    })
    (vale.withStyles (s: [s.write-good s.readability s.proselint]))
    vim-vint # Vim linter
    vscode-js-debug
    vscode-langservers-extracted # HTML/CSS/JSON/ESLint LSP
    vtsls
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  lxs-nvim = mkNeovim {
    inherit extraPackages isDarwin;
    neovim-unwrapped = inputs.neovim-nightly.packages.${system}.default;
    plugins = all-plugins;
    withNodeJs = true;
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
