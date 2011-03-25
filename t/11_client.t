use strict;
use Test::More;
use Test::TCP;
use Upas::Client;
use Upas;

my $server = Test::TCP->new( code => sub {
    my $port = shift;
    my $upas = Upas->new( open => [ [ '127.0.0.1', $port ] ] );
    $upas->run;
} );

my $uc = Upas::Client->new( servers => [ [ '127.0.0.1:'.$server->port ]] );

isa_ok $uc->{ client }, 'Cache::Memcached::Fast';
can_ok $uc, qw/ realm /;

done_testing();
