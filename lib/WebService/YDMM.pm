package WebService::YDMM;
use 5.008001;
use strict;
use warnings;
use utf8;

use Carp qw/croak/;
use URI;
use HTTP::Tiny;
use JSON;

our $VERSION = "0.01";


sub new {
    my ($class, %args) = @_;

    croak("affiliate_id is required") unless $args{affiliate_id};
    croak("api_id is required") unless $args{api_id};

    _validate_affiliate_id($args{affiliate_id});

    my $self = {
        affiliate_id => $args{affiliate_id},
        api_id       => $args{api_id},
        _agent       => HTTP::Tiny->new( agent => "WebService::YDMM agent $VERSION" ),
        _base_url    => 'https://api.dmm.com/',
    };

    return bless $self, $class;
}


sub _validate_affiliate_id {
    my $account = shift;

    unless ($account =~ m{99[0-9]$}) {
        croak("Postfix of affiliate_id is '990--999'");
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
    my ($self, $target, $query_param) = @_;

    map { $query_param->{$_} = $self->{$_} } qw/affiliate_id api_id/;
    $query_param->{output} = "json";

    my $uri = URI->new($self->{_base_url});
    $uri->path("affiliate/v3/" . $target);
    $uri->query_form($query_param);

    my $res = $self->{_agent}->get($uri->as_string);
    croak("$target API acess failed...") unless $res->{success};

    return decode_json($res->{content});
}

sub item {
    my $self = shift;

    if (scalar @_ == 2){

        my $site        = _validate_site_name(shift);
        my $query_param = shift;

        return $self->_send_get_request("ItemList", +{ site => $site, %$query_param})->{result};

    } else {

        my $query_param = shift;

        if (exists $query_param->{site}){
            _validate_site_name($query_param->{site});
        } else {
            croak('Require to Sitename for "DMM.com" or "DMM.R18"');
        }

        return $self->_send_get_request("ItemList", +{ %$query_param })->{result};
    }
}

sub author {
    my $self  = shift;

    my $query_param;

    if (scalar @_ == 2){

        (my $floor_id,$query_param) = @_;

        if (! (defined $floor_id)) {
            croak('Require to floor_id');
        }
        $query_param->{floor_id} = $floor_id;

    } else {

       $query_param = shift;
       if  (! (exists $query_param->{floor_id}) ){
          croak('Require to floor_id');
       }

    }

    return $self->_send_get_request("AuthorSearch", +{ %$query_param })->{result};

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

    # or 

    my $items = $dmm->item(+{ site => "DMM.R18" , keyword => "魔法少女まどか☆マギカ"});

=head1 DESCRIPTION

WebService::YDMM is another DMM webservice module.
L<DMM|http://www.dmm.com> is Japanese shopping site.

This module supported by L<DMM.API|https://affiliate.dmm.com/api/>.

=head1 METHODS

=head2 new(%params)
 
Create instance of WebService::Reactio.
 
I<%params> must have following parameter:
 
=over 4

=item api_id
 
API ID of DMM.com web service
You can get API key on project application for DMM affiliate service.
 
=item affiliate_id
 
Affiliate ID of DMM.com web service
You can get API key on project application for DMM affiliate service.
This affiliate_id validate of 990 ~ 999 number.

=back

=head2 item([$site],\%params)

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

