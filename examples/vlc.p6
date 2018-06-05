use lib <lib>;
use WWW::vlc::Remote;

my $vlc := WWW::vlc::Remote.new: :pass<pass>, :8080port;

say "Available songs are: ";
.say for $vlc.playlist;
