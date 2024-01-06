{
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # vmplayer &; pkttyagent --process $!
  virtualisation.vmware.host.enable = true;

  # virtualisation.waydroid.enable = true;
  # virtualisation.lxd.enable = true;
}
