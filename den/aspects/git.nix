{
  den.aspects = {
    git = {
      provides.to-users.homeManager.programs.git = {
        enable = true;
        signing = {
          signByDefault = true;
          format = "openpgp";
        };
        settings = {
          init.defaultBranch = "main";
          pull.rebase = true;
          push.autoSetupRemote = true;
          rerere.enabled = true;
          diff = {
            colorMoved = true;
            algorithm = "histogram";
          };
          credential.helper = "store";
          gc.auto = 0;
        };
      };
    };

    geko = {
      provides.carbon.homeManager.programs.git.signing.key = "1E9AFDF3275F99EE";

      homeManager.programs.git.settings = {
        user = {
          name = "Gregor Grigorjan";
          email = "gregor@grigorjan.net";
        };
        github.user = "gekoke";
      };
    };
  };
}
