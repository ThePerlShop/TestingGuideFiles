package TicTacToe::Test::Class;
use 5.026;
use strict;
use warnings;

use parent 'Test::Class';


=head1 NAME

TicTacToe::Test::Class - C<Test::Class>-derived class encompassing
functionality required by all tests in the TicTacToe application.

=cut


=head1 METHODS

=head2 fail_if_returned_early

Called by C<Test::Class>, and signals not to implicitly skip tests.

Returns true by default, unless L<bailout> is called first in the test
method.

=cut

sub fail_if_returned_early {
    my $self = shift;
    return $self->{_fail_if_returned_early} //= 1;
}


=head2 bailout

Call before returning from a test method in order to skip remaining
tests, rather than failing the test method.

If a reason is passed as a paramater, C<bailout> returns it. Otherwise,
it returns C<1>. This provides two ways of using the method:

    return $test->bailout($reason);

...or...

    $test->bailout && return $reason;

=cut

sub bailout {
    my $test = shift;
    my ($reason) = @_;
    $test->{_fail_if_returned_early} = 0;
    return $reason // 1;
}


=head2 no_bailout

Call before returning from a test method in order to fail the test
method on return, rather than skipping remaining tests. (The opposite of
L<bailout>.)

This is called automatically by C<Test::Class> before each test method,
to reset any previous call to C<bailout>.

=cut

sub no_bailout : Test(setup) {
    my $test = shift;
    $test->{_fail_if_returned_early} = 1;
}


1;
