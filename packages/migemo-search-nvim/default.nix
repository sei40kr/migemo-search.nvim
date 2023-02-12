{ vimUtils }:

vimUtils.buildVimPluginFrom2Nix {
  pname = "migemo-search.nvim";
  version = "1.0.0";
  src = ../..;
  meta.homepage = "https://github.com/sei40kr/migemo-search.nvim";
}
