{ pkgs, ... }:
{
  home.sessionVariables = {
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
    PATH = "$PATH:$HOME/.cargo/bin";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
