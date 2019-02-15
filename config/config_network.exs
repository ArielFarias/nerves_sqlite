use Mix.Config

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

key = Path.join(System.user_home!(), ".ssh/id_rsa.pub")
unless File.exists?(key), do: Mix.raise("No SSH Keys found. Please generate an ssh key")

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(key)
  ]

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcpd,
  mdns_domain: "nerves.local",
  node_name: :nerves,
  node_host: :mdns_domain,
  ssh_console_port: 22

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ]