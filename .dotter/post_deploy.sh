{{#if dotter.packages.x11}}
xrdb ~/.Xresources
{{/if}}

{{#if dotter.packages.zsh}}
if ! test -L ~/.zprofile; then
    ln -s ~/.profile ~/.zprofile
fi
{{else}}
if test -L ~/.zprofile; then
    rm ~/.zprofile
fi
{{/if}}

{{#if dotter.packages.fonts}}
fc-cache -vf ~/.fonts
{{/if}}

{{#if dotter.packages.i3}}
i3-msg reload
{{/if}}

{{#if dotter.packages.vim}}
nvim --headless +PlugClean! +PlugUpdate! +PlugInstall! +qall
{{/if}}

rm /tmp/dotter_temp
