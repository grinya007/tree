#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use feature qw/state/;

use FindBin qw/$RealBin/;
use lib "$RealBin/lib";

use Data::Dumper;
use Tree::arrays;

local $Data::Dumper::Indent = 0;
local $Data::Dumper::Terse  = 1;

my $T1 = ['A', ['B', ['D']], ['C']];

print "initial tree is:\t";
print Dumper($T1), "\n";

for my $new_root (qw/B C D/) {
    print "rerooted to $new_root:\t\t";
    print Dumper( reroot($T1, $new_root) ), "\n";
}

sub reroot {
    my ($tree, $root) = @_;
    my $pointer = int($tree);
    state $trees = {};
    unless ($trees->{ $pointer }) {
        $trees->{ $pointer } = Tree::arrays->build($tree);
    }
    $trees->{ $pointer }->reroot($root);
    return $trees->{ $pointer }->represent();
}
