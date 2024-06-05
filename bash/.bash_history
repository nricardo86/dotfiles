staged_files='git ls-files \
  --modified \
  --deleted \
  --other \
  --exclude-standard \
  --deduplicate \
  $(git rev-parse --show-toplevel)' && eval "$staged_files" | fzf   --multi   --reverse   --no-sort   --prompt='Add > '   --header-first   --header='ENTER to stage the files'   --preview='git status --short'   --bind='enter:execute(git add {+})'   --bind="enter:+reload($staged_files)"
git status
staged_files='git ls-files \
  --modified \
  --deleted \
  --other \
  --exclude-standard \
  --deduplicate \
  $(git rev-parse --show-toplevel)' && unstaged_files='git status  --short \
  | grep "^[A-Z]" \
  | awk "{print \$NF}"' && eval "$staged_files" | fzf   --multi   --reverse   --no-sort   --prompt='Add > '   --header-first   --header '
  > CTRL-R to Reset | CTRL-A to Add
  > ENTER to Reset or Add files
  > ENTER in Reset mode switch back to Add mode
  '   --preview='git status --short'   --bind='ctrl-a:change-prompt(Add > )'   --bind="ctrl-a:+reload($staged_files)"   --bind='ctrl-r:change-prompt(Reset > )'   --bind="ctrl-r:+reload($unstaged_files)"   --bind="enter:execute($staged_files | grep {} \
    && git add {+} \
    || git reset -- {+})"   --bind='enter:+change-prompt(Add > )'   --bind="enter:+reload($staged_files)"   --bind='enter:+refresh-preview'
git lot --format="%h)
git lot --format="%h"
git log --format="%h"
git log --graph --color --format='%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d'
git log --graph --color   --format='%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d' | fzf   --ansi   --reverse   --no-sort   --preview='
    echo {} | grep -o "[a-f0-9]\{7\}" \
    && git show --color $(echo {} | grep -o "[a-f0-9]\{7\}")
  '
git log --graph --color --format='%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d' | fzf   --ansi   --reverse   --no-sort   --preview='
    hash=$(echo {} | grep -o "[a-f0-9]\{7\}" | sed -n "1p") \
    && [[ $hash != "" ]] \
    && git show --color $hash
    '   --bind='enter:execute(
    hash=$(echo {} | grep -o "[a-f0-9]\{7\}" | sed -n "1p") \
    && [[ $hash != "" ]] \
    && sh -c "git show --color $hash | less -R"
    )'   --bind='alt-c:execute(
    hash=$(echo {} | grep -o "[a-f0-9]\{7\}" | sed -n "1p") \
    && [[ $hash != "" ]] \
    && git checkout $hash
    )+abort'   --bind='alt-r:execute(
    hash=$(echo {} | grep -o "[a-f0-9]\{7\}" | sed -n "1p") \
    && [[ $hash != "" ]] \
    && git reset $hash
    )+abort'   --bind='alt-i:execute(
    hash=$(echo {} | grep -o "[a-f0-9]\{7\}" | sed -n "1p") \
    && [[ $hash != "" ]] \
    && git rebase --interactive $hash
    )+abort'   --header-first   --header '
  > ENTER to display the diff
  > ALT-C to checkout the commit | ALT-R to reset to the commit
  > ALT-I to rebase interactively
  '
cd
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 ./Downloads/FreeCAD_0.21.1-Linux-x86_64.AppImage
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 ./local/bin/FreeCAD_0.21.1-Linux-x86_64.AppImage
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 .local/bin/FreeCAD_0.21.2-2023-12-17-conda-Linux-x86_64-py310.AppImage 
cd .local/bin
l
ls
cd
la
