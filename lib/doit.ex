defmodule Doit do
  def doit() do
    SystemRegistry.delete(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "net",
        "eth0",
        "queues",
        "tx-7"
      ],
      %{"subsystem" => "queues"}
    )

    SystemRegistry.delete(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "net",
        "eth0",
        "queues",
        "tx-6"
      ],
      %{"subsystem" => "queues"}
    )

    SystemRegistry.delete(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "net",
        "eth0",
        "queues",
        "tx-5"
      ],
      %{"subsystem" => "queues"}
    )

    SystemRegistry.delete(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "net",
        "eth0",
        "queues",
        "tx-4"
      ],
      %{"subsystem" => "queues"}
    )

    SystemRegistry.delete(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "net",
        "eth0",
        "queues",
        "tx-3"
      ],
      %{"subsystem" => "queues"}
    )

    SystemRegistry.delete(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "net",
        "eth0",
        "queues",
        "tx-2"
      ],
      %{"subsystem" => "queues"}
    )

    SystemRegistry.delete(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "net",
        "eth0",
        "queues",
        "tx-1"
      ],
      %{"subsystem" => "queues"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "4804c000.gpio", "gpiochip1", "gpio", "gpio60"],
      %{"subsystem" => "gpio"}
    )

    SystemRegistry.update([:state, "devices", "virtual", "net", "tap0"], %{
      "ifindex" => "3",
      "interface" => "tap0",
      "subsystem" => "net"
    })

    SystemRegistry.update([:state, "devices", "virtual", "net", "tap0", "queues", "tx-0"], %{
      "subsystem" => "queues"
    })

    SystemRegistry.update([:state, "devices", "soc0"], %{
      "subsystem" => "soc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "vc", "vcs1"], %{
      "devname" => "vcs1",
      "major" => "7",
      "minor" => "1",
      "subsystem" => "vc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "vc", "vcsa"], %{
      "devname" => "vcsa",
      "major" => "7",
      "minor" => "128",
      "subsystem" => "vc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "vc", "vcs"], %{
      "devname" => "vcs",
      "major" => "7",
      "minor" => "0",
      "subsystem" => "vc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "vc", "vcsa1"], %{
      "devname" => "vcsa1",
      "major" => "7",
      "minor" => "129",
      "subsystem" => "vc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "vc", "vcsu"], %{
      "devname" => "vcsu",
      "major" => "7",
      "minor" => "64",
      "subsystem" => "vc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "vc", "vcsu1"], %{
      "devname" => "vcsu1",
      "major" => "7",
      "minor" => "65",
      "subsystem" => "vc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "workqueue", "writeback"], %{
      "subsystem" => "workqueue"
    })

    SystemRegistry.update([:state, "devices", "virtual", "bdi", "179:0"], %{
      "subsystem" => "bdi"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty3"], %{
      "devname" => "tty3",
      "major" => "4",
      "minor" => "3",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty11"], %{
      "devname" => "tty11",
      "major" => "4",
      "minor" => "11",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty21"], %{
      "devname" => "tty21",
      "major" => "4",
      "minor" => "21",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty31"], %{
      "devname" => "tty31",
      "major" => "4",
      "minor" => "31",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty41"], %{
      "devname" => "tty41",
      "major" => "4",
      "minor" => "41",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty5"], %{
      "devname" => "tty5",
      "major" => "4",
      "minor" => "5",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty13"], %{
      "devname" => "tty13",
      "major" => "4",
      "minor" => "13",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty51"], %{
      "devname" => "tty51",
      "major" => "4",
      "minor" => "51",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty23"], %{
      "devname" => "tty23",
      "major" => "4",
      "minor" => "23",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty61"], %{
      "devname" => "tty61",
      "major" => "4",
      "minor" => "61",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty33"], %{
      "devname" => "tty33",
      "major" => "4",
      "minor" => "33",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty43"], %{
      "devname" => "tty43",
      "major" => "4",
      "minor" => "43",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty7"], %{
      "devname" => "tty7",
      "major" => "4",
      "minor" => "7",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty15"], %{
      "devname" => "tty15",
      "major" => "4",
      "minor" => "15",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty53"], %{
      "devname" => "tty53",
      "major" => "4",
      "minor" => "53",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty25"], %{
      "devname" => "tty25",
      "major" => "4",
      "minor" => "25",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty63"], %{
      "devname" => "tty63",
      "major" => "4",
      "minor" => "63",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty35"], %{
      "devname" => "tty35",
      "major" => "4",
      "minor" => "35",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty"], %{
      "devmode" => "0666",
      "devname" => "tty",
      "major" => "5",
      "minor" => "0",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty45"], %{
      "devname" => "tty45",
      "major" => "4",
      "minor" => "45",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty9"], %{
      "devname" => "tty9",
      "major" => "4",
      "minor" => "9",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty17"], %{
      "devname" => "tty17",
      "major" => "4",
      "minor" => "17",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty55"], %{
      "devname" => "tty55",
      "major" => "4",
      "minor" => "55",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty27"], %{
      "devname" => "tty27",
      "major" => "4",
      "minor" => "27",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty37"], %{
      "devname" => "tty37",
      "major" => "4",
      "minor" => "37",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty0"], %{
      "devname" => "tty0",
      "major" => "4",
      "minor" => "0",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty47"], %{
      "devname" => "tty47",
      "major" => "4",
      "minor" => "47",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty19"], %{
      "devname" => "tty19",
      "major" => "4",
      "minor" => "19",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty57"], %{
      "devname" => "tty57",
      "major" => "4",
      "minor" => "57",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty29"], %{
      "devname" => "tty29",
      "major" => "4",
      "minor" => "29",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty39"], %{
      "devname" => "tty39",
      "major" => "4",
      "minor" => "39",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty2"], %{
      "devname" => "tty2",
      "major" => "4",
      "minor" => "2",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty10"], %{
      "devname" => "tty10",
      "major" => "4",
      "minor" => "10",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty49"], %{
      "devname" => "tty49",
      "major" => "4",
      "minor" => "49",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty20"], %{
      "devname" => "tty20",
      "major" => "4",
      "minor" => "20",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty59"], %{
      "devname" => "tty59",
      "major" => "4",
      "minor" => "59",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty30"], %{
      "devname" => "tty30",
      "major" => "4",
      "minor" => "30",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty40"], %{
      "devname" => "tty40",
      "major" => "4",
      "minor" => "40",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty4"], %{
      "devname" => "tty4",
      "major" => "4",
      "minor" => "4",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty12"], %{
      "devname" => "tty12",
      "major" => "4",
      "minor" => "12",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty50"], %{
      "devname" => "tty50",
      "major" => "4",
      "minor" => "50",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty22"], %{
      "devname" => "tty22",
      "major" => "4",
      "minor" => "22",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty60"], %{
      "devname" => "tty60",
      "major" => "4",
      "minor" => "60",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty32"], %{
      "devname" => "tty32",
      "major" => "4",
      "minor" => "32",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty42"], %{
      "devname" => "tty42",
      "major" => "4",
      "minor" => "42",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty6"], %{
      "devname" => "tty6",
      "major" => "4",
      "minor" => "6",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty14"], %{
      "devname" => "tty14",
      "major" => "4",
      "minor" => "14",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty52"], %{
      "devname" => "tty52",
      "major" => "4",
      "minor" => "52",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty24"], %{
      "devname" => "tty24",
      "major" => "4",
      "minor" => "24",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty62"], %{
      "devname" => "tty62",
      "major" => "4",
      "minor" => "62",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty34"], %{
      "devname" => "tty34",
      "major" => "4",
      "minor" => "34",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty44"], %{
      "devname" => "tty44",
      "major" => "4",
      "minor" => "44",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty8"], %{
      "devname" => "tty8",
      "major" => "4",
      "minor" => "8",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty16"], %{
      "devname" => "tty16",
      "major" => "4",
      "minor" => "16",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty54"], %{
      "devname" => "tty54",
      "major" => "4",
      "minor" => "54",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty26"], %{
      "devname" => "tty26",
      "major" => "4",
      "minor" => "26",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty36"], %{
      "devname" => "tty36",
      "major" => "4",
      "minor" => "36",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "console"], %{
      "devname" => "console",
      "major" => "5",
      "minor" => "1",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty46"], %{
      "devname" => "tty46",
      "major" => "4",
      "minor" => "46",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty18"], %{
      "devname" => "tty18",
      "major" => "4",
      "minor" => "18",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty56"], %{
      "devname" => "tty56",
      "major" => "4",
      "minor" => "56",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty28"], %{
      "devname" => "tty28",
      "major" => "4",
      "minor" => "28",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty38"], %{
      "devname" => "tty38",
      "major" => "4",
      "minor" => "38",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty1"], %{
      "devname" => "tty1",
      "major" => "4",
      "minor" => "1",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty48"], %{
      "devname" => "tty48",
      "major" => "4",
      "minor" => "48",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "ptmx"], %{
      "devmode" => "0666",
      "devname" => "ptmx",
      "major" => "5",
      "minor" => "2",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "tty", "tty58"], %{
      "devname" => "tty58",
      "major" => "4",
      "minor" => "58",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "virtual", "pmsg", "pmsg0"], %{
      "devmode" => "0220",
      "devname" => "pmsg0",
      "major" => "249",
      "minor" => "0",
      "subsystem" => "pmsg"
    })

    SystemRegistry.update([:state, "devices", "virtual", "net", "tap0"], %{
      "ifindex" => "3",
      "interface" => "tap0",
      "subsystem" => "net"
    })

    SystemRegistry.update([:state, "devices", "virtual", "net", "lo"], %{
      "ifindex" => "1",
      "interface" => "lo",
      "subsystem" => "net"
    })

    SystemRegistry.update([:state, "devices", "virtual", "misc", "network_throughput"], %{
      "devname" => "network_throughput",
      "major" => "10",
      "minor" => "61",
      "subsystem" => "misc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "misc", "cpu_dma_latency"], %{
      "devname" => "cpu_dma_latency",
      "major" => "10",
      "minor" => "63",
      "subsystem" => "misc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "misc", "memory_bandwidth"], %{
      "devname" => "memory_bandwidth",
      "major" => "10",
      "minor" => "60",
      "subsystem" => "misc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "misc", "network_latency"], %{
      "devname" => "network_latency",
      "major" => "10",
      "minor" => "62",
      "subsystem" => "misc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "misc", "tun"], %{
      "devname" => "net/tun",
      "major" => "10",
      "minor" => "200",
      "subsystem" => "misc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "misc", "hw_random"], %{
      "devname" => "hwrng",
      "major" => "10",
      "minor" => "183",
      "subsystem" => "misc"
    })

    SystemRegistry.update([:state, "devices", "virtual", "mem", "random"], %{
      "devmode" => "0666",
      "devname" => "random",
      "major" => "1",
      "minor" => "8",
      "subsystem" => "mem"
    })

    SystemRegistry.update([:state, "devices", "virtual", "mem", "null"], %{
      "devmode" => "0666",
      "devname" => "null",
      "major" => "1",
      "minor" => "3",
      "subsystem" => "mem"
    })

    SystemRegistry.update([:state, "devices", "virtual", "mem", "urandom"], %{
      "devmode" => "0666",
      "devname" => "urandom",
      "major" => "1",
      "minor" => "9",
      "subsystem" => "mem"
    })

    SystemRegistry.update([:state, "devices", "virtual", "mem", "full"], %{
      "devmode" => "0666",
      "devname" => "full",
      "major" => "1",
      "minor" => "7",
      "subsystem" => "mem"
    })

    SystemRegistry.update([:state, "devices", "virtual", "mem", "kmsg"], %{
      "devmode" => "0644",
      "devname" => "kmsg",
      "major" => "1",
      "minor" => "11",
      "subsystem" => "mem"
    })

    SystemRegistry.update([:state, "devices", "virtual", "mem", "zero"], %{
      "devmode" => "0666",
      "devname" => "zero",
      "major" => "1",
      "minor" => "5",
      "subsystem" => "mem"
    })

    SystemRegistry.update([:state, "devices", "virtual", "mem", "mem"], %{
      "devname" => "mem",
      "major" => "1",
      "minor" => "1",
      "subsystem" => "mem"
    })

    SystemRegistry.update([:state, "devices", "virtual", "vtconsole", "vtcon0"], %{
      "subsystem" => "vtconsole"
    })

    SystemRegistry.update([:state, "devices", "system", "clocksource", "clocksource0"], %{
      "subsystem" => "clocksource"
    })

    SystemRegistry.update([:state, "devices", "system", "cpu", "cpu0"], %{
      "modalias" => "cpu:type:v7l:feature:,0001,0002,0004,0006,0007,000B,000C,000D,000F,0013\n",
      "of_compatible_0" => "arm,cortex-a8",
      "of_compatible_n" => "1",
      "of_fullname" => "/cpus/cpu@0",
      "of_name" => "cpu",
      "of_type" => "cpu",
      "subsystem" => "cpu"
    })

    SystemRegistry.update([:state, "devices", "system", "clockevents", "clockevent0"], %{
      "subsystem" => "clockevents"
    })

    SystemRegistry.update([:state, "devices", "platform", "4b000000.pmu"], %{
      "modalias" => "of:NpmuT<NULL>Carm,cortex-a8-pmu",
      "of_compatible_0" => "arm,cortex-a8-pmu",
      "of_compatible_n" => "1",
      "of_fullname" => "/pmu@4b000000",
      "of_name" => "pmu",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "serial8250"], %{
      "driver" => "serial8250",
      "modalias" => "platform:serial8250",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "serial8250", "tty", "ttyS1"], %{
      "devname" => "ttyS1",
      "major" => "4",
      "minor" => "65",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "platform", "serial8250", "tty", "ttyS3"], %{
      "devname" => "ttyS3",
      "major" => "4",
      "minor" => "67",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "platform", "serial8250", "tty", "ttyS5"], %{
      "devname" => "ttyS5",
      "major" => "4",
      "minor" => "69",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "platform", "serial8250", "tty", "ttyS2"], %{
      "devname" => "ttyS2",
      "major" => "4",
      "minor" => "66",
      "subsystem" => "tty"
    })

    SystemRegistry.update([:state, "devices", "platform", "Fixed MDIO bus.0"], %{
      "modalias" => "platform:Fixed MDIO bus",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "Fixed MDIO bus.0", "mdio_bus", "fixed-0"],
      %{"subsystem" => "mdio_bus"}
    )

    SystemRegistry.update([:state, "devices", "platform", "fixedregulator0"], %{
      "driver" => "reg-fixed-voltage",
      "modalias" => "of:Nfixedregulator0T<NULL>Cregulator-fixed",
      "of_compatible_0" => "regulator-fixed",
      "of_compatible_n" => "1",
      "of_fullname" => "/fixedregulator0",
      "of_name" => "fixedregulator0",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "fixedregulator0", "regulator", "regulator.1"],
      %{
        "of_compatible_0" => "regulator-fixed",
        "of_compatible_n" => "1",
        "of_fullname" => "/fixedregulator0",
        "of_name" => "fixedregulator0",
        "subsystem" => "regulator"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ti-cpufreq"], %{
      "driver" => "ti-cpufreq",
      "modalias" => "platform:ti-cpufreq",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "alarmtimer"], %{
      "driver" => "alarmtimer",
      "modalias" => "platform:alarmtimer",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "leds"], %{
      "driver" => "leds-gpio",
      "modalias" => "of:NledsT<NULL>Cgpio-leds",
      "of_compatible_0" => "gpio-leds",
      "of_compatible_n" => "1",
      "of_fullname" => "/leds",
      "of_name" => "leds",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "leds", "leds", "test"], %{
      "of_compatible_n" => "0",
      "of_fullname" => "/leds/led@4",
      "of_name" => "led",
      "subsystem" => "leds"
    })

    SystemRegistry.update([:state, "devices", "platform", "leds", "leds", "led1:red"], %{
      "of_compatible_n" => "0",
      "of_fullname" => "/leds/led@3",
      "of_name" => "led",
      "subsystem" => "leds"
    })

    SystemRegistry.update([:state, "devices", "platform", "leds", "leds", "led1:green"], %{
      "of_compatible_n" => "0",
      "of_fullname" => "/leds/led@2",
      "of_name" => "led",
      "subsystem" => "leds"
    })

    SystemRegistry.update([:state, "devices", "platform", "88d00000.ramoops"], %{
      "driver" => "ramoops",
      "modalias" => "of:NramoopsT<NULL>Cramoops",
      "of_compatible_0" => "ramoops",
      "of_compatible_n" => "1",
      "of_fullname" => "/reserved-memory/ramoops@88d00000",
      "of_name" => "ramoops",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "4804c000.gpio"], %{
      "driver" => "omap_gpio",
      "modalias" => "of:NgpioT<NULL>Cti,omap4-gpio",
      "of_compatible_0" => "ti,omap4-gpio",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/gpio@4804c000",
      "of_name" => "gpio",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "4804c000.gpio", "gpiochip1"], %{
      "devname" => "gpiochip1",
      "major" => "254",
      "minor" => "1",
      "of_compatible_0" => "ti,omap4-gpio",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/gpio@4804c000",
      "of_name" => "gpio",
      "subsystem" => "gpio"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "4804c000.gpio", "gpiochip1", "gpio", "gpio60"],
      %{"subsystem" => "gpio"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "4804c000.gpio", "gpio", "gpiochip32"],
      %{"subsystem" => "gpio"}
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "48044000.timer"], %{
      "driver" => "omap_timer",
      "modalias" => "of:NtimerT<NULL>Cti,am335x-timer",
      "of_compatible_0" => "ti,am335x-timer",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/timer@48044000",
      "of_name" => "timer",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "44e0b000.i2c"], %{
      "driver" => "omap_i2c",
      "modalias" => "of:Ni2cT<NULL>Cti,omap4-i2c",
      "of_alias_0" => "i2c0",
      "of_compatible_0" => "ti,omap4-i2c",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/i2c@44e0b000",
      "of_name" => "i2c",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "44e0b000.i2c", "i2c-0"], %{
      "of_alias_0" => "i2c0",
      "of_compatible_0" => "ti,omap4-i2c",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/i2c@44e0b000",
      "of_name" => "i2c",
      "subsystem" => "i2c"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e0b000.i2c", "i2c-0", "i2c-dev", "i2c-0"],
      %{
        "devname" => "i2c-0",
        "major" => "89",
        "minor" => "0",
        "subsystem" => "i2c-dev"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e0b000.i2c", "i2c-0", "0-0024"],
      %{
        "driver" => "tps65217",
        "modalias" => "of:NtpsT<NULL>Cti,tps65217",
        "of_compatible_0" => "ti,tps65217",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24",
        "of_name" => "tps",
        "subsystem" => "i2c"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "tps65217-charger"
      ],
      %{
        "devtype" => "mfd_device",
        "modalias" => "of:NchargerT<NULL>Cti,tps65217-charger",
        "of_compatible_0" => "ti,tps65217-charger",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/charger",
        "of_name" => "charger",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "regulator",
        "regulator.8"
      ],
      %{
        "of_compatible_n" => "0",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/regulators/regulator@6",
        "of_name" => "regulator",
        "subsystem" => "regulator"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "regulator",
        "regulator.3"
      ],
      %{
        "of_compatible_n" => "0",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/regulators/regulator@1",
        "of_name" => "regulator",
        "subsystem" => "regulator"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "regulator",
        "regulator.5"
      ],
      %{
        "of_compatible_n" => "0",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/regulators/regulator@3",
        "of_name" => "regulator",
        "subsystem" => "regulator"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "regulator",
        "regulator.7"
      ],
      %{
        "of_compatible_n" => "0",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/regulators/regulator@5",
        "of_name" => "regulator",
        "subsystem" => "regulator"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "regulator",
        "regulator.2"
      ],
      %{
        "of_compatible_n" => "0",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/regulators/regulator@0",
        "of_name" => "regulator",
        "subsystem" => "regulator"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "regulator",
        "regulator.4"
      ],
      %{
        "of_compatible_n" => "0",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/regulators/regulator@2",
        "of_name" => "regulator",
        "subsystem" => "regulator"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "regulator",
        "regulator.6"
      ],
      %{
        "of_compatible_n" => "0",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/regulators/regulator@4",
        "of_name" => "regulator",
        "subsystem" => "regulator"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "44e0b000.i2c",
        "i2c-0",
        "0-0024",
        "tps65217-pwrbutton"
      ],
      %{
        "devtype" => "mfd_device",
        "modalias" => "of:NpwrbuttonT<NULL>Cti,tps65217-pwrbutton",
        "of_compatible_0" => "ti,tps65217-pwrbutton",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/i2c@44e0b000/tps@24/pwrbutton",
        "of_name" => "pwrbutton",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e0b000.i2c", "i2c-0", "0-0024", "tps65217-pmic"],
      %{
        "devtype" => "mfd_device",
        "driver" => "tps65217-pmic",
        "modalias" => "platform:tps65217-pmic",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e0b000.i2c", "i2c-0", "0-0024", "tps65217-bl"],
      %{
        "devtype" => "mfd_device",
        "modalias" => "platform:tps65217-bl",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "481ac000.gpio"], %{
      "driver" => "omap_gpio",
      "modalias" => "of:NgpioT<NULL>Cti,omap4-gpio",
      "of_compatible_0" => "ti,omap4-gpio",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/gpio@481ac000",
      "of_name" => "gpio",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "481ac000.gpio", "gpiochip2"], %{
      "devname" => "gpiochip2",
      "major" => "254",
      "minor" => "2",
      "of_compatible_0" => "ti,omap4-gpio",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/gpio@481ac000",
      "of_name" => "gpio",
      "subsystem" => "gpio"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "481ac000.gpio", "gpio", "gpiochip64"],
      %{"subsystem" => "gpio"}
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp"], %{
      "modalias" => "of:NocpT<NULL>Csimple-bus",
      "of_compatible_0" => "simple-bus",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp",
      "of_name" => "ocp",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "481a8000.serial"], %{
      "driver" => "omap8250",
      "modalias" => "of:NserialT<NULL>Cti,am3352-uartCti,omap3-uart",
      "of_alias_0" => "serial4",
      "of_compatible_0" => "ti,am3352-uart",
      "of_compatible_1" => "ti,omap3-uart",
      "of_compatible_n" => "2",
      "of_fullname" => "/ocp/serial@481a8000",
      "of_name" => "serial",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "481a8000.serial", "tty", "ttyS4"],
      %{
        "devname" => "ttyS4",
        "major" => "4",
        "minor" => "68",
        "subsystem" => "tty"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "49900000.tptc"], %{
      "driver" => "edma3-tptc",
      "modalias" => "of:NtptcT<NULL>Cti,edma3-tptc",
      "of_compatible_0" => "ti,edma3-tptc",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/tptc@49900000",
      "of_name" => "tptc",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "48060000.mmc"], %{
      "driver" => "omap_hsmmc",
      "modalias" => "of:NmmcT<NULL>Cti,omap4-hsmmc",
      "of_compatible_0" => "ti,omap4-hsmmc",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/mmc@48060000",
      "of_name" => "mmc",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "48060000.mmc", "mmc_host", "mmc0"],
      %{"subsystem" => "mmc_host"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "48060000.mmc", "mmc_host", "mmc0", "mmc0:1234"],
      %{
        "driver" => "mmcblk",
        "mmc_name" => "SA08G",
        "mmc_type" => "SD",
        "modalias" => "mmc:block",
        "subsystem" => "mmc"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "48060000.mmc",
        "mmc_host",
        "mmc0",
        "mmc0:1234",
        "block",
        "mmcblk0"
      ],
      %{
        "devname" => "mmcblk0",
        "devtype" => "disk",
        "major" => "179",
        "minor" => "0",
        "subsystem" => "block"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "48060000.mmc",
        "mmc_host",
        "mmc0",
        "mmc0:1234",
        "block",
        "mmcblk0",
        "mmcblk0p1"
      ],
      %{
        "devname" => "mmcblk0p1",
        "devtype" => "partition",
        "major" => "179",
        "minor" => "1",
        "partn" => "1",
        "subsystem" => "block"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "48060000.mmc",
        "mmc_host",
        "mmc0",
        "mmc0:1234",
        "block",
        "mmcblk0",
        "mmcblk0p3"
      ],
      %{
        "devname" => "mmcblk0p3",
        "devtype" => "partition",
        "major" => "179",
        "minor" => "3",
        "partn" => "3",
        "subsystem" => "block"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "48060000.mmc",
        "mmc_host",
        "mmc0",
        "mmc0:1234",
        "block",
        "mmcblk0",
        "mmcblk0p2"
      ],
      %{
        "devname" => "mmcblk0p2",
        "devtype" => "partition",
        "major" => "179",
        "minor" => "2",
        "partn" => "2",
        "subsystem" => "block"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "48060000.mmc",
        "mmc_host",
        "mmc0",
        "mmc0:1234",
        "block",
        "mmcblk0",
        "mmcblk0p4"
      ],
      %{
        "devname" => "mmcblk0p4",
        "devtype" => "partition",
        "major" => "179",
        "minor" => "4",
        "partn" => "4",
        "subsystem" => "block"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "480ca000.spinlock"], %{
      "driver" => "omap_hwspinlock",
      "modalias" => "of:NspinlockT<NULL>Cti,omap4-hwspinlock",
      "of_compatible_0" => "ti,omap4-hwspinlock",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/spinlock@480ca000",
      "of_name" => "spinlock",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "44e35000.wdt"], %{
      "driver" => "omap_wdt",
      "modalias" => "of:NwdtT<NULL>Cti,omap3-wdt",
      "of_compatible_0" => "ti,omap3-wdt",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/wdt@44e35000",
      "of_name" => "wdt",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e35000.wdt", "watchdog", "watchdog0"],
      %{
        "devname" => "watchdog0",
        "major" => "252",
        "minor" => "0",
        "subsystem" => "watchdog"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e35000.wdt", "misc", "watchdog"],
      %{
        "devname" => "watchdog",
        "major" => "10",
        "minor" => "130",
        "subsystem" => "misc"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "49a00000.tptc"], %{
      "driver" => "edma3-tptc",
      "modalias" => "of:NtptcT<NULL>Cti,edma3-tptc",
      "of_compatible_0" => "ti,edma3-tptc",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/tptc@49a00000",
      "of_name" => "tptc",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "48046000.timer"], %{
      "driver" => "omap_timer",
      "modalias" => "of:NtimerT<NULL>Cti,am335x-timer",
      "of_compatible_0" => "ti,am335x-timer",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/timer@48046000",
      "of_name" => "timer",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "481ae000.gpio"], %{
      "driver" => "omap_gpio",
      "modalias" => "of:NgpioT<NULL>Cti,omap4-gpio",
      "of_compatible_0" => "ti,omap4-gpio",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/gpio@481ae000",
      "of_name" => "gpio",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "481ae000.gpio", "gpiochip3"], %{
      "devname" => "gpiochip3",
      "major" => "254",
      "minor" => "3",
      "of_compatible_0" => "ti,omap4-gpio",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/gpio@481ae000",
      "of_name" => "gpio",
      "subsystem" => "gpio"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "481ae000.gpio", "gpio", "gpiochip96"],
      %{"subsystem" => "gpio"}
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "4804a000.timer"], %{
      "driver" => "omap_timer",
      "modalias" => "of:NtimerT<NULL>Cti,am335x-timer",
      "of_compatible_0" => "ti,am335x-timer",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/timer@4804a000",
      "of_name" => "timer",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "49000000.edma"], %{
      "driver" => "edma",
      "modalias" => "of:NedmaT<NULL>Cti,edma3-tpcc",
      "of_compatible_0" => "ti,edma3-tpcc",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/edma@49000000",
      "of_name" => "edma",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan34"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan44"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan16"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan3"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan54"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan26"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan36"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma1chan1"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan46"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan18"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan5"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan56"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan28"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan38"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan48"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan7"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan58"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan11"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan21"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan9"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan31"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan41"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan13"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan0"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan51"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan23"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan61"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan33"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan43"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan15"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan2"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan53"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan25"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan35"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma1chan0"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan45"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan17"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan4"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan55"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan27"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan37"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan47"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan19"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan6"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan57"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan29"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan39"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan10"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan49"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan20"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan8"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan59"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan30"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan40"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan12"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan50"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan22"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan60"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan32"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan42"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan14"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan1"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan52"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "49000000.edma", "dma", "dma0chan24"],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44d00000.wkup_m3",
        "remoteproc",
        "remoteproc0"
      ],
      %{"devtype" => "remoteproc", "subsystem" => "remoteproc"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "ocp:l4_wkup@44c00000", "44d00000.wkup_m3"],
      %{
        "driver" => "wkup_m3_rproc",
        "modalias" => "of:Nwkup_m3T<NULL>Cti,am3352-wkup-m3",
        "of_compatible_0" => "ti,am3352-wkup-m3",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/wkup_m3@100000",
        "of_name" => "wkup_m3",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "ocp:l4_wkup@44c00000"], %{
      "modalias" => "of:Nl4_wkupT<NULL>Cti,am3-l4-wkupCsimple-bus",
      "of_compatible_0" => "ti,am3-l4-wkup",
      "of_compatible_1" => "simple-bus",
      "of_compatible_n" => "2",
      "of_fullname" => "/ocp/l4_wkup@44c00000",
      "of_name" => "l4_wkup",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e10000.scm",
        "44e10f90.dma-router"
      ],
      %{
        "driver" => "ti-dma-crossbar",
        "modalias" => "of:Ndma-routerT<NULL>Cti,am335x-edma-crossbar",
        "of_compatible_0" => "ti,am335x-edma-crossbar",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/scm@210000/dma-router@f90",
        "of_name" => "dma-router",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e10000.scm",
        "44e10800.pinmux"
      ],
      %{
        "driver" => "pinctrl-single",
        "modalias" => "of:NpinmuxT<NULL>Cpinctrl-single",
        "of_compatible_0" => "pinctrl-single",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/scm@210000/pinmux@800",
        "of_name" => "pinmux",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "ocp:l4_wkup@44c00000", "44e10000.scm"],
      %{
        "modalias" => "of:NscmT<NULL>Cti,am3-scmCsimple-bus",
        "of_compatible_0" => "ti,am3-scm",
        "of_compatible_1" => "simple-bus",
        "of_compatible_n" => "2",
        "of_fullname" => "/ocp/l4_wkup@44c00000/scm@210000",
        "of_name" => "scm",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e10000.scm",
        "44e10000.scm_conf"
      ],
      %{
        "modalias" => "of:Nscm_confT<NULL>CsysconCsimple-bus",
        "of_compatible_0" => "syscon",
        "of_compatible_1" => "simple-bus",
        "of_compatible_n" => "2",
        "of_fullname" => "/ocp/l4_wkup@44c00000/scm@210000/scm_conf@0",
        "of_name" => "scm_conf",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e10000.scm",
        "44e11324.wkup_m3_ipc"
      ],
      %{
        "driver" => "wkup_m3_ipc",
        "modalias" => "of:Nwkup_m3_ipcT<NULL>Cti,am3352-wkup-m3-ipc",
        "of_compatible_0" => "ti,am3352-wkup-m3-ipc",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/scm@210000/wkup_m3_ipc@1324",
        "of_name" => "wkup_m3_ipc",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "ocp:l4_wkup@44c00000", "44e00000.prcm"],
      %{
        "modalias" => "of:NprcmT<NULL>Cti,am3-prcmCsimple-bus",
        "of_compatible_0" => "ti,am3-prcm",
        "of_compatible_1" => "simple-bus",
        "of_compatible_n" => "2",
        "of_fullname" => "/ocp/l4_wkup@44c00000/prcm@200000",
        "of_name" => "prcm",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e00000.prcm",
        "44e00a00.l4_cefuse_cm"
      ],
      %{
        "modalias" => "of:Nl4_cefuse_cmT<NULL>Cti,omap4-cm",
        "of_compatible_0" => "ti,omap4-cm",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/prcm@200000/l4_cefuse_cm@a00",
        "of_name" => "l4_cefuse_cm",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e00000.prcm",
        "44e00800.l4_rtc_cm"
      ],
      %{
        "modalias" => "of:Nl4_rtc_cmT<NULL>Cti,omap4-cm",
        "of_compatible_0" => "ti,omap4-cm",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/prcm@200000/l4_rtc_cm@800",
        "of_name" => "l4_rtc_cm",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e00000.prcm",
        "44e00600.mpu_cm"
      ],
      %{
        "modalias" => "of:Nmpu_cmT<NULL>Cti,omap4-cm",
        "of_compatible_0" => "ti,omap4-cm",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/prcm@200000/mpu_cm@600",
        "of_name" => "mpu_cm",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e00000.prcm",
        "44e00900.gfx_l3_cm"
      ],
      %{
        "modalias" => "of:Ngfx_l3_cmT<NULL>Cti,omap4-cm",
        "of_compatible_0" => "ti,omap4-cm",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/prcm@200000/gfx_l3_cm@900",
        "of_name" => "gfx_l3_cm",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e00000.prcm",
        "44e00400.l4_wkup_cm"
      ],
      %{
        "modalias" => "of:Nl4_wkup_cmT<NULL>Cti,omap4-cm",
        "of_compatible_0" => "ti,omap4-cm",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/prcm@200000/l4_wkup_cm@400",
        "of_name" => "l4_wkup_cm",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "ocp:l4_wkup@44c00000",
        "44e00000.prcm",
        "44e00000.l4_per_cm"
      ],
      %{
        "modalias" => "of:Nl4_per_cmT<NULL>Cti,omap4-cm",
        "of_compatible_0" => "ti,omap4-cm",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/l4_wkup@44c00000/prcm@200000/l4_per_cm@0",
        "of_name" => "l4_per_cm",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "49800000.tptc"], %{
      "driver" => "edma3-tptc",
      "modalias" => "of:NtptcT<NULL>Cti,edma3-tptc",
      "of_compatible_0" => "ti,edma3-tptc",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/tptc@49800000",
      "of_name" => "tptc",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "4a100000.ethernet"], %{
      "driver" => "cpsw",
      "modalias" => "of:NethernetT<NULL>Cti,am335x-cpswCti,cpsw",
      "of_compatible_0" => "ti,am335x-cpsw",
      "of_compatible_1" => "ti,cpsw",
      "of_compatible_n" => "2",
      "of_fullname" => "/ocp/ethernet@4a100000",
      "of_name" => "ethernet",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "4a100000.ethernet", "44e10650.cpsw-phy-sel"],
      %{
        "driver" => "cpsw-phy-sel",
        "modalias" => "of:Ncpsw-phy-selT<NULL>Cti,am3352-cpsw-phy-sel",
        "of_compatible_0" => "ti,am3352-cpsw-phy-sel",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/ethernet@4a100000/cpsw-phy-sel@44e10650",
        "of_name" => "cpsw-phy-sel",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "4a100000.ethernet", "4a101000.mdio"],
      %{
        "driver" => "davinci_mdio",
        "modalias" => "of:NmdioT<NULL>Cti,cpsw-mdioCti,davinci_mdio",
        "of_compatible_0" => "ti,cpsw-mdio",
        "of_compatible_1" => "ti,davinci_mdio",
        "of_compatible_n" => "2",
        "of_fullname" => "/ocp/ethernet@4a100000/mdio@4a101000",
        "of_name" => "mdio",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "4a101000.mdio",
        "mdio_bus",
        "4a101000.mdio"
      ],
      %{
        "of_compatible_0" => "ti,cpsw-mdio",
        "of_compatible_1" => "ti,davinci_mdio",
        "of_compatible_n" => "2",
        "of_fullname" => "/ocp/ethernet@4a100000/mdio@4a101000",
        "of_name" => "mdio",
        "subsystem" => "mdio_bus"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "4a100000.ethernet",
        "4a101000.mdio",
        "mdio_bus",
        "4a101000.mdio",
        "4a101000.mdio:00"
      ],
      %{
        "devtype" => "PHY",
        "driver" => "SMSC LAN8710/LAN8720",
        "modalias" => "of:NT<NULL>",
        "of_compatible_n" => "0",
        "of_fullname" => "/ocp/ethernet@4a100000/mdio@4a101000/@cpsw_emac0",
        "of_name" => "",
        "subsystem" => "mdio_bus"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "4a100000.ethernet", "net", "eth0"],
      %{"ifindex" => "2", "interface" => "eth0", "subsystem" => "net"}
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "53100000.sham"], %{
      "modalias" => "of:NshamT<NULL>Cti,omap4-sham",
      "of_compatible_0" => "ti,omap4-sham",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/sham@53100000",
      "of_name" => "sham",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "44e3e000.rtc"], %{
      "modalias" => "of:NrtcT<NULL>Cti,am3352-rtcCti,da830-rtc",
      "of_compatible_0" => "ti,am3352-rtc",
      "of_compatible_1" => "ti,da830-rtc",
      "of_compatible_n" => "2",
      "of_fullname" => "/ocp/rtc@44e3e000",
      "of_name" => "rtc",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "48042000.timer"], %{
      "driver" => "omap_timer",
      "modalias" => "of:NtimerT<NULL>Cti,am335x-timer",
      "of_compatible_0" => "ti,am335x-timer",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/timer@48042000",
      "of_name" => "timer",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "53500000.aes"], %{
      "modalias" => "of:NaesT<NULL>Cti,omap4-aes",
      "of_compatible_0" => "ti,omap4-aes",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/aes@53500000",
      "of_name" => "aes",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "480c8000.mailbox", "mbox", "wkup_m3"],
      %{"subsystem" => "mbox"}
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "480c8000.mailbox"], %{
      "driver" => "omap-mailbox",
      "modalias" => "of:NmailboxT<NULL>Cti,omap4-mailbox",
      "of_compatible_0" => "ti,omap4-mailbox",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/mailbox@480c8000",
      "of_name" => "mailbox",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "48310000.rng"], %{
      "driver" => "omap_rng",
      "modalias" => "of:NrngT<NULL>Cti,omap4-rng",
      "of_compatible_0" => "ti,omap4-rng",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/rng@48310000",
      "of_name" => "rng",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "4802a000.i2c"], %{
      "driver" => "omap_i2c",
      "modalias" => "of:Ni2cT<NULL>Cti,omap4-i2c",
      "of_alias_0" => "i2c1",
      "of_compatible_0" => "ti,omap4-i2c",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/i2c@4802a000",
      "of_name" => "i2c",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "4802a000.i2c", "i2c-1"], %{
      "of_alias_0" => "i2c1",
      "of_compatible_0" => "ti,omap4-i2c",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/i2c@4802a000",
      "of_name" => "i2c",
      "subsystem" => "i2c"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "4802a000.i2c", "i2c-1", "i2c-dev", "i2c-1"],
      %{
        "devname" => "i2c-1",
        "major" => "89",
        "minor" => "1",
        "subsystem" => "i2c-dev"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "44e07000.gpio"], %{
      "driver" => "omap_gpio",
      "modalias" => "of:NgpioT<NULL>Cti,omap4-gpio",
      "of_compatible_0" => "ti,omap4-gpio",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/gpio@44e07000",
      "of_name" => "gpio",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "44e07000.gpio", "gpiochip0"], %{
      "devname" => "gpiochip0",
      "major" => "254",
      "minor" => "0",
      "of_compatible_0" => "ti,omap4-gpio",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/gpio@44e07000",
      "of_name" => "gpio",
      "subsystem" => "gpio"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e07000.gpio", "gpio", "gpiochip0"],
      %{"subsystem" => "gpio"}
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "48048000.timer"], %{
      "driver" => "omap_timer",
      "modalias" => "of:NtimerT<NULL>Cti,am335x-timer",
      "of_compatible_0" => "ti,am335x-timer",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/timer@48048000",
      "of_name" => "timer",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "4a326004.pruss-soc-bus"], %{
      "modalias" => "of:Npruss_soc_busT<NULL>Cti,am3356-pruss-soc-bus",
      "of_compatible_0" => "ti,am3356-pruss-soc-bus",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/pruss_soc_bus@4a326004",
      "of_name" => "pruss_soc_bus",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "44e0d000.tscadc"], %{
      "driver" => "ti_am3359-tscadc",
      "modalias" => "of:NtscadcT<NULL>Cti,am3359-tscadc",
      "of_compatible_0" => "ti,am3359-tscadc",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/tscadc@44e0d000",
      "of_name" => "tscadc",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e0d000.tscadc", "TI-am335x-adc"],
      %{
        "devtype" => "mfd_device",
        "driver" => "TI-am335x-adc",
        "modalias" => "of:NadcT<NULL>Cti,am3359-adc",
        "of_compatible_0" => "ti,am3359-adc",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/tscadc@44e0d000/adc",
        "of_name" => "adc",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e0d000.tscadc", "TI-am335x-adc", "iio:device0"],
      %{
        "devname" => "iio:device0",
        "devtype" => "iio_device",
        "major" => "253",
        "minor" => "0",
        "of_compatible_0" => "ti,am3359-adc",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/tscadc@44e0d000/adc",
        "of_name" => "adc",
        "subsystem" => "iio"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "4c000000.emif"], %{
      "modalias" => "of:NemifT<NULL>Cti,emif-am3352",
      "of_compatible_0" => "ti,emif-am3352",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/emif@4c000000",
      "of_name" => "emif",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "ocp", "44e09000.serial"], %{
      "driver" => "omap8250",
      "modalias" => "of:NserialT<NULL>Cti,am3352-uartCti,omap3-uart",
      "of_alias_0" => "serial0",
      "of_compatible_0" => "ti,am3352-uart",
      "of_compatible_1" => "ti,omap3-uart",
      "of_compatible_n" => "2",
      "of_fullname" => "/ocp/serial@44e09000",
      "of_name" => "serial",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "44e09000.serial", "tty", "ttyS0"],
      %{
        "devname" => "ttyS0",
        "major" => "4",
        "minor" => "64",
        "subsystem" => "tty"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "40300000.ocmcram"], %{
      "driver" => "sram",
      "modalias" => "of:NocmcramT<NULL>Cmmio-sram",
      "of_compatible_0" => "mmio-sram",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/ocmcram@40300000",
      "of_name" => "ocmcram",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "47400000.usb", "47401300.usb-phy"],
      %{
        "driver" => "am335x-phy-driver",
        "modalias" => "of:Nusb-phyT<NULL>Cti,am335x-usb-phy",
        "of_alias_0" => "phy0",
        "of_compatible_0" => "ti,am335x-usb-phy",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb-phy@47401300",
        "of_name" => "usb-phy",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "ocp", "47400000.usb"], %{
      "driver" => "am335x-usb-childs",
      "modalias" => "of:NusbT<NULL>Cti,am33xx-usb",
      "of_compatible_0" => "ti,am33xx-usb",
      "of_compatible_n" => "1",
      "of_fullname" => "/ocp/usb@47400000",
      "of_name" => "usb",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "47400000.usb", "47400000.dma-controller"],
      %{
        "driver" => "cppi41-dma-engine",
        "modalias" => "of:Ndma-controllerT<NULL>Cti,am3359-cppi41",
        "of_compatible_0" => "ti,am3359-cppi41",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/dma-controller@47402000",
        "of_name" => "dma-controller",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan19"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan6"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan57"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan29"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan39"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan10"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan49"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan20"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan8"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan59"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan30"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan40"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan12"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan50"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan22"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan32"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan42"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan14"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan1"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan52"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan24"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan34"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan44"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan16"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan3"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan54"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan26"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan36"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan46"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan18"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan5"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan56"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan28"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan38"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan48"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan7"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan58"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan11"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan21"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan9"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan31"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan41"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan13"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan0"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan51"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan23"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan33"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan43"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan15"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan2"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan53"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan25"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan35"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan45"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan17"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan4"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan55"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan27"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan37"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47400000.dma-controller",
        "dma",
        "dma2chan47"
      ],
      %{"subsystem" => "dma"}
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "47400000.usb", "47401c00.usb"],
      %{
        "driver" => "musb-dsps",
        "modalias" => "of:NusbT<NULL>Cti,musb-am33xx",
        "of_alias_0" => "usb1",
        "of_compatible_0" => "ti,musb-am33xx",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb@47401800",
        "of_name" => "usb",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "47400000.usb", "47401c00.usb", "musb-hdrc.1"],
      %{
        "driver" => "musb-hdrc",
        "modalias" => "of:NusbT<NULL>Cti,musb-am33xx",
        "of_alias_0" => "usb1",
        "of_compatible_0" => "ti,musb-am33xx",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb@47401800",
        "of_name" => "usb",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47401c00.usb",
        "musb-hdrc.1",
        "usb2",
        "2-0:1.0"
      ],
      %{
        "devtype" => "usb_interface",
        "driver" => "hub",
        "interface" => "9/0/0",
        "modalias" => "usb:v1D6Bp0002d0419dc09dsc00dp01ic09isc00ip00in00",
        "of_alias_0" => "usb1",
        "of_compatible_0" => "ti,musb-am33xx",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb@47401800",
        "of_name" => "usb",
        "product" => "1d6b/2/419",
        "subsystem" => "usb",
        "type" => "9/0/1"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47401c00.usb",
        "musb-hdrc.1",
        "usb2"
      ],
      %{
        "busnum" => "002",
        "devname" => "bus/usb/002/001",
        "devnum" => "001",
        "devtype" => "usb_device",
        "driver" => "usb",
        "major" => "189",
        "minor" => "128",
        "of_alias_0" => "usb1",
        "of_compatible_0" => "ti,musb-am33xx",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb@47401800",
        "of_name" => "usb",
        "product" => "1d6b/2/419",
        "subsystem" => "usb",
        "type" => "9/0/1"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "47400000.usb", "47401b00.usb-phy"],
      %{
        "driver" => "am335x-phy-driver",
        "modalias" => "of:Nusb-phyT<NULL>Cti,am335x-usb-phy",
        "of_alias_0" => "phy1",
        "of_compatible_0" => "ti,am335x-usb-phy",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb-phy@47401b00",
        "of_name" => "usb-phy",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "47400000.usb", "47401400.usb"],
      %{
        "driver" => "musb-dsps",
        "modalias" => "of:NusbT<NULL>Cti,musb-am33xx",
        "of_alias_0" => "usb0",
        "of_compatible_0" => "ti,musb-am33xx",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb@47401000",
        "of_name" => "usb",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "47400000.usb", "47401400.usb", "musb-hdrc.0"],
      %{
        "driver" => "musb-hdrc",
        "modalias" => "of:NusbT<NULL>Cti,musb-am33xx",
        "of_alias_0" => "usb0",
        "of_compatible_0" => "ti,musb-am33xx",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb@47401000",
        "of_name" => "usb",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47401400.usb",
        "musb-hdrc.0",
        "usb1"
      ],
      %{
        "busnum" => "001",
        "devname" => "bus/usb/001/001",
        "devnum" => "001",
        "devtype" => "usb_device",
        "driver" => "usb",
        "major" => "189",
        "minor" => "0",
        "of_alias_0" => "usb0",
        "of_compatible_0" => "ti,musb-am33xx",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb@47401000",
        "of_name" => "usb",
        "product" => "1d6b/2/419",
        "subsystem" => "usb",
        "type" => "9/0/1"
      }
    )

    SystemRegistry.update(
      [
        :state,
        "devices",
        "platform",
        "ocp",
        "47400000.usb",
        "47401400.usb",
        "musb-hdrc.0",
        "usb1",
        "1-0:1.0"
      ],
      %{
        "devtype" => "usb_interface",
        "driver" => "hub",
        "interface" => "9/0/0",
        "modalias" => "usb:v1D6Bp0002d0419dc09dsc00dp01ic09isc00ip00in00",
        "of_alias_0" => "usb0",
        "of_compatible_0" => "ti,musb-am33xx",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/usb@47401000",
        "of_name" => "usb",
        "product" => "1d6b/2/419",
        "subsystem" => "usb",
        "type" => "9/0/1"
      }
    )

    SystemRegistry.update(
      [:state, "devices", "platform", "ocp", "47400000.usb", "44e10620.control"],
      %{
        "driver" => "am335x-control-usb",
        "modalias" => "of:NcontrolT<NULL>Cti,am335x-usb-ctrl-module",
        "of_compatible_0" => "ti,am335x-usb-ctrl-module",
        "of_compatible_n" => "1",
        "of_fullname" => "/ocp/usb@47400000/control@44e10620",
        "of_name" => "control",
        "subsystem" => "platform"
      }
    )

    SystemRegistry.update([:state, "devices", "platform", "cpufreq-dt"], %{
      "driver" => "cpufreq-dt",
      "modalias" => "platform:cpufreq-dt",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "soc", "soc:mpu"], %{
      "modalias" => "of:NmpuT<NULL>Cti,omap3-mpu",
      "of_compatible_0" => "ti,omap3-mpu",
      "of_compatible_n" => "1",
      "of_fullname" => "/soc/mpu",
      "of_name" => "mpu",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "soc"], %{
      "modalias" => "of:NsocT<NULL>Cti,omap-infra",
      "of_compatible_0" => "ti,omap-infra",
      "of_compatible_n" => "1",
      "of_fullname" => "/soc",
      "of_name" => "soc",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "pm33xx"], %{
      "modalias" => "platform:pm33xx",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "opp-table"], %{
      "modalias" => "of:Nopp-tableT<NULL>Coperating-points-v2-ti-cpu",
      "of_compatible_0" => "operating-points-v2-ti-cpu",
      "of_compatible_n" => "1",
      "of_fullname" => "/opp-table",
      "of_name" => "opp-table",
      "subsystem" => "platform"
    })

    SystemRegistry.update([:state, "devices", "platform", "reg-dummy"], %{
      "driver" => "reg-dummy",
      "modalias" => "platform:reg-dummy",
      "subsystem" => "platform"
    })

    SystemRegistry.update(
      [:state, "devices", "platform", "reg-dummy", "regulator", "regulator.0"],
      %{"subsystem" => "regulator"}
    )

    true
  end
end
