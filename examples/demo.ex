SystemRegistry.update([:state, :network_interface, "eth0", :address], "192.168.1.100")

SystemRegistry.transaction
|> SystemRegistry.update([:state, :network_interface, "eth0", :address], "192.168.1.100")
|> SystemRegistry.update([:state, :network_interface, "eth0", :subnet], "255.255.255.0")
|> SystemRegistry.commit

@doc """
Transactions are a struct for building the resulting nodes until they are asked to commit

In the above example of a transaction, the following node records would be created

Key: {:state}
Value:

Key: {:state, :network_interface}
Value: ["eth0": nil]

Key: {:state, :network_interface, "eth0"}
value: [address: <PID>]

nodes:
[{{:state, :network_interface, "eth0"}}, [address: <PID>, subnet: <PID>]]

update:
%{state: %{network_interface: %{"eth0" => %{address: "192.168.1.100", subnet: "255.255.255.0"}}}}


"""
