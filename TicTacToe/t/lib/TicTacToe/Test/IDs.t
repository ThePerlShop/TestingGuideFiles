#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::lib::TicTacToe::Test::IDs->runtests;


BEGIN {
package t::lib::TicTacToe::Test::IDs;
use 5.026;
use strict;
use warnings;

use parent 'Test::Class';

use Test::Most;
use Carp::Always;
use Data::Dumper;


# load code to be tested
use TicTacToe::Test::IDs;


=head1 NAME

t::lib::TicTacToe::Test::IDs - Unit-test the operation of the L<TicTacToe::Test::IDs> class.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/Test/IDs.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/Test/IDs.t

=cut


=head1 TESTS

=head2 test_single_id

Fetch a single ID using the default C<next()>, and verify that it
returns a scalar which is a positive integer. Also verify that
C<all_ids> contains that ID.

=cut

sub test_single_id : Test(2) {
    my $test = shift;

    my $id_generator = TicTacToe::Test::IDs->new();

    my @ids = $id_generator->next;
    my $all_ids = $id_generator->all_ids;

    cmp_deeply( \@ids, [ re(qr/[1-9][0-9]*/) ], 'single, valid ID' );
    cmp_deeply( $all_ids, \@ids, 'all_ids lists ids' );
}


=head2 test_scalar_return

Fetch an ID assigning to a scalar, and verify that it returns a scalar
(not an array), which appears as the contents of C<all_ids>.

=cut

sub test_scalar_return : Test(2) {
    my $test = shift;

    my $id_generator = TicTacToe::Test::IDs->new();

    my $id = $id_generator->next;
    my $all_ids = $id_generator->all_ids;

    like( $id, qr/[1-9][0-9]*/, 'valid ID' );
    cmp_deeply( $all_ids, [$id], 'all_ids lists id' );
}


=head2 test_multiple_ids

Fetch a large number of IDs as an array using C<next($count)>, and
verify that it returns the correct number of valid IDs and that none
are repeated. Also verify that C<all_ids> contains the same IDs.

=cut

sub test_multiple_ids : Test(4) {
    my $test = shift;

    my $count = 10_000;

    my $id_generator = TicTacToe::Test::IDs->new();

    my @ids = $id_generator->next($count);
    my $all_ids = $id_generator->all_ids;

    is( scalar(@ids), $count, 'correct count' );

    cmp_deeply(
        \@ids,
        array_each( re(qr/[1-9][0-9]*/) ),
        'all valid IDs',
    );

    my @duplicates = do {
        my %id_count;
        grep ++$id_count{$_} == 2, @ids;
    };
    ok( !@duplicates, 'no duplicates' )
      or note( Data::Dumper->Dump( [\@duplicates], ['*duplicates'] ) );

    cmp_deeply( $all_ids, \@ids, 'all_ids lists ids' );
}



=head2 test_next_undef

Call C<next(undef)>, and verify that it returns an empty array.

=cut

sub test_next_undef : Test(2) {
    my $test = shift;

    my $id_generator = TicTacToe::Test::IDs->new();

    my @ids = $id_generator->next(undef);
    my $all_ids = $id_generator->all_ids;

    cmp_deeply( \@ids, [], 'no IDs' );
    cmp_deeply( $all_ids, \@ids, 'all_ids lists ids' );
}


=head2 test_next_0

Call C<next(0)>, and verify that it returns an empty array.

=cut

sub test_next_0 : Test(2) {
    my $test = shift;

    my $id_generator = TicTacToe::Test::IDs->new();

    my @ids = $id_generator->next(0);
    my $all_ids = $id_generator->all_ids;

    cmp_deeply( \@ids, [], 'no IDs' );
    cmp_deeply( $all_ids, [], 'all_ids empty' );
}


=head2 test_next_1

Call C<next(1)>, and verify that it returns an array with a single ID.

=cut

sub test_next_1 : Test(2) {
    my $test = shift;

    my $id_generator = TicTacToe::Test::IDs->new();

    my @ids = $id_generator->next(1);
    my $all_ids = $id_generator->all_ids;

    cmp_deeply( \@ids, [ re(qr/[1-9][0-9]*/) ], 'single, valid ID' );
    cmp_deeply( $all_ids, \@ids, 'all_ids lists ids' );
}


1;

} # BEGIN
