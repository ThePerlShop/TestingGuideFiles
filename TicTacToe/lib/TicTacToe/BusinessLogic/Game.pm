package TicTacToe::BusinessLogic::Game;
use 5.026;
use Moose;
use namespace::autoclean;


=head1 NAME

TicTacToe::BusinessLogic::Game - A class that encompasses the gameplay
of a Tic-Tac-Toe game.

=head1 SYNOPSIS

    use TicTacToe::BusinessLogic::Game;

    my $game = TicTacToe::BusinessLogic::Game->new();

    $game->move('X', 0); # puts an 'X' in slot 0 of the board

    my $board = $game->board;
    @$board; # a list of 9 slots, each ' ', 'X', or 'O'

    my $winner = $game->winner; # 'X', 'O', or undef

=cut


__PACKAGE__->meta->make_immutable;

1;
