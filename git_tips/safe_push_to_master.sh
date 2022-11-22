#!/bin/sh
#
# @author: https://github.com/mbonastre
#
#
# Push branch changes to ${MAIN} using Fast-Forward
#
# If some step fails because of some conflict, the process stops.
#
# Current branch should not be main (first pull will fail)
#
# Steps:
#  - Make sure local-main is up-to-date with origin-main (fetch and pull)
#  - Stash non-staged local changes, if applicable.
#  - Rebase
#  - Push local-branch changes to origin-branch and origin-main
#  - 
# Fem "push" de canvis en una branca cap a ${MAIN}, usant Fast-Forward
#
# Si algun pas falla per algun conflicte, el procés s'atura.
#
# Passos:
# - Actualitzem info local i remot (fetch/pull)
# - Ens assegurem que tenim els darrers canvis (rebase)
# - Apliquem canvis (push) des d'aquesta branca (HEAD) cap a ${MAIN} remot
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
  echo rebase: && git rebase ${MAIN} && 

echo "PUSHES OUR CHANGES:" &&
  echo "push local-branch to origin-branch:" &&  git push &&
  echo "push local-branch to origin-${MAIN}:"  &&  git push origin HEAD:${MAIN} &&

echo "PULL OUR CHANGES TO LOCAL ${MAIN}:" &&
  echo "pull-${MAIN}" && git pull origin ${MAIN}:${MAIN}

echo "DON'T FORGET !!!!! Do you need to do some of these? "

echo "Here:"
echo "  git stash pop"

echo "Other clones:"
echo "  git fetch && git pull"

echo "Branch cleaning:"
echo " - delete local : git branch -d BRANCH"
echo " - delete remote: git push origin --delete BRANCH"
echo " - ignore remote: git branch --unset-upstream [BRANCH]"
echo " - delete tracking: git remote prune origin"

