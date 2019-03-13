require 'ipaddress'
require 'json'

class IpCalc
  ''"
  Returns subnet details
  All methods return data in JSON format

  Required paramameters:
    subnet: ex. '192.168.0.0/24' - String
  "''

  def initialize(subnet)
    @subnet = IPAddress(subnet)
  end

  ## Returns subnets details
  def json_details
    subnet_details = [{
      subnet: @subnet.to_string,
      netmask: @subnet.netmask,
      network: @subnet.network,
      gateway: @subnet.hosts[0],
      usable: { range: "#{@subnet.hosts[1]} - #{@subnet.hosts[-1]}", hosts: @subnet.hosts.map(&:address)[1..-1] },
      broadcast: @subnet.broadcast
    }]

    JSON.pretty_generate(subnet_details)
  end

  ## Splits prefix into a specified number of ranges
  def split_by_number(number)
    prefix_split = [{
      subnet: @subnet.to_string,
      numberOfSubnet: number,
      subnetSplitByNumber: @subnet.split(number).map(&:to_string)
    }]

    JSON.pretty_generate(prefix_split)
  end

  ## Splits subnet into a specified prefix
  def split_by_prefix(prefix)
    prefix_split = [{
      subnet: @subnet.to_string,
      prefixToSplitTo: prefix,
      subnetsSplitByPrefix: @subnet.subnet(prefix).map(&:to_string)
    }]

    JSON.pretty_generate(prefix_split)
  end
end
