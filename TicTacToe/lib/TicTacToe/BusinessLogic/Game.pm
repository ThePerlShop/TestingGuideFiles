package TicTacToe::BusinessLogic::Game;
use 5.026;
use Moose;
use namespace::autoclean;

use Carp qw(croak);
use Scalar::Util qw(blessed);


=head1 NAME

TicTacToe::BusinessLogic::Game - A class that encompasses the gameplay
of a Tic-Tac-Toe game.

=head1 SYNOPSIS

    use TicTacToe::BusinessLogic::Game;

    my $game = TicTacToe::BusinessLogic::Game->new();
    my $id = $game->id;

    $game = TicTacToe::BusinessLogic::Game->new(id => $id);

    $game->move('X', 0); # puts an 'X' in slot 0 of the board

    my $board = $game->board;
    @$board; # a list of 9 slots, each ' ', 'X', or 'O'

    my $winner = $game->winner; # 'X', 'O', or undef

=cut 


## Private methods and functions

# Counts the number of each piece on the board and returns a hashref
# mapping each piece to its number of occurrences.
sub _piece_counts {
    my $board = shift;
    my %piece_counts = (X => 0, O => 0, ' ' => 0);
    $piece_counts{$_}++ for @$board;
    return \%piece_counts;
}


# Return an appropriate error message if the board is invalid.
# Otherwise, returns false.
sub _is_invalid_board {
    my $board = shift;

    return "value is not an arrayref"
        unless ref $board eq 'ARRAY';

    return "arrayref does not have exactly 9 items"
        unless @$board == 9;

    my $piece_counts = _piece_counts($board);

    return "'$_' is an invalid player piece"
        for grep { m/[^XO ]/i } keys %$piece_counts;

    return "'X' has moved out of turn"
        if $piece_counts->{X} - $piece_counts->{O} > 1;

    return "'O' has moved out of turn"
        if $piece_counts->{O} - $piece_counts->{X} > 0;

    return ();
}


# If all the of elements passed in are all 'X' or 'O', return that string.
# Otherwise return undef (an explicit undef, not an empty list).
sub _winning_seq {
    my $first = shift;
    return (undef) unless $first eq 'X' || $first eq 'O';
    while (@_) {
        return (undef) unless shift eq $first;
    }
    return $first;
}


## Private attributes.

# The game DBIC "row" object.
has _game_row => (
    is => 'ro',
);



=head1 CONSTRUCTOR

=head2 new

Starts a new game or continues an existing game.

By default, starts a new game with the board initialized to blank. (See
L</board>.) But if L</id> is specified, then that game is loaded from the
data model and continued.

An initial L</board> state may be specified as a Moose attribute
initializer. Such a board state must be valid, or else the constructor
will die with an appropriate error message.

If C<id> is specified, C<board> should not be specified and will be ignored.

=cut

# The new() method is inherited from Moose::Object


=head1 ATTRIBUTES

=head2 context

The Catalyst context against which operations in this game are being
performed. This context is used to access the data model.

This attribute is read-only, but it may be inialized as a Moose
attribute during construction or by passing C<$c> into the contructor
as the first parameter.

=cut

has context => (
    is => 'ro',
);


=head2 id

The id of the game.

Each game has a unique ID, assigned by the data model.

This attribute is read-only. If it is specified as a Moose
initializer, then the game state is fetched from the data model during
initialization.

=cut

has id => (
    is => 'ro',
);


=head2 board

The current state of the game board, an arrayref of nine positions, each
' ', 'X', or 'O'.

The board is conceptually arranged as three rows of three columns each
(or three columns of three rows each), but represented as a flat array
of nine spaces. (The calling code must decide how to display these
spaces to the user, but regardless of whether they are displayed
rows-first or columns-first, gameplay proceeds identically.)

This attribute is read-write, and the underlying data can be written to.
However, normally this will be modified only by the L</move> method.

=cut

has board => (
    is => 'rw',
);


around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my $c = ( blessed( $_[0] ) && $_[0]->isa('Catalyst') ) ? shift : undef;

    my $args = $class->$orig(@_);

    if (exists $args->{board}) {
        my $error_message = _is_invalid_board($args->{board});
        croak "'board': $error_message" if $error_message;
    } else {
        $args->{board} = [ (' ') x 9 ];
    }

    # Synch $c and $args->{context}, because the former is used to
    # initialize the context attribute, and the latter is used in the
    # code below as a shorthand.
    $args->{context} = $c unless defined $args->{context};
    $c = $args->{context};

    if ( defined $c ) {
        my $game_rs = $c->model('DB::Game');
        my $game_row;
        if ( exists $args->{id} ) {
            $game_row = $game_rs->find( { id => $args->{id} } );
            $args->{board} = $game_row->board;
        } else {
            $game_row = $game_rs->create({
                board => $args->{board},
            });
            $args->{id} = $game_row->id;
        }
        $args->{_game_row} = $game_row;
    }

    return $args;
};


=head1 METHODS

=head2 move

    $game->move($piece, $location)

Place a piece on a location on the board.

Does not return a value.

=over

=item *

C<$piece> must be C<'X'> or C<'O'>, and C<$location> must be an integer
0 through 8.

=item *

The location must not already be occupied.

=item *

The player specified must not be playing out of turn. That is, judging
from the pieces already on the board, the specified player goes next and
no player has already won the game.

=back

If these rules are not followed, this method will die with an
appropriate error message.

=cut

sub move {
    my $self = shift;
    my ($piece, $location) = @_;

    my $board = $self->board;

    croak "move to invalid location: $location\n"
        unless $location >= 0 && $location < 9;

    croak "move of invalid piece: $piece\n"
        unless $piece eq 'X' || $piece eq 'O';

    croak "location $location is already occupied by $board->[$location]\n"
        unless $board->[$location] eq ' ';

    my $winner = $self->winner;
    croak "$winner already won" if $winner;

    my $next_player = $self->next_player;
    croak "$piece attempted to move, but it's ${next_player}'s turn\n"
        unless $piece eq $next_player;

    $board->[$location] = $piece;

    my $game_row = $self->_game_row;
    $game_row->update( { board => $self->board } ) if $game_row;
}


=head2 next_player

    $game->next_player

Returns C<'X'> or C<'O'>, depending on who is to play next. Returns
C<undef> if the game has been won.

=cut

sub next_player {
    my $self = shift;

    return (undef) if $self->winner;

    my $board = $self->board;

    my $piece_counts = _piece_counts($board);

    return (undef) unless $piece_counts->{' '} > 0;
    return ( $piece_counts->{X} > $piece_counts->{O} ) ? 'O' : 'X';
}


=head2 winner

    $game->winner

Returns C<'X'> or C<'O'>, depending on who has won. Returns C<undef> if
no one has yet won.

=cut

sub winner {
    my $self = shift;

    my $board = $self->board;

    my @winning_seqs = (
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6],
    );

    for my $idxs (@winning_seqs) {
        my $winner = _winning_seq( @{$board}[ @$idxs ] );
        return $winner if $winner;
    }

    return (undef);
}


__PACKAGE__->meta->make_immutable;

1;
