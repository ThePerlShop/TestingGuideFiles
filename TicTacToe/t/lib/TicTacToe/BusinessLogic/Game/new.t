#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::lib::TicTacToe::BusinessLogic::Game::new->runtests;


BEGIN {
package t::lib::TicTacToe::BusinessLogic::Game::new;
use 5.026;
use strict;
use warnings;

use parent 'TicTacToe::Test::Class';

use Test::Most;
use Carp::Always;
use Data::Dumper;

use Carp qw(croak);
use TicTacToe::Test::IDs;
use Test::MockObject;

use t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs qw(:invalid);


# load code to be tested
use TicTacToe::BusinessLogic::Game;


=head1 NAME

t::lib::TicTacToe::BusinessLogic::Game::new - Unit-test the
L<new|TicTacToe::BusinessLogic::Game/new> method (constructor) of
L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/BusinessLogic/Game/new.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/BusinessLogic/Game/new.t

=cut


## Private methods

# Create a new game DBIC row object.
# This is actually a fake object, and not an actual DBIC object.
# If passed an id as $col_data->{id}, load the row with that id.
# Otherwise, create a new object that can be inserted with insert().
# Uses $test->{id_generator} to generate new row IDs.
sub _new_game_row {
    my $test = shift;
    my ($col_data) = @_;
    $col_data //= {};

    state %game_rows; # stored by id

    my %obj_data = %$col_data; # shallow copy
    if ( exists $obj_data{id} ) {
        my $id = $obj_data{id};
        die "id $id not in storage" unless exists $game_rows{$id};
        %obj_data = $game_rows{$id}->%*;
    }

    my $row = Test::MockObject->new( \%obj_data );

    $row->mock( id => sub { $_[0]->{id} } );
    $row->mock( board => sub { $_[0]->{board} } );

    $row->mock( insert => sub {
        my $self = shift;
        my $id = $test->{id_generator}->next();
        $self->{id} = $id;
        $game_rows{$id} = {%$self};
        return $self;
    } );

    return $row;
}

# Create a new game DBIC resultset object.
# This is actually a fake object, and not an actual DBIC object.
sub _new_game_rs {
    my $test = shift;

    my $game_rs = Test::MockObject->new();

    $game_rs->mock( find => sub {
        my $rs = shift;
        my ($col_data) = @_;
        return $test->_new_game_row($col_data)
          if exists $col_data->{id};
        return (undef);
    } );

    $game_rs->mock( create => sub {
        my $rs = shift;
        my ($col_data) = @_;
        return $test->_new_game_row($col_data)->insert();
    } );

    return $game_rs;
}

# Create a new Catalyst context.
# This is actually a fake object, not an actual Catalyst object.
# The context returns $test->{game_rs} as the 'DB::Game' model.
sub _new_context {
    my $test = shift;

    my $context = Test::MockObject->new();

    $context->set_isa('Catalyst');

    $context->mock( model => sub {
        my $c = shift;
        my ( $name, @args ) = @_;
        return $test->{game_rs} if $name eq 'DB::Game';
        return (undef);
    } );

    return $context;
}

# Set up the Catalyst context for unit testing.
# The context object is stored in $test->{context}.
# This also sets up a shared game DBIC resultset, stored in $test->{game_rs}.
# Row IDs are set via an ID generator, stored in $test->{id_generator}.
sub _setup_context : Test(setup) {
    my $test = shift;
    $test->{id_generator} = TicTacToe::Test::IDs->new();
    $test->{game_rs} = $test->_new_game_rs();
    $test->{context} = $test->_new_context();
}


=head1 TESTS

=head2 test_basic_construction

Instantiates a new C<TicTacToe::BusinessLogic::Game> object, and
verifies that constructor succeeds, that it generates a new row, and
that the constructed object has the expected C<id>.

=cut

sub test_basic_construction : Test(3) {
    my $test = shift;

    ok( my $game = TicTacToe::BusinessLogic::Game->new( $test->{context} ) );

    my $all_ids = $test->{id_generator}->all_ids;
    is(scalar(@$all_ids), 1, 'one row generated');

    cmp_deeply( [$game->id], $all_ids, 'ID as expected' );
}


=head2 test_board_initialized_invalid

Instantiates new C<TicTacToe::BusinessLogic::Game> objects, specifying
initial board states, but ones that are invalid. Verifies that the
constructor throws an appropriate error for each condition.

The error conditions tested are as follows:

=over

=item 1.

A board that is not an arrayref.

=item 2.

A board with fewer than 9 spaces.

=item 3.

A board with more than 9 spaces.

=item 4.

A board with at least one space that is neither C<'X'>, C<'O'>, nor C<' '>.

=item 5.

A board with more 'O' than 'X' (meaning that 'O' has gone too many times).

=item 6.

A board with two more 'X' than 'O' (meaning that 'X' has gone too many times).

=back

=cut

sub test_board_initialized_invalid : Tests() {
    my $test = shift;

    my @cases = (
        {
            description => 'not an arrayref',
            board => 'NOT AN ARRAYREF',
            error => qr/value is not an arrayref/,
        },
        {
            description => 'fewer than 9 spaces',
            board => \@BOARD_INVALID_SHORT_ARRAY,
            error => qr/arrayref does not have exactly 9 items/,
        },
        {
            description => 'more than 9 spaces',
            board => \@BOARD_INVALID_LONG_ARRAY,
            error => qr/arrayref does not have exactly 9 items/,
        },
        {
            description => 'invalid player piece',
            board => \@BOARD_INVALID_WRONG_PIECE,
            error => qr/'A' is an invalid player piece/,
        },
        {
            description => 'X has moved out of turn',
            board => \@BOARD_INVALID_TOO_MANY_X,
            error => qr/'X' has moved out of turn/,
        },
        {
            description => 'O has moved out of turn',
            board => \@BOARD_INVALID_TOO_MANY_O,
            error => qr/'O' has moved out of turn/,
        },
    );

    for my $case (@cases) {
        subtest $case->{description} => sub {
            throws_ok {
                TicTacToe::BusinessLogic::Game->new(
                    board => $case->{board},
                )
            } $case->{error}, "throws $case->{error}";
        };
    }
}


1;

} # BEGIN
