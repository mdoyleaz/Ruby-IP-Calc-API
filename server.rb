require 'sinatra'
require 'json'

require_relative 'ipcalc'

## Switch-Case for handling options passed by API endpoints
def calc_case(option, subnet, split = nil)
  ip = IpCalc.new(subnet)
  puts split
  puts subnet
  case option
  when 'details'
    return ip.json_details
  when 'splitcount'
    return ip.split_by_number(split)
  when 'splitprefix'
    return ip.split_by_prefix(split)
  end
end

post '/ipcalc' do
  '''
  Returns subnet details
  Endpoint: "http://127.0.0.1:4567/ipcalc"
  METHOD: POST
  Required Payload:
    {
      "subnet": "192.168.0.0/24"
    }
  '''

  push = JSON.parse(request.body.read)

  if push['subnet']
    response = calc_case('details', push['subnet'])
  else
    status 400
    response = { error: 'invalid request' }.to_json
  end

  body(response)
end

post '/ipcalc/splitcount' do
  '''
  Returns splits a subnet into a specified number of subnets
  Endpoint: "http://127.0.0.1:4567/ipcalc/splitcount"
  Method: POST
  Required Payload:
    {
      "subnet": "192.168.0.0/24",
      "splitCount": 2
    }
  '''

  push = JSON.parse(request.body.read)

  if push['subnet'] && push['splitCount']
    response = calc_case('splitcount', push['subnet'], push['splitCount'])
  else
    status 400
    response = { error: 'invalid request' }.to_json
  end

  body(response)
end

post '/ipcalc/splitprefix' do
  '''
  Returns subnet split by a specified prefix
  Endpoint: "http://127.0.0.1:4567/ipcalc/splitprefix"
  METHOD: POST
  Required Payload:
    {
      "subnet": "192.168.0.0/24",
      "splitPrefix": 25
    }
  '''

  push = JSON.parse(request.body.read)

  if push['subnet'] && push['splitPrefix']
    response = calc_case('splitprefix', push['subnet'], push['splitPrefix'])
  else
    status 400
    response = { error: 'invalid request' }.to_json
  end

  body(response)
end

get '/ipcalc/subnet=:subnet&prefix=:prefix' do
  subnet = "#{params['subnet']}/#{params['prefix']}"
  calc_case('details', subnet)
end

get '/ipcalc/splitcount/network=:network&prefix=:prefix&splitcount=:splitcount' do
  subnet = "#{params['network']}/#{params['prefix']}"

  calc_case('splitcount', subnet, params['splitcount'].to_i)
end

get '/ipcalc/splitprefix/network=:network&prefix=:prefix&splitprefix=:splitprefix' do
  subnet = "#{params['network']}/#{params['prefix']}"

  calc_case('splitprefix', subnet, params['splitprefix'].to_i)
end
