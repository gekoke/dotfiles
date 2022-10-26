{
  console.useXkbConfig = true;

  services.xserver = {
    enable = true;
    layout = "ee";
    xkbVariant = "us";
    libinput.enable = true;

    windowManager = {
      leftwm.enable = true;
      awesome.enable = true;
    };
  };
}
