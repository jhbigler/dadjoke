# dadjoke
A Ruby script to grab a dad joke from an API and email it. I use it to email a dad joke to my work email once a week.

## Usage
```console
$ ./dadjoke.rb --help
Usage: dadjoke.rb [options]
    -t, --to TO_ADDRESSES            Comma-seperated list of email addresses to send to
    -f, --from FROM_ADDRESS          'From' address. Default: noreply@localhost
    -s, --subject SUBJECT            Email subject. Default: Dad Joke from localhost
    -d, --dry-run                    Print joke to screen without emailing
```
