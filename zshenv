#!/usr/bin/env zsh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# .zshenv
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local dotdir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

link(){
    file="$1"
    [[ ! -e "$HOME/.$file" ]] && [[ -e  "$dotdir/$file" ]] && ln -s "$dotdir/$file" "$HOME/.$file"
}

if [[ ! -f "$dotdir/.zshrc" ]] && [[ -f "$dotdir/zshrc" ]]
then
    (
    cd "$dotdir" || exit;

    for f in *
    do
        ln -s "$PWD/$f" "$PWD/.$f"
    done

    #rm -rf .pkg .zsh

    link zshenv
    #link p10k.zsh
)
elif [[ -f "$dotdir/.zshrc" ]]; then
    export ZDOTDIR="$dotdir"
    export ZROOTDIR="$dotdir"
else
    echo 'no zshrc' > $HOME/nozshrc
fi
