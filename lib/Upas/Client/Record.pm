package Upas::Client::Record;

use warnings;
use strict;
use parent qw/ Hash::AsObject /;
use Upas::Client::Realm;
use Acme::Damn;

sub as_hash { %{ damn shift } }

sub realm { shift->{ _REALM } }

sub set {
    my $self = shift;
    $self->realm->overwrite( $self->as_hash );
}

sub delete {
    my $self = shift;
    $self->realm->delete( $self->key );
}

sub copy {
    my ( $self, $realm_name ) = @_;
    my $realm = Upas::Client::Realm->new( 
        name => $realm_name, 
        expire => $self->realm->{ expire }, 
        client => $self->realm->{ client }, 
    );
    $realm->set( $self->key => { $self->as_hash } );
    $realm->lookup( $self->key );
}

sub move {
    my ( $self, $realm_name ) = @_;
    my $moved = $self->copy( $realm_name );
    if ( defined $moved ) {
        $self->delete;
        return $moved;
    }
}

1;

=head1 NAME

Upas::Client::Record - Record class

=head1 DESCRIPTION

PLEASE DO NOT USE THIS MODULE DIRECTLY.

=head1 AUTHOR

satoshi azuma E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

