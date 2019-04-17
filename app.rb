require 'sinatra'
require 'excon'

class App < Sinatra::Base
    AUGUST_API_KEY = "79fd0eb6-381d-4adf-95a0-47721289d1d9"
    LOCK_URL = "https://api-production.august.com/remoteoperate/#{ENV['LOCK_ID']}/lock"

    def unlock
        headers = {
            "x-august-api-key" => AUGUST_API_KEY,
            "x-kease-api-key" => AUGUST_API_KEY,
            "x-august-access-token" => ENV['AUGUST_ACCESS_TOKEN'],
            "User-Agent" => "August/Luna-3.2.2",
            "Accept-Version" => "0.0.1",
            "Content-Type" => "application/json",
        }
        $stderr.puts("unlock request: #{LOCK_URL} #{headers.inspect}")
        resp = Excon.put(LOCK_URL, headers: headers)

        $stderr.puts("unlock response: #{resp.status} #{resp.body}")

        resp.status == 200
    end

    get "/" do
        "Hello world! #{Time.now}"
    end

    get "/unlock" do
        "did: #{unlock}"
    end
end
