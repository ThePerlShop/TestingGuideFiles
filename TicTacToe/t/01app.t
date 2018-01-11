#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { $ENV{CATALYST_DEBUG} = 0 } # Turn off Catalyst debug output.

use Catalyst::Test 'TicTacToe';

ok( request('/')->is_success, 'Request should succeed' );

done_testing();
