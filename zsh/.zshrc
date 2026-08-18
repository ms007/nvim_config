# ------------------------------------------------------------------------------
# PROFILING
# ------------------------------------------------------------------------------
# zmodload zsh/zprof

# ------------------------------------------------------------------------------
# COMPLETION SYSTEM (Speed-optimized with Smart Background Cache)
# ------------------------------------------------------------------------------
# Add custom completion paths before compinit
if [[ -d /opt/homebrew/share/zsh-completions ]]; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
fpath=(/Users/seifm/.docker/completions $fpath)

autoload -Uz compinit

# Smart Cache Logic: Use cache if it's less than 24h old, update in background
# The (#qN.m1) glob check looks for a file modified within the last day
if [[ -n ~/.zcompdump(#qN.m1) ]]; then
  # Instant load from existing cache
  compinit -C -i -D
  # Refresh the cache in the background for the NEXT session (silent)
  (compinit -i -D &!) 
else
  # Cache is old or missing: perform a full initialization
  compinit -i -D
fi

# ------------------------------------------------------------------------------
# OH-MY-ZSH CONFIGURATION
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Disable security checks for completion files (speeds up startup)
ZSH_DISABLE_COMPFIX=true

# Disable automatic update checks (manual update via 'omz update')
DISABLE_AUTO_UPDATE="true"

# Define plugins
plugins=(git)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# SSH KEY MANAGEMENT (Backgrounded for speed)
# ------------------------------------------------------------------------------
# Load keys into agent in the background. 
# Using &! (disown) to prevent "job done" messages.
{
  ssh-add --apple-use-keychain ~/.ssh/Gitlab 
  ssh-add --apple-use-keychain ~/.ssh/EduNet 
  ssh-add --apple-use-keychain ~/.ssh/contabo 
} > /dev/null 2>&1 &!

# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES & PATHS
# ------------------------------------------------------------------------------
export SOPS_AGE_KEY_FILE=$HOME/.config/sops/age/keys.txt
export JAVA_HOME="/usr/libexec/java_home -v 17.0.9+11-LTS"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export SESSIONIZER_PATH="$HOME/Projects"
export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Consolidate PATH modifications
path=(
  $HOME/bin
  $HOME/.local/bin
  $ANDROID_HOME/emulator
  $ANDROID_HOME/platform-tools
  $HOME/.bun/bin
  $HOME/.tmuxifier/bin
  $path
)
export PATH

# ------------------------------------------------------------------------------
# THIRD-PARTY TOOLS & PLUGINS
# ------------------------------------------------------------------------------
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Fuzzy Finder (fzf)
source <(fzf --zsh)

# Node Version Manager (NVM) - Loaded without picking a version for speed
export NVM_DIR="$HOME/.nvm"
export PATH="$NVM_DIR/versions/node/v22.14.0/bin:$PATH"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Tool Initializations
eval "$(tmuxifier init -)"
eval "$(starship init zsh)"

# ------------------------------------------------------------------------------
# ALIASES & UTILS
# ------------------------------------------------------------------------------
alias ls='gls --hyperlink=auto'
alias la='gls -la --hyperlink=auto'
alias ll='gls -lh --hyperlink=auto'
alias l='gls -lah --hyperlink=auto'
alias lsa='gls -lah --hyperlink=auto'

# Manual cache reset: run 'recache' if completions are missing
alias recache="rm -f ~/.zcompdump*; exec zsh"

# Python
alias python='python3'
alias pip='pip3'

# CLAUDE
alias claude-ts='claude --append-system-prompt-file ~/Projects/Side/Claude/claude-code-system-prompts/templates/nextjs/CLAUDE.md'

# zprof

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/seifm/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/seifm/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/seifm/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/seifm/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
