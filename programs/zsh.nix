{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    autosuggestion.enable = true;
    history.append = true;
    history.save = 100000;
    initExtra = ''
      bindkey -e
      bindkey "^K"      kill-line
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[^?'    backward-kill-word

      WORDCHARS='*?_-.[]~=&;!#$%^(){}<>/ '$'\n'
      autoload -Uz select-word-style
      select-word-style normal
      zstyle ':zle:*' word-style unspecified
    '';
  };
}
