#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw/$RealBin/;
use lib "$RealBin/lib";

use Tree::fs;

my $tree = Tree::fs->build($ARGV[0] || $RealBin);
print $tree->to_string();

