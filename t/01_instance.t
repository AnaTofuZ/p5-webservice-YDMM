use strict;
use Test2::V0;

use WebService::YDMM;

subtest 'new -- make_instance' =>  sub {

    subtest 'success' => sub {
        ok(WebService::YDMM->new(affiliate_id => "Test_id-990", api_id => "Test-affiliate"), q{ sucess });
    };

    subtest 'error'   => sub {
        subtest 'not_input' => sub {
            like( dies {WebService::YDMM->new()}, qr{affiliate_id is required}, 'all requires params nothing input');
            like( dies {WebService::YDMM->new( api_id => "api_id")}, qr{affiliate_id is required}, 'affiliate_id not input');
            like( dies {WebService::YDMM->new( affiliate_id=> "Test_id-990")}, qr{api_id is required}, 'api_id not input');
        };

        subtest 'invalid'  => sub {
            like( dies {WebService::YDMM->new(affiliate_id => "Test_id-99", api_id => "Test-affiliate")}, qr{Postfix of affiliate_id is '990--999'},q{ not_three_digit });
            like( dies {WebService::YDMM->new(affiliate_id => "Test_id-989", api_id => "Test-affiliate")},qr{Postfix of affiliate_id is '990--999'},q{ not_990's});
            like( dies {WebService::YDMM->new(affiliate_id => "Test_id-1000", api_id => "Test-affiliate")},qr{Postfix of affiliate_id is '990--999'},q{ over 999});
            like( dies {WebService::YDMM->new(affiliate_id => "Test_id-990.5", api_id => "Test-affiliate")},qr{Postfix of affiliate_id is '990--999'},q{ froat number});
        };
    };

};

done_testing;
