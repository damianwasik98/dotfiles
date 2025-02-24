{
  packageOverrides = pkgs: {
    minimalTools = with pkgs; [ 
        git
        tmux
        neovim
        git
        lazygit
        lazydocker
        yazi
        fzf
        tree
        btop
        wget
        jq
        yq
        ripgrep
        fd
        zoxide
      ];
    k8sTools = with pkgs; [
      kubectl
      k9s
    ];
    macOSOnly = with pkgs; [
      wezterm
	    aerospace
	    colima
	    #gnu-getopt
	    #gnu-sed
	    #gnu-tar  
    ];
  };
}
