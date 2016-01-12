#!/usr/bin/env bash

## check the system
EXPECT_BIN=`which expect`

if [ -z $EXPECT_BIN ]; then
  echo "This tool is required expect script. Please first install expect script using following script"
  if [ -e /etc/redhat-release ]; then
    echo "sudo yum -y install expect"
  else
    echo "sudo apt-get install expect"
  fi
  exit 2
fi


require_option () {
  if [[ ! $1 ]]; then
    echo "$2 is required."
  fi
}

print_help() {
  cat<<EOF
Usage: $0 command [options]

Commands:
  adduser                 Add a user to hosts specified, required root privilege
  copy-key                copy current user's ssh-key to hosts specified
  copy                    copy file to remote host
  run                     run command at remote host
EOF
}


print_adduser_help() {
  cat <<EOF
Usage: $0 adduser [options]

This script add a user to the hosts specified

Options:
  -u TEXT                       Username
  -p TEXT                       Password. Caution! This is not encrypted. Please remove your history.
  -s TEXT                       Filename that has hosts to add the user.
  -h                            Show this help messages.

EOF
}

print_copy-key_help() {
  cat <<EOF
Usage: $0 copy-key [options]

This script add a user to the hosts specified

Options:
  -s TEXT                       Filename that has hosts to add the user.
  -u TEXT                       Username that login to remote host
  -p TEXT                       Password used copying ssh key. Caution! This is not encrypted. Please remove your history.
  -h                            Show this help messages.

EOF
}

print_copy_help() {
  cat <<EOF
Usage: $0 copy [options] source target

This script copy source file to target in remote server using scp

Options:
  -s TEXT                       Filename that has hosts to add the user.
  -u TEXT                       Username to login remote host

Eamples:
  $0 copy -s ./hosts ./test.txt ./relative/path/to/in/remote/host
  $0 copy -s ./hosts ./test.txt /absolute/path/to/in/remote/host
EOF
}

print_run_help() {
  cat <<EOF
Usage $0 run [options] command

This script run command in remote server using ssh

Options:
  -s TEXT                 Filename that has hosts to add the user.
  -u TEXT                 Username to login remote host

Eamples:
EOF
}

#### Code ####

for arg; do
  COMMAND=$arg
  break
done

shift; # remove command line


COMMAND_LIST="adduser copy-key copy run"

if [ -z $COMMAND ]; then
  print_help
  exit 1
else 
  matched=0
  for cmd in $COMMAND_LIST; do
    if [ $cmd = $COMMAND ]; then
      matched=1
      break
    fi
  done
  if [ $matched -eq 0 ]; then
    print_help
    exit 1
  fi
fi


parse_args() {
  help_page=$1
  shift
  # quoting
  QUOTED_OPTS=
  for o in $OPTS; do
    QUOTED_OPTS="$QUOTED_OPTS \"$o\""
  done

  # quotes whitespace 
  eval set -- "$QUOTED_OPTS" # this isn't working properly in OSX. it can't quote whitespace string

  while true; do
    #echo $1
    case "$1" in
    ("-u")
      USERNAME_OPTION=$2
      shift 2
    ;;
    ("-p")
      PASSWORD_OPTION=$2
      shift 2
    ;;
    ("-s")
      SERVER_OPTION=$2
      shift 2
    ;;
    ("-h"|"--help")
      eval $help_page
      exit 0
    ;;
    ("--") shift; break ;;
    esac
  done
  REMAINDER_ARGS="$@"
}

if [ $COMMAND = "adduser" ]; then
  OPTS=`getopt hu:p:s: "$@"`
  RT=$?
  if [ $RT -ne 0 ] || [ $# -eq 0 ]; then
    echo ""
    print_adduser_help
    exit 1
  fi

  parse_args "print_adduser_help" $OPTS

  if [[ ! $USERNAME_OPTION ]] || [[ ! $PASSWORD_OPTION ]] || [[ ! $SERVER_OPTION ]]; then
    require_option "$USERNAME_OPTION" "username option"
    require_option "$PASSWORD_OPTION" "password option"
    require_option "$SERVER_OPTION" "server option"
    echo ""
    print_adduser_help
    exit 1
  fi

  if [ -f $SERVER_OPTION ]; then
    for host in $(cat $SERVER_OPTION); do
      ssh $host adduser $USERNAME_OPTION
      ssh $host "echo $USERNAME_OPTION:$PASSWORD_OPTION | chpasswd"
    done
  else
      ssh $SERVER_OPTION adduser $USERNAME_OPTION
      ssh $SERVER_OPTION "echo $USERNAME_OPTION:$PASSWORD_OPTION | chpasswd"
  fi

elif [ $COMMAND = "copy-key" ]; then

  OPTS=`getopt hu:p:s: "$@"`
  RT=$?
  if [ $RT -ne 0 ] || [ $# -eq 0 ]; then
    echo ""
    print_copy-key_help
    exit 1
  fi

  parse_args "print_copy-key_help" $OPTS

  if [[ ! $USERNAME_OPTION ]] || [[ ! $PASSWORD_OPTION ]] || [[ ! $SERVER_OPTION ]]; then
    require_option "$USERNAME_OPTION" "username option"
    require_option "$PASSWORD_OPTION" "password option"
    require_option "$SERVER_OPTION" "server option"
    echo ""
    print_copy-key_help
    exit 1
  fi

  if [ ! -e ~/.ssh ] || [ ! -e ~/.ssh/id_rsa.pub ]; then
    echo "public ssh key is not exists."
    echo "Try to generate ssh key"
    $EXPECT_BIN<<EOF
    spawn ssh-keygen 
    expect {
      "Enter file in which*" {
        send "\r"
        exp_continue
      }
      "Enter passphrase*" {
        send "\r"
        exp_continue
      }
      "Enter same passphrase again*" {
        send "\r"
      }
    }
EOF
  fi
  
  if [ -f $SERVER_OPTION ]; then
    for host in $(cat $SERVER_OPTION); do
      $EXPECT_BIN<<EOF
spawn ssh-copy-id -i $HOME/.ssh/id_rsa.pub $USERNAME_OPTION@$host
expect {
  "*?assword:*" {
    send "$PASSWORD_OPTION\r"
  }
  "yes/no" {
    send "yes\r"
    exp_continue
  }
}
expect {
  "*?~]*" {
    exit
  }
}
EOF
    done 
  else
   $EXPECT_BIN<<EOF
spawn ssh-copy-id -i $HOME/.ssh/id_rsa.pub $USERNAME_OPTION@$SERVER_OPTION
expect {
  "*?assword:*" {
    send "$PASSWORD_OPTION\r"
  }
  "yes/no" {
    send "yes\r"
    exp_continue
  }
}
expect {
  "*?~]*" {
    exit
  }
}
EOF
  fi
 
elif [ $COMMAND = "copy" ]; then

  OPTS=`getopt hs:u: "$@"`
  RT=$?
  if [ $RT -ne 0 ] || [ $# -eq 0 ]; then
    echo ""
    print_copy_help
    exit 1
  fi

  parse_args "print_copy_help" $OPTS

  if [[ ! $SERVER_OPTION ]] || [[ ! $USERNAME_OPTION ]]; then
    require_option "$SERVER_OPTION" "server option"
    require_option "$USERNAME_OPTION" "username option"
    echo ""
    print_copy_help
    exit 1
  fi

  set -- $REMAINDER_ARGS
  if [ -f $SERVER_OPTION ]; then
    for host in $(cat $SERVER_OPTION); do
      scp -r $1 $USERNAME_OPTION@$host:$2
    done
  else
      scp -r $1 $USERNAME_OPTION@$SERVER_OPTION:$2
  fi

elif [ $COMMAND = "run" ]; then

  OPTS=`getopt hs:u: "$@"`
  RT=$?
  if [ $RT -ne 0 ] || [ $# -eq 0 ]; then
    echo ""
    print_run_help
    exit 1
  fi

  parse_args "print_run_help" $OPTS

  if [[ ! $SERVER_OPTION ]] || [[ ! $USERNAME_OPTION ]]; then
    require_option "$SERVER_OPTION" "server option"
    require_option "$USERNAME_OPTION" "username option"
    echo ""
    print_copy_help
    exit 1
  fi

  if [ -f $SERVER_OPTION ]; then
    for host in $(cat $SERVER_OPTION); do
      ssh $USERNAME_OPTION@$host "$REMAINDER_ARGS"
    done
  else
    ssh $USERNAME_OPTION@$SERVER_OPTION "$REMAINDER_ARGS"
  fi
else
  print_help
fi

