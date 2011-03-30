use strict;
use Test::More;
use Test::TCP;
use Test::Warn;
use Upas::Client;
use Upas;
use Data::Dumper;

my $server = Test::TCP->new( code => sub {
    my $port = shift;
    my $upas = Upas->new( open => [ [ '127.0.0.1', $port ] ] );
    $upas->run;
} );

my $uc = Upas::Client->new( servers => [ [ '127.0.0.1:'.$server->port ]] );
my $realm = $uc->realm( 'test', 600 );

isa_ok $realm->{ client }, 'Cache::Memcached::Fast';
is $realm->{ name }, 'test';
is $realm->{ expire }, 600;
can_ok $realm, qw/ set overwrite lookup search delete /;

warning_is { 
    $realm->set( 
        data1 => { name => 'testdata1', point => 400, tag => 'hige' },
        data2 => { name => 'testdata2', point => 500, tag => 'hoga' },
        data3 => { name => 'testdata3', point => 900, tag => 'puyo' },
        data4 => { name => 'testdata4', point => 700, tag => 'hoga' },
    );
} undef, 'Error when set some data';

my @recs;
push @recs, $realm->lookup( 'data1' );
push @recs, $realm->search( point => 900 );
push @recs, $realm->search( tag => 'hoga' );

my @expects = (
    { key => 'data1',
      name => 'testdata1',
      point => 400,
      tag => 'hige' },
    { key => 'data3',
      name => 'testdata3',
      point => 900,
      tag => 'puyo' },
    { key => 'data2',
      name => 'testdata2',
      point => 500,
      tag => 'hoga' },
    { key => 'data4',
      name => 'testdata4',
      point => 700,
      tag => 'hoga' },
);

is $#recs, $#expects;

for my $i ( 0 .. $#recs ) {
    my $rec = $recs[$i];
    my $exp = $expects[$i];

    isa_ok $rec, 'Upas::Client::Record';
    for my $key ( keys %{ $exp } ) {
        is $rec->$key, $exp->{ $key }, "$key = ".$exp->{ $key };
    }
    isa_ok $rec->realm, 'Upas::Client::Realm';
    is $rec->realm->{ name }, 'test';
    is $rec->realm->{ expire }, 600;
}

done_testing();
