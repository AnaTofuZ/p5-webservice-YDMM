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

    my $agent = $args{agent} || "WebService::YDMM agent $VERSION";

    _validate_affiliate_id($args{affiliate_id});

    my $self = {
        affiliate_id => $args{affiliate_id},
        api_id       => $args{api_id},
        agent        => $args{agent} || HTTP::Tiny->new( agent => "WebService::YDMM agent $VERSION" ),
        _base_url    => 'https://api.dmm.com/',
    };

    return bless $self, $class;
}


sub _validate_affiliate_id {
    my $account = shift;

    unless ($account =~ m{9[0-9]{2}$}) {
        croak("Postfix of affiliate_id is '900--999'");
    }

    return;
}

sub _validate_site_name {
    my $site = shift;
    
    unless ($site eq 'DMM.com' || $site eq 'DMM.R18'){
        croak('Request to Site name for "DMM.com" or "DMM.R18"');
    }
    return $site;
}

sub _send_get_request {
    my ($self,$target,$query_param) = @_;

    map { $query_param->{$_} = $self->{$_} } qw/affiliate_id api_id/;
    $query_param->{output} = "json";

    my $uri = URI->new($self->{_base_url});
    $uri->path("affiliate/v3/" . $target);
    $uri->query_form($query_param);

    my $res = $self->{agent}->request('GET', $uri->as_string);
    croak ("$target API acess failed...") unless $res->{success};

    return decode_json($res->{content});
}

sub item {
    my $self = shift;

    if ( scalar @_ == 2){

        my $site = _validate_site_name(shift);
        my $query_param =  shift;

        return $self->_send_get_request("ItemList", +{ site => $site, %$query_param});

    } else {

        my $query_param = shift;

        unless (exits $query_param->{site} || $self->_validate_site_name($query_param->{site})){
            croak('Require to Sitename for "DMM.com" or "DMM.R18"');
        }

        return $self->_send_get_request("ItemList", $query_param);
    }

}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::YDMM - It's yet another DMM sdk.

=head1 SYNOPSIS

    use WebService::YDMM;

    my $dmm = WebService::YDMM->new(
        affiliate_id => ${affiliate_id},
        api_id       => ${api_id},
    );

    my $items = $dmm->item("DMM.com",+{ keyword => "魔法少女まどか☆マギカ"});

=head1 DESCRIPTION

WebService::YDMM is another DMM webservice module.
L<DMM|http://www.dmm.com> is Japanese shopping site.



=head1 LICENSE

Copyright (C) AnaTofuZ.

DMM API Copyright 
Powered by L<DMM.com Webサービス|https://affiliate.dmm.com/api/>
Powered by L<DMM.R18 Webサービス|https://affiliate.dmm.com/api/>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=head1 AUTHOR

AnaTofuZ E<lt>anatofuz@gmail.comE<gt>

=cut

