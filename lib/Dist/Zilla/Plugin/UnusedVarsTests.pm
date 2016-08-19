use strict;
use warnings;

package Dist::Zilla::Plugin::UnusedVarsTests;
# ABSTRACT: (DEPRECATED) Release tests for unused variables

our $VERSION = '2.001000';

use Moose;
use namespace::autoclean;
extends 'Dist::Zilla::Plugin::Test::UnusedVars';

before register_component => sub {
    warnings::warnif('deprecated',
        "!!! [UnusedVarsTests] is deprecated and will be removed in a future release; please use [Test::UnusedVars].\n",
    );
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=pod

=head1 SYNOPSIS

Please use L<Dist::Zilla::Plugin::Test::UnusedVars> instead.

In your F<dist.ini>:

    [Test::UnusedVars]

=head1 DESCRIPTION

THIS MODULE IS DEPRECATED. Please use
L<Dist::Zilla::Plugin::Test::UnusedVars> instead. It may be removed at a
later time (but not before February 2017).

=cut
