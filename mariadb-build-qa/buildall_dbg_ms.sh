#!/bin/bash
# Created by Roel Van de Paar, MariaDB

# No longer needed
#if [ ! -r ./terminate_ds_memory.sh ]; then
#  echo './terminate_ds_memory.sh missing!'
#  exit 1
#else
#  ./terminate_ds_memory.sh  # Terminate ~/ds and ~/memory if running (with 3 sec delay)
#fi

# Restart inside a screen if this terminal session isn't one already
if [ "${STY}" == "" ]; then
  echo "Not a screen, restarting myself inside a screen"
  screen -admS "buildall_dbg_ms" bash -c "$0;bash"
  sleep 1
  screen -d -r "buildall_dbg_ms"
  return 2> /dev/null; exit 0
fi

DIR=${PWD}
rm -Rf 5.5_dbg 5.6_dbg 5.7_dbg 8.0_dbg
cd ${DIR}/5.5 && ~/mariadb-qa/build_mdpsms_dbg.sh &
cd ${DIR}/5.6 && ~/mariadb-qa/build_mdpsms_dbg.sh &
cd ${DIR}/5.7 && ~/mariadb-qa/build_mdpsms_dbg.sh &
cd ${DIR}/8.0 && ~/mariadb-qa/build_mdpsms_dbg.sh &
