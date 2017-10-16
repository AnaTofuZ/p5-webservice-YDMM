package WebService::YDMM;
use 5.008001;
use strict;
use warnings;
use utf8;

use Carp qw/croak/;
use URI;
use HTTP::Tiny;
use Encode;
use JSON;

our $VERSION = "0.01";


sub new {
    my ($class, %args) = @_;

    for my $param (qw/affiliate_id api_id/){
        unless (exists $args{$param}){
            Carp::croak("missing mandatory parameter '$param'");
        }
    }

    _validate_affiliate_id($args{affiliate_id});

    my $self = {
        affiliate_id => $args{affiliate_id},
        api_id       => $args{api_id},
        _base_url    => 'https://api.dmm.com/affiliate/v3',
        agent        => $args{agent} || HTTP::Tiny->new( agent => "WebService::YDMM agent $VERSION" ),
    };

    return bless $self, $class;
}

sub _validat_list {
    my ($self, $param) = @_;

    return ;
}

sub _validate_affiliate_id {
    my $account = shift;

    unless ($account =~ m{9[0-9]{2}$}) {
        Carp::croak("Postfix of affiliate_id is '900--999'");
    }

    return 1;
}


sub author {
    my ($self,$args) = @_;

    map { $self->_validat_list($_) } keys %$args;

}



1;
__END__

=encoding utf-8

=head1 NAME

WebService::YDMM - It's yet another DMM sdk.

=head1 SYNOPSIS

    use WebService::YDMM;

=head1 DESCRIPTION

WebService::YDMM is another DMM webservice module.
DMML<http://www.dmm.com> is Japanese shopping site.




=head1 LICENSE

Copyright (C) AnaTofuZ.

Origin WebService::DMM (C) syohex

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

AnaTofuZ E<lt>anatofuz@gmail.comE<gt>

=cut

