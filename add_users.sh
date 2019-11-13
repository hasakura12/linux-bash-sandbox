#!/bin/bash

function add_user() {
  echo "executing the script $0"

  if [ $# -lt 1 ]; then
    echo "error - supply at least one user name to add"
    exit 1
  fi

  for USER in $@ ;  do
    useradd $USER
    tail -1 /etc/passwd
  done


  read -p "what's the name of user you want to add? " NEW_USER
  echo "adding a new user $NEW_USER"
  useradd "${NEW_USER}"
  tail -1 /etc/passwd
}

add_user "$@"
