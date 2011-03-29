use strict;
use Test::More;
use Test::TCP;
use Test::Deep;
use Upas::Client;
use Upas;

my $server = Test::TCP->new( code => sub {
    my $port = shift;
    my $upas = Upas->new( open => [ [ '127.0.0.1', $port ] ] );
    $upas->run;
} );

my $uc = Upas::Client->new( servers => [ [ '127.0.0.1:'.$server->port ]] );
my $realm = $uc->realm( 'test', 600 );

$realm->set( ytnobody => { age => 30, sex => 'male' } );
my $record = $realm->get( 'ytnobody' );
isa_ok $record, 'Upas::Client::Record';

my $copied = $record->copy( 'mirror' );
isa_ok $copied, 'Upas::Client::Record';
is $copied->$_, $record->$_ for qw/ key age sex /;
cmp_deeply( $realm->get( 'ytnobody' ), $record );

my $moved = $record->move( 'home' );
isa_ok $moved, 'Upas::Client::Record';
is $moved->$_, $record->$_ for qw/ key age sex /;
is $realm->get( 'ytnobody' ), undef;


done_testing();
