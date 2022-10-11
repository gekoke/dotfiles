open-port() {
  local port=$1
  iptables -A INPUT -p tcp --dport $port -j ACCEPT
}

if [[ -z "$1" ]]; then
  echo "Port not given" >&2
  exit 1
fi

open-port $1
