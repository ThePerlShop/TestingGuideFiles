package t::lib::TicTacToe::BusinessLogic::Game::TestContext;
use 5.026;
use strict;
use warnings;

use parent 'Test::Class';

use Carp qw(croak);
use Test::MockObject;

use TicTacToe::Test::IDs;


=head1 NAME

t::lib::TicTacToe::BusinessLogic::Game::TestContext - L<Test::Class>
subclass that sets up a L<Catalyst> context for unit-testing
L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    use parent 't::lib::TicTacToe::BusinessLogic::Game::TestContext';

    sub test_basic_construction : Test(3) {
        my $test = shift;

        my $game = TicTacToe::BusinessLogic::Game->new( $test->{context} );

        my $all_ids = $test->{id_generator}->all_ids;
        is(scalar(@$all_ids), 1, 'one row generated');

        cmp_deeply( [$game->id], $all_ids, 'ID as expected' );
    }

=head1 DESCRIPTION

This is an abstract test class that implements a fake L<Catalyst>
context for unit-testing L<TicTacToe::BusinessLogic::Game>.

It automatically sets up the following test members before each test
method:

=over

=item C<< $test->{id_generator} >>

A L<TicTacToe::Test::IDs> object that is used to generate unique game
IDs. The test can call C<< $test->{id_generator}->all_ids >> to get a
list of all the game IDs that were generated during the test method,
in the order they were generated.

=item C<< $test->{game_rs} >>

A fake object that partially implements the L<DBIx::Class::ResultSet>
interface. This is returned by the context as the C<'DB::Game'> data
model. The fake resultset returns fake row objects (partially
implementing the L<DBIx::Class::Row> interface).

=item C<< $test->{game_rows} >>

A hashref that serves as the storage backing for the fake row objects
mentioned above. This hashref stores the game data as hashes keyed by
ID. For example:

    {
        1234 => {
            id => 1234,
            board => [ ... ],
        },
        5678 => {
            id => 5678,
            board => [ ... ],
        },
    }

=item C<< $test->{context} >>

A fake object that partially implements the L<Catalyst> context
interface.

=back

=cut


# Function: Deep-copy game row hashref, ignoring all unsupported fields,
# and return copy.
sub _clone_game_data {
    my ($orig) = @_;
    my $copy = {};
    $copy->{id} = $orig->{id} if exists $orig->{id};
    $copy->{board}->@* = $orig->{board}->@* if exists $orig->{board};
    return $copy;
}

# Create a new game DBIC row object.
# This is actually a fake object, and not an actual DBIC object.
# If passed an id as $col_data->{id}, load the row with that id.
# Otherwise, create a new object that can be inserted with insert().
# Uses $test->{id_generator} to generate new row IDs.
sub _new_game_row {
    my $test = shift;
    my ($col_data) = @_;
    $col_data //= {};

    if ( exists $col_data->{id} ) {
        my $id = $col_data->{id};
        my $game_rows = $test->{game_rows};
        die "id $id not in storage" unless exists $game_rows->{$id};
        $col_data = $game_rows->{$id};
    }

    my $row = Test::MockObject->new( _clone_game_data($col_data) );

    $row->mock( id => sub { $_[0]->{id} } );
    $row->mock( board => sub { $_[0]->{board} } );

    $row->mock( insert => sub {
        my $self = shift;
        my $id = $test->{id_generator}->next();
        $self->{id} = $id;
        $test->{game_rows}->{$id} = _clone_game_data($self);
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
sub setup_context : Test(setup) {
    my $test = shift;
    $test->{id_generator} = TicTacToe::Test::IDs->new();
    $test->{game_rows} = {};
    $test->{game_rs} = $test->_new_game_rs();
    $test->{context} = $test->_new_context();
}

# Delete all the data set up in setup_context().
sub teardown_context : Test(teardown) {
    my $test = shift;
    delete $test->{context};
    delete $test->{game_rs};
    delete $test->{game_rows};
    delete $test->{id_generator};
}


1;
