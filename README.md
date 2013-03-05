# `stingray-exec`

Stingray Traffic Manager Control API Client

## Installation

Install it via `gem`:

    $ gem install stingray-exec

## Usage

TODO: yup

## Hacking

Some (all?) of this may be obvious for those familiar with Ruby modern
projects.  It'll be okay.

Clone down a capy
````` bash
git clone git://github.com/modcloth/stingray-exec.git
pushd stingray-exec
`````

Make sure you have `bundler`
````` bash
gem install bundler
`````

Pull in dependencies with `bundler`
````` bash
bundle install
`````

Verify basic operation with the `stingray-exec` script
````` bash
bundle exec bin/stingray-exec --help
`````

As you'll see in the usage text, all of the command-line flags may also
be passed as environmental variables.  The idea here is that it's
sometimes easier to define an environmental variable soup instead of
having to pass lots of flags for every invocation.

## Examples

There are some example `stingray-exec` scripts present in the
`./examples` directory.  The `stingray-exec` script accepts a filename
as positional argument, so using it in the shebang line works great.

**WARNING**: some of the examples are destructive, so don't go pointing
them at production systems or any such nonsense.

### Running the tests

The test suite uses RSpec.  By default, all specs tagged with
`:integration => true` are excluded.  This results in very little being
tested.  In order to exercise the really interesting tests, you'll have
to define a `STINGRAY_ENDOINT` environmental variable.  Some examples of
how to do this are available in the `.local.integration.env` and
`.vagrant.integration.env` files in the root of the project tree.

````` bash
bundle exec rspec
`````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
