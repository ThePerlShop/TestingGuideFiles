package <MODULE>;
use 5.026;
use strict;
use warnings;

use parent 'Exporter';

our @EXPORT = qw(<EXPORT SYMBOLS>);

our @EXPORT_OK = qw(<EXPORT_OK SYMBOLS>);

our %EXPORT_TAGS = (
    <EXPORT TAG> => [qw(<EXPORT TAG SYMBOLS>)],
);


use <USED CLASS> qw(<METHOD IMPORT>);


=head1 NAME

<MODULE> - <DESCRIPTION>

=head1 SYNOPSIS

    use <MODULE>;

    ### how to use <MODULE> here

=cut


=head1 FUNCTIONS

=head2 <FUNCTION>

<DESCRIPTION OF FUNCTION>

=cut

sub <FUNCTION> {
    my ($arg1, $arg2, $arg3, %args) = @_;

}


## Private functions.

# <DESCRIPTION OF FUNCTION>
sub <FUNCTION> {
    my ($arg1, $arg2, $arg3, %args) = @_;

}


1;
