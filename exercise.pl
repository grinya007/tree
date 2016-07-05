#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw/$RealBin/;
use lib "$RealBin/lib";

use Data::Dumper;
use Tree::arrays;

local $Data::Dumper::Terse = 1;

my $T1 = ['A', ['B', ['D']], ['C']];

print "initial tree is:\n";
print Dumper $T1;

print "rerooted to B:\n";
print Dumper reroot($T1, 'B');

print "rerooted to C:\n";
print Dumper reroot($T1, 'C');

print "rerooted to D:\n";
print Dumper reroot($T1, 'D');


sub reroot {
    my ($raw_tree, $new_root) = @_;
    my $tree = Tree::arrays->build($raw_tree);
    $tree->reroot($new_root);
    return $tree->represent();
}

