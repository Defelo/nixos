$env.config = {
    show_banner: false
    filesize: { metric: true }
    edit_mode: vi

    keybindings: [
        {
            name: take_history_hint
            modifier: control
            keycode: space
            mode: [emacs, vi_normal, vi_insert]
            event: { until: [ {send: historyhintcomplete} ] }
        }
    ]
}

$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
