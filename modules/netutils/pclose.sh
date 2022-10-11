close-port() {
  local port=${1:-0}
  iptables -D INPUT -p tcp --dport $port -j ACCEPT
}


if [[ -z "$1" ]]; then
  echo "Port not given" >&2
  exit 1
fi

close-port $1
