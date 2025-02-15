# keep

# Example of a user-defined prompt segment. Function prompt_example will be called on every
# prompt if `example` prompt segment is added to POWERLEVEL9K_LEFT_PROMPT_ELEMENTS or
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS. It displays an icon and orange text greeting the user.
#
# Type `p10k help segment` for documentation and a more sophisticated example.
function prompt_host_short() {
  local hostname_short
  local hostname_color
  if [[ "$HOST" == *"fushimi-macbook"* ]]; then
    hostname_short="macbook"
    hostname_color=8
  elif [[ "$HOST" == *"fushimi-mac"* ]]; then
    hostname_short="macpro"
    hostname_color=7
  elif [[ "$HOST" == *"m-100"* ]]; then
    hostname_short="MiniPC"
    hostname_color=6
  elif [[ "$HOST" == *"macbookair"* ]]; then
    hostname_short="MacBook"
    hostname_color=5
  elif [[ "$HOST" == *"Studio"* ]]; then
    hostname_short="MacStudio"
    hostname_color=4
  elif [[ "$HOST" == *".c."* ]]; then
    hostname_short="glinux"
    hostname_color=1
  else
    hostname_short="$HOST"
    hostname_color=3
  fi
  p10k segment -f $hostname_color -t "$hostname_short"
}
# User-defined prompt segments may optionally provide an instant_prompt_* function. Its job
# is to generate the prompt segment for display in instant prompt. See
# https://github.com/romkatv/powerlevel10k#instant-prompt.
#
# Powerlevel10k will call instant_prompt_* at the same time as the regular prompt_* function
# and will record all `p10k segment` calls it makes. When displaying instant prompt, Powerlevel10k
# will replay these calls without actually calling instant_prompt_*. It is imperative that
# instant_prompt_* always makes the same `p10k segment` calls regardless of environment. If this
# rule is not observed, the content of instant prompt will be incorrect.
#
# Usually, you should either not define instant_prompt_* or simply call prompt_* from it. If
# instant_prompt_* is not defined for a segment, the segment won't be shown in instant prompt.
function instant_prompt_host_short() {
  # Since prompt_example always makes the same `p10k segment` calls, we can call it from
  # instant_prompt_example. This will give us the same `example` prompt segment in the instant
  # and regular prompts.
  prompt_host_short
}
