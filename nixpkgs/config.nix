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
        htop
				wget
				jq
				yq
        ripgrep
        fd
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
