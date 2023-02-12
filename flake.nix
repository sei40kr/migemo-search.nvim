{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/master";
  };

  outputs = { self, flake-utils, nixpkgs }:
    let inherit (flake-utils.lib) eachSystem;
      systems = [ "x86_64-darwin" "x86_64-linux" ];
    in
    eachSystem systems (system:
      let pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          migemo-search-nvim = pkgs.callPackage ./packages/migemo-search-nvim { };
        };

        devShell = pkgs.mkShell {
          buildInputs = [
            (pkgs.neovim.override {
              configure = {
                customRC = ''
                  lua <<EOF
                  local ms = require("migemo-search")

                  ms.setup({
                    cmigemo_exec_path = "${pkgs.cmigemo}/bin/cmigemo",
                    migemo_dict_path = "${pkgs.cmigemo}/share/migemo/utf-8/migemo-dict",
                  })
                  vim.keymap.set("c", "<CR>", ms.cr)
                  EOF
                '';
                packages.myVimPackage.start = [ self.packages.${system}.migemo-search-nvim ];
              };
            })
            pkgs.cmigemo
          ];
          shellHook = ''
            export NVIM_LOG_FILE=log
            export VIM=
            export VIMRUNTIME=
            export XDG_CONFIG_HOME=$(mktemp -d)
            export XDG_DATA_HOME=$(mktemp -d)
            export VIMINIT=
            exec nvim
          '';
        };
      });
}
