package Upas::Client;
use strict;
use warnings;
our $VERSION = '0.01';

use Cache::Memcached::Fast;
use Upas::Client::Realm;

sub new {
    my ( $class, %opts ) = @_;
    my $client = Cache::Memcached::Fast->new( \%opts );
    bless { client => $client }, $class;
}

sub realm {
    my ( $self, $realm_name, $expire ) = @_;
    Upas::Client::Realm->new( 
        name => $realm_name, 
        expire => $expire, 
        client => $self->{ client } 
    );
}

1;
__END__

=head1 NAME

Upas::Client - ORM-like client for Upas

=head1 SYNOPSIS

  use Upas::Client;
 
  ### Create Upas::Client object.
  my $u = Upas::Client->new(
      servers => [qw[ 127.0.0.1:4616 ]],
      namespace => 'myproj',
  );
 
  ### expire is 600 seconds
  my $expire = 600;
 
  ### Now, $myroom is Upas::Client::Realm object.
  my $myroom = $u->realm( 'myroom', $expire );
 
  ### Set data into Upas
  $myroom->set( 
    'ytnobody' => { age => 40, sex => 'male' }, 
    'Wife' => { age => 30, sex => 'female' },
    'Elderest son' => { age => 9, sex => 'male' },
    'Second son' => { age => 5, sex => 'male' },
  );
  $myroom->set( 'baby' => { age => 0, sex => 'unknown' } );
 
  ### It will make warning and not overwriten
  $myroom->set( 'ytnobody' => { age => 18, sex => 'female' } );
 
  ### Overwrite
  $myroom->overwrite( 'ytnobody' => { age => 30, sex => 'male' } );
 
  ### Get a data by key
  my $ytnobody = $myroom->lookup( 'ytnobody' ); # $ytnbody is Upas::Client::Record object
  print $ytnobody->key." is ".$ytnobody->age." years old.\n";
 
  ### Make changes
  $ytnobody->age( 25 );
  $ytnobody->set;
  print $ytnobody->key." is ".$ytnobody->age." years old. Really???\n";
 
  ### Check expired
  if ( $ytnobody->is_expired ) {
      $ytnobody->set; # ytnobody comes back.
  }
 
  ### Move to another realm
  $ytnobody->move( 'barber' );
 
  ### Copy to another realm
  my $mirrored_ytnobody = $ytnobody->copy( 'mirror' );
 
  ### Delete realm
  $u->realm( 'mirror' )->delete;
 
  ### Delete a data
  $ytnobody->delete;
 
  ### Search and get datas into array
  my @sons = $myroom->search( sex => 'male' );

=head1 DESCRIPTION

Upas::Client is ORM-like client for Upas.

=head1 AUTHOR

satoshi azuma E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
