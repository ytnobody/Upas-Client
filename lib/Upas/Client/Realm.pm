package Upas::Client::Realm;
use warnings;
use strict;
use Upas::Client::Record;
use Storable qw/ freeze thaw /;

sub new {
    my ( $class, %opts ) = @_;
    bless \%opts, $class;
}

sub set {
    my ( $self, @opts ) = @_;
    my $overwrite = @opts % 2 ? 0 : 1;
    pop @opts if $overwrite;
    my %records = ( @opts ); 
    my $client = $self->{ client };
    my $key = my $data = undef;
    for $key ( keys %records ) {
        $data = $records{ $key };
        $data->{ key } = $key;
        if () {
        }
        elsif ( ! defined $client->get( $self->{ name }.':key:'.$key ) {
            $client->set( $self->{ name }, freeze $data, $self->{ expire } );
        }
        else {
            warn "Duplicate key \"$key\"";
        }
    }
}

sub overwrite {
    my ( $self, %records ) = @_;
    $self->set( %records, 1 );
}

sub lookup {
    my ( $self, @keys ) = @_;
    my $client = $self->{ client };
    my @res;
    my $reclist;
    for my $key ( @keys ) {
        $reclist = $client->get( $self->{ name }.':key:'.$key );
        next unless defined $reclist;
        $reclist = thaw $reclist;
        push @res, Upas::Client::Record->new( %{ $reclist->[0] }, _REALM => $realm );
    }
    return @res;
}

sub search {
    my ( $self, @cond ) = @_;
    my $client = $self->{ client };
    my @res;
    my $reclist;
    unless ( @cond ) {
        $reclist = $client->get( $self->{ name } );
        next unless defined $reclist;
        $reclist = thaw $reclist;
        push @res, map { Upas::Client::Record->new( realm => $self, data => $_ ) } @$reclist;
    }
    else {
        my $search_opts = join ':', @cond;
        $reclist = $client->get( $self->{ name }.':'.$search_opts );
        next unless defined $reclist;
        $reclist = thaw $reclist;
        push @res, map { Upas::Client::Record->new( realm => $self, data => $_ ) } @$reclist;
    }
    return @res;
}

sub delete {
    my $self = shift;
    $self->{ client }->delete( $self->{ name } );
}

1;

=head1 NAME

Upas::Client::Realm - Realm class

=head1 DESCRIPTION

PLEASE DO NOT USE THIS MODULE DIRECTLY.

=head1 AUTHOR

satoshi azuma E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

