# (Pro)specter

Specter stubs a subset of cgminer's
[client protocol](https://github.com/ckolivas/cgminer/blob/master/API-README).
Use it to develop software that interacts with the API *without* being forced to
always run against a real, running instance.

## Installation

Install it with:

    $ gem install specter

Then start it with:

    $ specter

## Usage

```
Usage: specter [options]
    -H, --host HOST                  Bind to a specific address
    -p, --port PORT                  Listen on a specific TCP port
    -P, --proxy [HOST[:PORT]]        Send unrecognized commands to an actual running miner
                                     Host defaults to `localhost', port defaults to `4028'
    -v, --version                    Show version information and exit
    -h, --help                       Show this help message and exit
```


## Contributing

1. Fork it (http://github.com/gevans/specter/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
