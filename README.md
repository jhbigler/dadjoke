# dadjoke
An incredibly stupid Ruby script to grab a dad joke from an API and email it

## Usage
```console
$ ./dadjoke.rb --help
Usage: dadjoke.rb [options]
    -t, --to TO_ADDRESSES            Comma-seperated list of email addresses to send to
    -f, --from FROM_ADDRESS          'From' address. Default: noreply@joshuabcentos8.pnl.gov
    -s, --subject SUBJECT            Email subject. Default: Dad Joke from joshuabcentos8.pnl.gov
    -d, --dry-run                    Print joke to screen without emailing
```
