unit class WWW::vlc::Remote;
use HTTP::UserAgent;
use DOM::Tiny;

has HTTP::UserAgent:D $!ua  is required;
has Str:D             $!url is required;

class X is Exception {
    has Str:D $.error is required;
    method message { "vlc Remote error: $!error" }
}
class X::Network is Exception {
    has HTTP::Response:D $.res is required;
    method message { "Network error: {$!res.code} - {$!res.status-line}" }
}
class Track {
    has Str:D  $.uri      is required;
    has Str:D  $.name     is required;
    has UInt:D $.id       is required;
    has  Int:D $.duration is required;
    method Str  {
        my $id = "#$!id";
        $id [R~]= ' ' x 5 - $id.chars;
        my $m = $!duration div 60;
        my $s = $!duration - $m*60;
        "$id $!name ({$m}m{$s}s)"
    }
    method gist { self.Str }
}

submethod BUILD (
    Str    :$pass = 'pass',
    Str:D  :$host = 'http://127.0.0.1',
    UInt:D :$port = 8080,
) {
    $!url := $host.subst(rx{'/'+$}, '') ~ ':' ~ $port;
    $!ua  := HTTP::UserAgent.new;
    $!ua.auth: '', $pass;
}

method !path(Str:D $path) { $!url ~ $path }

method playlist {
    my $res := $!ua.get: self!path: '/requests/playlist.xml';
    $res.is-success or fail X::Network.new: :$res;
    my $dom := DOM::Tiny.parse($res.content).at: 'node[name="Playlist"]'
        or fail X.new: error => 'Could not find playlist node';

    $dom.find('leaf').grep(*.<duration> > 0).map: {
        Track.new:
            :uri(.<uri>), :id(+.<id>), :name(.<name>), :duration(+.<duration>)
    }
}
