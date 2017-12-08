use strict;
use warnings;

use TicTacToe;

my $app = TicTacToe->apply_default_middlewares(TicTacToe->psgi_app);
$app;

