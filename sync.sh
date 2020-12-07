#!/bin/bash
trap 'cp /script-docker/sync.sh /sync' Exit
git clone --depth=1 https://github.com/Darkatse/script-docker.git /script-docker_tmp \
  || git clone --depth=1 https://gh.api.99988866.xyz/https://github.com/Darkatse/script-docker.git /script-docker_tmp || exit 1
[ -d /script-docker_tmp ] && {
  rm -rf /script-docker
  mv /script-docker_tmp /script-docker
}

[ $env_count ] && {
  source "/env/env$env_count"
} || source /env || exit 1
[ -e /crontab.list ] && {
  cp /crontab.list /crontab.list.old
}
echo "55 */3 * * * bash /sync 1>/proc/1/fd/1 2>/proc/1/fd/2" > /crontab.list
for element in ${script_repo_select[@]} 
do
  source "/sripts_colle/$element"
  repo_name=$(echo $script_repo_url | sed 's/\.git//' | sed 's/.*\/\([^/]*\)$/\1/')
  git clone --depth=1 $script_repo_url /scripts/${repo_name}_tmp \
    || git clone --depth=1 https://gh.api.99988866.xyz/$script_repo_url /scripts/${repo_name}_tmp || exit 1
  [ -d /scripts/${repo_name}_tmp ] && {
    rm -rf /scripts/$repo_name
    mv /scripts/${repo_name}_tmp /scripts/$repo_name
  }
  ( [ $script_type = "node" ] || [ $script_type = "nodejs" ] ) && {
    cd /scripts/$repo_name || exit 1
    npm install || npm install --registry=https://registry.npm.taobao.org || exit 1
  }
  ( [ $script_type = "python" ] || [ $script_type = "python3" ] || [ $script_type = "py" ] ) && {
    cd /scripts/$repo_name || exit 1
    pip3 install --no-cache-dir -r requirements.txt || \
      pip3 install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple ||exit 1
  }
  cat /all > /env_all
  cat /env >> /env_all
  cat /sripts_colle/$element >> /env_all
  for file in $(find /scripts/$repo_name/.github/workflows -type f)
  do
    cat $file | grep -q 'cron:' && {
      ( [ $script_type = "node" ] || [ $script_type = "nodejs" ] ) && {
        cat $file | grep -q 'node .*\.js' && {
          a=$(cat $file | sed -En "s/^.*cron: '(.*)'.*$/\1/p")
          b=$(cat $file | sed -En "s|^.*node (.*\.js)|node /scripts/$repo_name/\1|p"| sed "s///g")
          name=$(cat $file | sed -En "s|^.*name: .运行 (.*)|\1|p" | sed "s/'//g" | sed "s///g")
        }
      }
      ( [ $script_type = "python" ] || [ $script_type = "python3" ] || [ $script_type = "py" ] ) && {
        cat $file | grep -q 'python[?2/3] .*\.py' && {
          a=$(cat $file | sed -En "s/^.*cron: '(.*)'.*$/\1/p")
          b=$(cat $file | sed -En "s|^.*python[?2/3] (.*\.py)$|python /scripts/$repo_name/\1|p" | sed "s///g")
          name=$(cat $file | sed -En "s|^.*name: .运行 (.*)|\1|p" | sed "s/'//g" | sed "s///g")
        }
      }
        echo $file
        script="\"
          exec 1<>/proc/1/fd/1;
          exec 2<>/proc/1/fd/2;
          set -o allexport;
          source /env_all;
          $b | sed 's/^/$name/';
        \""
        script="$(echo -e ${script})"
        echo "$a" bash -c "$script"  >> /crontab.list
        cat -A /crontab.list
    }
  done
done

crontab -r
crontab /crontab.list || {
  cp /crontab.list.old /crontab.list
  crontab /crontab.list
}
crontab -l

[ $env_count ] && {
  rm -rf /env
} 
