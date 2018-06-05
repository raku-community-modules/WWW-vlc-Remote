[![Build Status](https://travis-ci.org/zoffixznet/perl6-WWW-vlc-Remote.svg)](https://travis-ci.org/zoffixznet/perl6-WWW-vlc-Remote)

# NAME

WWW::vlc::Remote — Control vlc media player via its Web interface

# SYNOPSIS

```perl6
use lib <lib>;
use WWW::vlc::Remote;

my $vlc := WWW::vlc::Remote.new;
say "Available songs are:";
.say for $vlc.playlist: :skip-meta;

my UInt:D $song := val prompt "\nEnter an ID of song to play: ";
with $vlc.playlist.first: *.id == $song {
    say "Playing $_";
    .play
}
else {
    say "Did not find any songs with ID `$song`";
}
```

# DESCRIPTION

Provides programmatic interface to
[VLC Media player](https://www.videolan.org/vlc/index.html) using its
Web remote.

# ENABLE THE REMOTE

Open up your VLC player, go to `Tools` → `Preferences` → `"Show settings" (all)` (bottom left) → `Interface` → `Main Interfaces` and ensure `"Web"` is checked.

You can now use `--http-password` command line option to `vlc` to enable
its Web remote. The password is required. It might be possible to set it in
the preferences somewhere (`Main Interfaces` → `Lua` → `"Lua HTTP"` →
`Password` maybe), but I was not able to successfully find where.

Along with `--http-password` you can set `--http-port` to adjust which port
`vlc` will listen on (defaults to `8080`). See `vlc --help --advanced` for more
options.

# METHODS


----

#### REPOSITORY

Fork this module on GitHub:
https://github.com/zoffixznet/perl6-WWW-vlc-Remote

#### BUGS

To report bugs or request features, please use
https://github.com/zoffixznet/perl6-WWW-vlc-Remote/issues

#### AUTHOR

Zoffix Znet (https://perl6.party/)

#### LICENSE

You can use and distribute this module under the terms of the
The Artistic License 2.0. See the `LICENSE` file included in this
distribution for complete details.
