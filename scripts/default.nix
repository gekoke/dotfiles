{lib, ...}: {
  home.file."Scripts" = {
    source = ./Scripts;
    recursive = true;
  };
}
