use strict;
use Test::More;
use Test::TCP;
use Upas::Client;
use Upas;
use Data::Dumper;

my $server = Test::TCP->new( code => sub {
    my $port = shift;
    my $upas = Upas->new( open => [ [ '127.0.0.1', $port ] ] );
    $upas->run;
} );

my $uc = Upas::Client->new( servers => [ [ '127.0.0.1:'.$server->port ]] );
my $realm = $uc->realm( 'test', 3 );

$realm->set( hoge => { value => 'hoo' } );
isa_ok $realm->get( 'hoge' ), 'Upas::Client::Record';
sleep 3;

is $realm->get( 'hoge' ), undef;

done_testing();
