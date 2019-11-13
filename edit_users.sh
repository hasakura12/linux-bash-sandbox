#!/bin/bash
# set -o errexit  # Exit if a command fails
# set -o pipefail # Exit if one command in a pipeline fails
# set -o nounset  # Treat unset variables and parameters as errors
# set -o xtrace   # Print a trace of simple commands

PS4='+ ${BASH_SOURCE} : ${LINENO} : ${FUNCNAME[0]}() : '
DEBUG=true

function rename() {
  local users=$(cat users.txt)

  for USER in "${users}"
  do
    echo "hello"
  done

  local file="users.txt"
  while read line; do
    echo "${line}"
    case "${line}" in
      [rR]oot)
        echo "user is root"
        ;;
      [tT]est|[aA]dm*)
        echo "user is test or adm"
        ;;
      *)
        echo "non-important user"
        ;;
    esac
  done < "${file}"

  echo "PID of $0 is $$"


  sleep 100 &
  echo "child PID is $!"
  trap "echo received signal to terminate. Terminating parent PID and child PID; kill $!; return;" SIGHUP SIGTERM SIGKILL
  local count=0
  local should_finish_loop
  while [ "$should_finish_loop" != "yes" ] ; do
    sleep 2
    ((count++))
    echo "${count}"
    read -p "Do you want to terminate the loop? (yes/no)" should_finish_loop
  done

  kill $!


  edit_passwd
  set +x
  return
}

function edit_passwd() {
  cat passwd
  local line_num=1
  touch tmp_passwd
  while read LINE; do
    echo "substituting ':' with '-' in $LINE..."
    LINE=${LINE//:/-}
    echo "after substituting, line is $LINE..."
    echo "$line_num: $LINE" >> tmp_passwd
    ((line_num++)) && ${DEBUG} && echo "DEBUG is ON and line_num is ${line_num}"
  done < passwd

  echo "after appending line numbers, passwd content is below"
  mv tmp_passwd passwd && cat passwd

}


rename "$@"
