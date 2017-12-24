use strict;
use Test::More 0.98;
use Test::Fatal 0.014;

use WebService::YDMM;

subtest 'new - instance' , sub {

    subtest 'success' => sub {
        is exception { WebService::YDMM->new(
            affiliate_id => ${affiliate_id},
            api_id       => ${api_id},
        )}, undef, q{ sucess } ;
    };

#        like exception { }
};

done_testing;

