use strict;
use Test2::V0;

use WebService::YDMM;
use Path::Tiny qw/file/;

my $dmm = WebService::YDMM->new(affiliate_id => "Test_id-990", api_id => "Test-affiliate");

my @sites = qw/ DMM.com DMM.R18/;

subtest 'item' => sub {

    subtest 'sucess' => sub {

        my $mock = mock 'HTTP::Tiny'  => (
            override => [
                get => sub {  return { _sucess => "true", _content => { name => 'test'}} },
            ],
        );

        for $site (@sites){
            ok ($dmm->item({ site => $site , name => "test"}), q{get_item_in});
        }

        for $site (@sites){
            ok ($dmm->item( $site , { site => $site , name => "test"}), q{get_item_in});
        } 

    };

};

done_testing;