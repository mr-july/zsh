#!/usr/bin/env zsh

export ZDOTDIR=${ZDOTDIR:-$HOME}

# - - - - - - - - - - - - - - - - - - - -
# Profiling Tools
# - - - - - - - - - - - - - - - - - - - -

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    zmodload zsh/zprof
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/startlog.$$
    setopt xtrace prompt_subst
fi


# - - - - - - - - - - - - - - - - - - - -
# Instant Prompt
# - - - - - - - - - - - - - - - - - - - -

# Enable Powerlevel10k instant prompt. Should stay close to the top of `~/.zshrc`.
# Initialization code that may require console input ( password prompts, [y/n]
# confirmations, etc. ) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# - - - - - - - - - - - - - - - - - - - -
# Homebrew Configuration
# - - - - - - - - - - - - - - - - - - - -

# If You Come From Bash You Might Have To Change Your $PATH.
#   export PATH=:/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# For local python scripts
export PATH="$HOME/.local/bin:$PATH"


# Homebrew Requires This.
export PATH="/usr/local/sbin:$PATH"


# - - - - - - - - - - - - - - - - - - - -
# Zsh Core Configuration
# - - - - - - - - - - - - - - - - - - - -

# Load The Prompt System And Completion System And Initilize Them.
autoload -Uz compinit promptinit

# Load And Initialize The Completion System Ignoring Insecure Directories With A
# Cache Time Of 20 Hours, So It Should Almost Always Regenerate The First Time A
# Shell Is Opened Each Day.
# See: https://gist.github.com/ctechols/ca1035271ad134841284
_comp_files=($ZDOTDIR/.zcompdump(Nm-20))
if (( $#_comp_files )); then
    compinit -i -C
else
    compinit -i
fi
unset _comp_files
promptinit
setopt prompt_subst


# - - - - - - - - - - - - - - - - - - - -
# ZSH Settings
# - - - - - - - - - - - - - - - - - - - -

autoload -U colors && colors    # Load Colors.
unsetopt case_glob              # Use Case-Insensitve Globbing.
setopt globdots                 # Glob Dotfiles As Well.
setopt extendedglob             # Use Extended Globbing.
setopt autocd                   # Automatically Change Directory If A Directory Is Entered.

# Smart URLs.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# General.
setopt brace_ccl                # Allow Brace Character Class List Expansion.
setopt combining_chars          # Combine Zero-Length Punctuation Characters ( Accents ) With The Base Character.
setopt rc_quotes                # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt mail_warning           # Don't Print A Warning Message If A Mail File Has Been Accessed.

# Jobs.
setopt long_list_jobs           # List Jobs In The Long Format By Default.
setopt auto_resume              # Attempt To Resume Existing Job Before Creating A New Process.
setopt notify                   # Report Status Of Background Jobs Immediately.
unsetopt bg_nice                # Don't Run All Background Jobs At A Lower Priority.
unsetopt hup                    # Don't Kill Jobs On Shell Exit.
unsetopt check_jobs             # Don't Report On Jobs When Shell Exit.

setopt correct                  # Turn On Corrections

# Completion Options.
setopt complete_in_word         # Complete From Both Ends Of A Word.
setopt always_to_end            # Move Cursor To The End Of A Completed Word.
setopt path_dirs                # Perform Path Search Even On Command Names With Slashes.
setopt auto_menu                # Show Completion Menu On A Successive Tab Press.
setopt auto_list                # Automatically List Choices On Ambiguous Completion.
setopt auto_param_slash         # If Completed Parameter Is A Directory, Add A Trailing Slash.
setopt no_complete_aliases

setopt menu_complete            # Do Not Autoselect The First Completion Entry.
unsetopt flow_control           # Disable Start/Stop Characters In Shell Editor.

# Zstyle.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true

# History.
HISTFILE="$ZDOTDIR/.zhistory"
HISTSIZE=100000
SAVEHIST=5000
setopt appendhistory notify
unsetopt beep nomatch

setopt bang_hist                # Treat The '!' Character Specially During Expansion.
setopt inc_append_history       # Write To The History File Immediately, Not When The Shell Exits.
setopt share_history            # Share History Between All Sessions.
setopt hist_expire_dups_first   # Expire A Duplicate Event First When Trimming History.
setopt hist_ignore_dups         # Do Not Record An Event That Was Just Recorded Again.
setopt hist_ignore_all_dups     # Delete An Old Recorded Event If A New Event Is A Duplicate.
setopt hist_find_no_dups        # Do Not Display A Previously Found Event.
setopt hist_ignore_space        # Do Not Record An Event Starting With A Space.
setopt hist_save_no_dups        # Do Not Write A Duplicate Event To The History File.
setopt hist_verify              # Do Not Execute Immediately Upon History Expansion.
setopt extended_history         # Show Timestamp In History.


# Key Bindings
bindkey  "^[[H"   beginning-of-line             # [Home]
bindkey  "^A"     beginning-of-line             # [Ctrl+A]
bindkey  "^[[F"   end-of-line                   # [End]
bindkey  "^E"     end-of-line                   # [Ctrl+E]
bindkey "^[[3~"   delete-char                   # Neo L4 Delete

# Aliases
alias   ll="ls -al"
alias   psg="ps -ef | grep"

# - - - - - - - - - - - - - - - - - - - -
# Zinit Configuration
# - - - - - - - - - - - - - - - - - - - -

__ZINIT="$ZDOTDIR/.zinit/bin/zinit.zsh"

if [[ ! -f "$__ZINIT" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma-continuum/zinit)…%f"
    command mkdir -p "$ZDOTDIR/.zinit" && command chmod g-rwX "$ZDOTDIR/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$ZDOTDIR/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

. "$__ZINIT"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# - - - - - - - - - - - - - - - - - - - -
# Theme
# - - - - - - - - - - - - - - - - - - - -

# Most Themes Use This Option.
setopt promptsubst

# These plugins provide many aliases - atload''
zinit wait lucid for \
        OMZ::lib/git.zsh \
    atload"unalias grv" \
        OMZ::plugins/git/git.plugin.zsh

# Provide A Simple Prompt Till The Theme Loads
PS1="READY >"
zinit ice wait'!' lucid
zinit ice depth=1; zinit light romkatv/powerlevel10k


# - - - - - - - - - - - - - - - - - - - -
# Annexes
# - - - - - - - - - - - - - - - - - - - -

# Load a few important annexes, without Turbo (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-submods \
    zdharma-continuum/declare-zsh


# - - - - - - - - - - - - - - - - - - - -
# Plugins
# - - - - - - - - - - - - - - - - - - - -

zinit wait lucid light-mode for \
      OMZ::lib/compfix.zsh \
      OMZ::lib/completion.zsh \
      OMZ::lib/functions.zsh \
      OMZ::lib/diagnostics.zsh \
      OMZ::lib/git.zsh \
      OMZ::lib/grep.zsh \
      OMZ::lib/misc.zsh \
      OMZ::lib/spectrum.zsh \
      OMZ::lib/termsupport.zsh \
      OMZ::plugins/git-auto-fetch/git-auto-fetch.plugin.zsh \
  atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
      OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh \
      OMZ::plugins/command-not-found/command-not-found.plugin.zsh \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  as"completion" \
      OMZ::plugins/docker/docker.plugin.zsh \
      OMZ::plugins/pyenv/pyenv.plugin.zsh

# fzf support (Ctrl-T, Alt-C, Crtl-R)
zplugin ice wait"0c" as"completion" blockf lucid
zplugin snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh
zplugin ice wait"0c" lucid
zplugin snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh

# Seach the History by Entered Substring on Up and Down Keys
_zsh-history-substring-search-setting() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
  HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
}
zplugin ice wait"0c" atload"_zsh-history-substring-search-setting" lucid
zplugin light zsh-users/zsh-history-substring-search


# Recommended Be Loaded Last.
zinit ice wait blockf lucid atpull'zinit creinstall -q .'
zinit load zsh-users/zsh-completions

# rbenv
# zinit ice has'rbenv' id-as'rbenv' atpull'%atclone' \
#     atclone"rbenv init - --no-rehash > htlsne/zplugin-rbenv"
# zinit load zdharma-continuum/null

# pyenv
# zinit ice has'pyenv' id-as'pyenv' atpull'%atclone' \
#     atclone"pyenv init - --no-rehash > pyenv.plugin.zsh"
# zinit load zdharma-continuum/null

# Semi-graphical .zshrc editor for zinit commands
# zinit load zdharma-continuum/zui
# zinit ice lucid wait'[[ -n ${ZLAST_COMMANDS[(r)cras*]} ]]'
# zinit load zdharma-continuum/zplugin-crasis


# - - - - - - - - - - - - - - - - - - - -
# User Configuration
# - - - - - - - - - - - - - - - - - - - -

setopt no_beep
# export MANPATH="/usr/local/man:$MANPATH"

# - - - - - - - - - - - - - - - - - - - -
# cdr, persistent cd
# - - - - - - - - - - - - - - - - - - - -

#autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
#add-zsh-hook chpwd chpwd_recent_dirs
#DIRSTACKFILE="$HOME/.cache/zsh/dirs"
#
## Make `DIRSTACKFILE` If It 'S Not There.
#if [[ ! -a $DIRSTACKFILE ]]; then
#    mkdir -p $DIRSTACKFILE[0,-5]
#    touch $DIRSTACKFILE
#fi
#
#if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
#    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
#fi
#
#chpwd() {
#    print -l $PWD ${(u)dirstack} >>$DIRSTACKFILE
#    local d="$(sort -u $DIRSTACKFILE )"
#    echo "$d" > $DIRSTACKFILE
#}
#
#DIRSTACKSIZE=20
#
#setopt auto_pushd pushd_silent pushd_to_home
#
#setopt pushd_ignore_dups        # Remove Duplicate Entries
#setopt pushd_minus              # This Reverts The +/- Operators.


# - - - - - - - - - - - - - - - - - - - -
# Theme / Prompt Customization
# - - - - - - - - - - - - - - - - - - - -

# To Customize Prompt, Run `p10k configure` Or Edit `$ZDOTDIR/.p10k.zsh`.
[[ -f "$ZDOTDIR/.p10k.zsh" ]] && . "$ZDOTDIR/.p10k.zsh"


# Local Config
[[ -f "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"

foreach piece (
    exports.zsh
    node.zsh
    aliases.zsh
    functions.zsh
) {
    local f="$ZDOTDIR/.local/$piece"
    [[ -f $f ]] && . $f
}


# - - - - - - - - - - - - - - - - - - - -
# End Profiling Script
# - - - - - - - - - - - - - - - - - - - -

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof > ~/zshprofile$(date +'%s')
fi

