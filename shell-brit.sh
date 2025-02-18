# sudofox/shell-mommy.sh

mommy() (

  # SHELL_MOMMYS_LITTLE - what to call you~ (default: "girl")
  # SHELL_MOMMYS_PRONOUNS - what pronouns mommy will use for themself~ (default: "her")
  # SHELL_MOMMYS_ROLES - what role mommy will have~ (default "mommy")

  COLORS_LIGHT_PINK='\e[38;5;217m'
  COLORS_LIGHT_BLUE='\e[38;5;117m'
  COLORS_RED='\e[38;5;196m'
  COLORS_FAINT='\e[2m'
  COLORS_RESET='\e[0m'

  DEF_WORDS_LITTLE="bastard"
  DEF_WORDS_PRONOUNS="them"
  DEF_WORDS_ROLES="brit"
  DEF_MOMMY_COLOR="${COLORS_RED}"
  DEF_ONLY_NEGATIVE="false"

  NEGATIVE_RESPONSES="come on man, a severed goat could do better than this.
yeah yeah go to stack overflow you lazy bastard.
i have a carton of eggs, and if you keep this up, you'll have them ontop of ya head.
fucks sake, seriously?
blithering idiot..
get on with it, bell end. really isn't that hard.
are you gonna keep up with this shit all day?
nothing, absolutely nothing. that's what i think of your iq.
quit being a nonce and get a grip of yourself.
we're up shit creek aren't we.
bet you can't even organise a piss-up in a brewery.
you're a walking argument for birth control
if brains were dynamite, you wouldn’t have enough to blow your hat off.
watching you fail is the highlight of my day.
are you just naturally incompetent or is it a special talent?
seriously, who ties your shoelaces for you?
i’d call you a tool, but that’d imply you’re useful.
you've fucked it man, no chance.
"

  POSITIVE_RESPONSES="wow, you actually did it.
nice work mate!
didn't cock up this time, good on ya.
oh. nice.
wow, shit actually worked, good day eh?
wanna grab a pint later?
fuck yes, good work mate!
knew you could pull it off.
top notch, well done mate!
absolute legend.
blummin genius you are.
you're on fire today my man!
nailed it.
absolute marvel ain't ya.
well well well, look who's the smart chap now!
i'd clap, but i'm lazy, well done though mate!
absolutely smashing, well done mate!
"

  # allow for overriding of default words (IF ANY SET)

  if [ -n "$SHELL_MOMMYS_LITTLE" ]; then
    DEF_WORDS_LITTLE="${SHELL_MOMMYS_LITTLE}"
  fi
  if [ -n "$SHELL_MOMMYS_PRONOUNS" ]; then
    DEF_WORDS_PRONOUNS="${SHELL_MOMMYS_PRONOUNS}"
  fi
  if [ -n "$SHELL_MOMMYS_ROLES" ]; then
    DEF_WORDS_ROLES="${SHELL_MOMMYS_ROLES}"
  fi
  if [ -n "$SHELL_MOMMYS_COLOR" ]; then
    DEF_MOMMY_COLOR="${SHELL_MOMMYS_COLOR}"
  fi
  # allow overriding to true
  if [ "$SHELL_MOMMYS_ONLY_NEGATIVE" = "true" ]; then
    DEF_ONLY_NEGATIVE="true"
  fi
  # if the variable is set for positive/negative responses, overwrite it
  if [ -n "$SHELL_MOMMYS_POSITIVE_RESPONSES" ]; then
    POSITIVE_RESPONSES="$SHELL_MOMMYS_POSITIVE_RESPONSES"
  fi
  if [ -n "$SHELL_MOMMYS_NEGATIVE_RESPONSES" ]; then
    NEGATIVE_RESPONSES="$SHELL_MOMMYS_NEGATIVE_RESPONSES"
  fi

  # split a string on forward slashes and return a random element
  pick_word() {
    echo "$1" | tr '/' '\n' | shuf | sed 1q
  }

  pick_response() { # given a response type, pick an entry from the list

    if [ "$1" = "positive" ]; then
      element=$(echo "$POSITIVE_RESPONSES" | shuf | sed 1q)
    elif [ "$1" = "negative" ]; then
      element=$(echo "$NEGATIVE_RESPONSES" | shuf | sed 1q)
    else
      echo "Invalid response type: $1"
      exit 1
    fi

    # Return the selected response
    echo "$element"

  }

  sub_terms() { # given a response, sub in the appropriate terms
    response="$1"
    # pick_word for each term
    affectionate_term="$(pick_word "${DEF_WORDS_LITTLE}")"
    pronoun="$(pick_word "${DEF_WORDS_PRONOUNS}")"
    role="$(pick_word "${DEF_WORDS_ROLES}")"
    # sub in the terms, store in variable
    response="$(echo "$response" | sed "s/AFFECTIONATE_TERM/$affectionate_term/g")"
    response="$(echo "$response" | sed "s/MOMMYS_PRONOUN/$pronoun/g")"
    response="$(echo "$response" | sed "s/MOMMYS_ROLE/$role/g")"
    # we have string literal newlines in the response, so we need to printf it out
    # print faint and colorcode
    printf "${DEF_MOMMY_COLOR}$response${COLORS_RESET}\n"
  }

  success() {
    (
      # if we're only supposed to show negative responses, return
      if [ "$DEF_ONLY_NEGATIVE" = "true" ]; then
        return 0
      fi
      # pick_response for the response type
      response="$(pick_response "positive")"
      sub_terms "$response" >&2
    )
    return 0
  }
  failure() {
    rc=$?
    (
      response="$(pick_response "negative")"
      sub_terms "$response" >&2
    )
    return $rc
  }
  # eval is used here to allow for alias resolution

  # TODO: add a way to check if we're running from PROMPT_COMMAND to use the previous exit code instead of doing things this way
  eval "$@" && success || failure
  return $?
)
