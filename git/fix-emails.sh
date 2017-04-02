git filter-branch -f --env-filter '
OLD_EMAIL="arnau@ustwo.com"
CORRECT_NAME="Arnau Siches"
CORRECT_EMAIL="asiches@gmail.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
export GIT_COMMITTER_NAME="$CORRECT_NAME"
export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
export GIT_AUTHOR_NAME="$CORRECT_NAME"
export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
-bash: unexpected EOF while looking for matching `''
-bash: syntax error: unexpected end of file
