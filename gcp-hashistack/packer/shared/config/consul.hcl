data_dir = "/opt/consul/data"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
advertise_addr = "IP_ADDRESS"

bootstrap_expect = SERVER_COUNT

log_level = "INFO"

server = true
ui = true
retry_join = ["RETRY_JOIN"]

service {
  name = "consul"
}

connect {
  enabled = true
}

ports {
  grpc = 8502
}