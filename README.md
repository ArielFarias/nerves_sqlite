# FirmwareDb

**TODO: Add description**

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app run these commands on a terminal with the microSD storage connect in the computer:
  * `export NERVES_NETWORK_SSID=your_network_SSID` defines wich network the Raspberry should connect
  * `export NERVES_NETWORK_PSK=your_network_password` defines the password when attempt to connect
  * `export MIX_ENV=dev` defines the environment
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`, if you receive a message telling that is unnable to find out wich are your microSD device in Linux, run `sudo fidsk -l`, the last item in list should be your microSD with the path as e.g :`/dev/sdb`. Then try to burn the firmware with `mix firmware.burn -d /dev/sdb`.
  * Insert the microSD to Raspberry Pi 3, and turn on, wait a few seconds then check the interface status:
  ```elixir
  iex> Nerves.Network.status("wlan0")
  %{
    domain: "",
    ifname: "wlan0",
    index: 3,
    ipv4_address: "10.0.1.46",
    ipv4_broadcast: "10.0.1.255",
    ipv4_gateway: "10.0.1.1",
    ipv4_subnet_mask: "255.255.255.0",
    ...
    is_up: true,
    ...
  }
  ```
  If you receive `nil` try out this https://github.com/nerves-project/nerves_examples/tree/master/hello_network#wifi-troubleshooting-tips to solve your problems.
  * Now you can connect a remote terminal to it, open a new terminal on your computer then run: `ssh -p 22 host@ip_number_from_raspberry`, e.g `ssh -p 22 host@10.0.1.46`, you will get:
  ```elixir
    Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
    Toolshed imported. Run h(Toolshed) for more info
    RingLogger is collecting log messages from Elixir and Linux. To see the
    messages, either attach the current IEx session to the logger:

    RingLogger.attach

    or print the next messages in the log:

    RingLogger.next

    iex(nerves@nerves.local)1>
  ```
  * Now you are inside the shell of the Raspberry from your computer, to get the log messages wich it are returning run: `iex(nerves@nerves.local)1> RingLogger.attach`

## Burning with OTA

In order to burn the firmware over-the-air you need to burn the project a first-time as descripted in https://github.com/ArielFarias/nerves_sqlite#getting-started.

I recommend to create a file as script.sh in root folder of your project to execute all this steps:
  ```bash
  export NERVES_NETWORK_SSID=your_network_SSID
  export NERVES_NETWORK_PSK=your_network_password
  export MIX_TARGET=rpi3
  export MIX_ENV=dev
  mix deps.clean --all
  mix deps.get
  mix firmware
  ./upload.sh the_raspberry_ip
  ```
Then run in terminal `./script.sh`

# Basic example

  Inside Raspbery Pi terminal you can try to insert and read a Weather record as:
  ```elixir
  iex(nerves@nerves.local)1> alias FirmwareDb.Repo
  Repo
  iex(nerves@nerves.local)2> %Weather{city: "New York", temp_lo: 10, temp_hi: 23, prcp: 0.25} |> Repo.insert
  00:16:53.951 [debug] QUERY OK db=22.8ms decode=0.1ms queue=0.2ms
  INSERT INTO "weather" ("city","prcp","temp_hi","temp_lo") VALUES (?1,?2,?3,?4) ;--RETURNING ON INSERT "weather","id" ["New York", 0.25, 23, 10]
  {:ok,
  %Weather{
    __meta__: #Ecto.Schema.Metadata<:loaded, "weather">,
    city: "New York",
    id: 1,
    prcp: 0.25,
    temp_hi: 23,
    temp_lo: 10
  }}
  iex(nerves@nerves.local)3> Repo.all Weather
  00:18:59.957 [debug] QUERY OK source="weather" db=5.4ms decode=0.2ms queue=0.2ms
  SELECT w0."id", w0."city", w0."temp_lo", w0."temp_hi", w0."prcp" FROM "weather" AS w0 []
  [
    %Weather{
      __meta__: #Ecto.Schema.Metadata<:loaded, "weather">,
    city: "New York",
    id: 1,
    prcp: 0.25,
    temp_hi: 23,
    temp_lo: 10
    }
  ]
  ```

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
