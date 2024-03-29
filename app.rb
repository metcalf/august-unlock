require 'sinatra'
require 'excon'

class App < Sinatra::Base
    AUGUST_API_KEY = "79fd0eb6-381d-4adf-95a0-47721289d1d9"
    LOCK_URL = "https://api-production.august.com/remoteoperate/#{ENV['LOCK_ID']}/unlock"

    def unlock
        headers = {
            "x-august-api-key" => AUGUST_API_KEY,
            "x-kease-api-key" => AUGUST_API_KEY,
            "x-august-access-token" => ENV['AUGUST_ACCESS_TOKEN'],
            "User-Agent" => "August/Luna-3.2.2",
            "Accept-Version" => "0.0.1",
            "Content-Type" => "application/json",
        }
        resp = Excon.put(LOCK_URL, headers: headers)

        $stderr.puts("unlock response: #{resp.status} #{resp.body}")

        resp.status == 200
    end

    get "/" do
        "Nothing to see here"
    end

    get "/calisone" do
        if Time.now < Time.new(2019, 4, 20, 17) # 10AM in UTC
            "It's too soon! Reload this page during the party or call us if you're having trouble."
        elsif Time.now > Time.new(2019, 4, 21, 0) # 5PM in UTC
            "Too late! Call us if you think this is a mistake."
        elsif unlock
            "It should be unlocked now. Close the door firmly behind you and it'll lock itself in a few minutes."
        else
            "Sorry, there was a problem unlocking the door. You can reload the page to try again or give us a call."
        end
    end
end
