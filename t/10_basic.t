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
isa_ok $uc, 'Upas::Client';

my $room = $uc->realm( 'room', 600 );
isa_ok $room, 'Upas::Client::Realm';

$room->set( test => { point => 100 } );
my $rec = $room->lookup( 'test' );

isa_ok $rec, 'Upas::Client::Record';
$rec->delete;

done_testing();
