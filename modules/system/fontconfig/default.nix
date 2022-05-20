{
  fonts = {
    fontconfig = {
      localConf = ''
        <match target="font">
         <edit mode="assign" name="antialias">
          <bool>true</bool>
         </edit>
        </match>
        <match target="font">
         <edit mode="assign" name="rgba">
          <const>rgb</const>
         </edit>
        </match>
        <match target="font">
         <edit mode="assign" name="lcdfilter">
          <const>lcddefault</const>
         </edit>
        </match>
      '';
    };
  };
}

