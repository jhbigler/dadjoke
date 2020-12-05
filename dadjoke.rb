#!/usr/bin/env ruby

require 'httparty'
require 'pony'
require 'optparse'
require 'socket'

#Default options
options = {
    "dry_run" => false,
    "from" => "noreply@#{Socket.gethostname}",
    "subject" => "Dad Joke from #{Socket.gethostname}"
}

def from_dadsoffunny() 
    url = 'https://us-central1-dadsofunny.cloudfunctions.net/DadJokes/random/type/general'
    res = HTTParty.get(url).parsed_response[0]
    ret = {
        "joke" => "#{res["setup"]} #{res["punchline"]}",
        "source" => "https://us-central1-dadsofunny.cloudfunctions.net/DadJokes/jokes/#{res["id"]}"
    }
    ret
end

def from_icanhazdadjoke()
    url = 'https://icanhazdadjoke.com'
    headers = {"Accept"=>"application/json"}
    res = HTTParty.get(url, :headers => headers).parsed_response
    ret = {
        "joke" => res["joke"],
        "source" => "#{url}/j/#{res["id"]}"
    }
    ret
end

dad_joke_sources = [
    lambda {return from_dadsoffunny()}, 
    lambda {return from_icanhazdadjoke()}
]

#Parse the CLI arguments
OptionParser.new do |opt|
    opt.banner = "Usage: #{File.basename __FILE__} [options]"

    opt.on("-t", "--to TO_ADDRESSES", Array, "Comma-seperated list of email addresses to send to"){|o| options["to"] = o}
    opt.on("-f", "--from FROM_ADDRESS", "'From' address. Default: #{options["from"]}"){|o| options["from"] = o}
    opt.on("-s", "--subject SUBJECT","Email subject. Default: #{options["subject"]}"){|o| options["subject"] = o}
    opt.on("-d", "--dry-run", "Print joke to screen without emailing"){|o| options["dry_run"] = true}

end.parse!

#If it's not a dry run and email addresses weren't provided, no sense in continuing
if(!options.has_key?("to") && !options["dry_run"])
    $stderr.puts("Must provide 'to' address(es)!")
    exit(1)
end

#Grab a dad joke
joke = dad_joke_sources.sample.call

#If it's a dry run, print to the screen and exit
if options["dry_run"]
    puts joke["joke"]
    puts "Source: #{joke["source"]}"
    exit
end

#...otherwise, create the html
body = <<EOF
<p>#{joke["joke"]}</p>

<p>Source: #{joke["source"]}</p>
EOF

#...and then email
Pony.mail(
    :to => options["to"],
    :from => options["from"],
    :subject => options["subject"],
    :html_body => body
)