use strict;
use warnings;

package Dist::Zilla::Plugin::Test::UnusedVars;
# ABSTRACT: Release tests for unused variables

our $VERSION = '2.001000';

use Path::Tiny;
use Moose;
use Sub::Exporter::ForMethods 'method_installer';
use Data::Section 0.004 { installer => method_installer }, '-setup';
use namespace::autoclean;

with qw(
    Dist::Zilla::Role::FileGatherer
    Dist::Zilla::Role::TextTemplate
);

has files => (
    is  => 'ro',
    isa => 'Maybe[ArrayRef[Str]]',
    predicate => 'has_files',
);

sub mvp_multivalue_args { return qw/ files / }
sub mvp_aliases { return { file => 'files' } }

sub gather_files {
    my $self = shift;
    my $file = 'xt/release/unused-vars.t';

    require Dist::Zilla::File::InMemory;
    $self->add_file(
        Dist::Zilla::File::InMemory->new({
            name    => $file,
            content => $self->fill_in_string(
                ${ $self->section_data($file) },
                {
                    has_files => $self->has_files,
                    files => ($self->has_files
                        ? [ map { path($_)->relative('lib')->stringify } @{ $self->files } ]
                        : []
                    ),
                }
            ),
        })
    );
};

__PACKAGE__->meta->make_immutable;
1;

=pod

=for Pod::Coverage mvp_multivalue_args mvp_aliases gather_files

=head1 SYNOPSIS

In your F<dist.ini>:

    [Test::UnusedVars]

Or, give a list of files to test:

    [Test::UnusedVars]
    file = lib/My/Module.pm
    file = bin/verify-this

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

    xt/release/unused-vars.t - a standard Test::Vars test

=cut

__DATA__
___[ xt/release/unused-vars.t ]___
use Test::More 0.96 tests => 1;
eval { require Test::Vars };

SKIP: {
    skip 1 => 'Test::Vars required for testing for unused vars'
        if $@;
    Test::Vars->import;

    subtest 'unused vars' => sub {
{{
$has_files
    ? 'my @files = (' . "\n"
        . join(",\n", map { q{    '} . $_ . q{'} } map { s{'}{\\'}g; $_ } @files)
        . "\n" . ');' . "\n"
        . 'vars_ok($_) for @files;'
    : 'all_vars_ok();'
}}
    };
};
