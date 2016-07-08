#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw/$RealBin/;
use lib "$RealBin/lib";

use Tree::arrays;

my $raw = ["A", ["B", ["D"], ["F", ["H"]]], ["C", ["I"], ["J", ["K"]]], ["G", ["E"]]];
my $tree = Tree::arrays->build($raw);

for ('A' .. 'K') {
    $tree->reroot($_);
    print $tree->to_string, "\n";
}
