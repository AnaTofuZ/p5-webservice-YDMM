use strict;
use Test2::V0;
use FindBin;

use WebService::YDMM;

my $dmm = WebService::YDMM->new(affiliate_id => "Test_id-990", api_id => "Test-affiliate");

my @sites = qw/ DMM.com DMM.R18/;

subtest 'item' => sub {

    subtest 'success' => sub {

        my $mock = mock 'HTTP::Tiny'  => (
            override => [
                get => sub { 
                            open my $fh, '<', "$FindBin::Bin/data/test.json" or die "failed to open file: $!";
                            my $content = do { local $/; <$fh> };
                            return {success => 'true', content => "$content"};
                        }
            ],
        );


        subtest 'in_site_name' => sub {
            for my $site (@sites) {
                ok(my $receive = $dmm->item(+{ site => $site , name => "test"}));
                is ($receive->[0]->{floor_name},"コミック");
                is ($receive->[0]->{iteminfo}->{author}->[1]->{name},"ハノカゲ");
            }
        };

        subtest 'out_site_name' => sub {
            for my $site (@sites) {
                ok (my $receive = $dmm->item( $site , { site => $site , name => "test"}), q{get_item_out});
                is ($receive->[0]->{floor_name},"コミック");
                is ($receive->[0]->{iteminfo}->{author}->[1]->{name},"ハノカゲ");
            } 
        };

    };

    subtest 'error' => sub {

    };

};

done_testing;