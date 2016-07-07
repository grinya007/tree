#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw/$RealBin/;
use lib "$RealBin/lib";

use Tree::arrays;

my $T1 = ['A', ['B', ['D']], ['C']];
my $tree = Tree::arrays->build($T1);

print "initial tree is:\n";
print $tree->to_string(), "\n";

for my $new_root (qw/B C D/) {
    $tree->reroot($new_root);
    print "rerooted to $new_root:\n";
    print $tree->to_string(), "\n";
}

