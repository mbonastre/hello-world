#!/bin/sh
#
# @author: https://github.com/mbonastre
#
#
# Get changes from ${MAIN} to current branch using Fast-Forward
#
# If some step fails because of some conflict, the process stops.
#
# Current branch should not be main (first pull will fail)
#
# Steps:
#  - Make sure local-main is up-to-date with origin-main (fetch and pull)
#  - Stash non-staged local changes, if applicable.
#  - Rebase
# 
# Apliquem canvis de ${MAIN} a la branca actual , usant Fast-Forward
#
# Si algun pas falla per algun conflicte, el procés s'atura.
#
# Passos:
# - Actualitzem info local i remot (fetch/pull)
# - Ens assegurem que tenim els darrers canvis (rebase)
# - Apliquem canvis a ${MAIN} local (pull)
#

# Choose your player:
#MAIN="main"
MAIN="master"

date &&
echo "UPDATE LOCAL REPO WITH LATEST CHANGES:" &&
  echo "fetch:" && git fetch --prune &&
  echo "pull origin-${MAIN} to local-${MAIN}:" && git pull origin ${MAIN}:${MAIN} &&

echo "REBASE FROM ${MAIN}:" &&
  echo stash: && git stash &&
  echo rebase: && git rebase ${MAIN}

echo "DON'T FORGET !!!!! Do you need to do some of these? "

echo "Here:"
echo "  git stash pop"

echo "Other clones:"
echo "  git fetch --prune && git pull"

echo "Branch cleaning:"
echo " - delete local : git branch -d BRANCH"
echo " - delete remote: git push origin --delete BRANCH"
echo " - ignore remote: git branch --unset-upstream [BRANCH]"
echo " - delete tracking: git remote prune origin"
date
