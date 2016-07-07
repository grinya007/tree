package Tree::fs;
use 5.012;
use strict;
use warnings;

use base 'Tree';

use Carp qw/confess/;
use File::Spec;

#
#   Descrition
#
#   Driver module for traversing filesystem.
#   Initial "representation" is the directory
#   name to start from.
#   Created for fun.
#
#   Synopsis
#
#       use Tree::fs;
#
#       my $tree = Tree::fs->build('.');
#       print $tree->to_string();
#

sub extract_label {
    my ($class, $node) = @_;
    confess('bad input data: inexistent node') unless (
        -e $node
    );
    if ($node !~ m!^/!) {
        $node = File::Spec->rel2abs($node);
    }
    return $node;
}

sub extract_children {
    my ($class, $node) = @_;
    $node = $class->extract_label($node);

    my $children = [];
    return $children unless (-d $node);

    opendir(my $dh, $node) || die "Can't open $node: $!";
    while (readdir $dh) {
        next if (/^\./);
        push(@$children, "$node/$_");
    }
    closedir $dh;

    return $children;
}

sub reroot {
    die 'Why one may want to call me?';
}

sub represent {
    die 'Unfortunately, fs tree cannot be represented '.
        'as a perl structure =(';
}

sub make_node {
    die 'Unfortunately, fs tree cannot be represented '.
        'as a perl structure =(';
}

sub append_child {
    die 'Unfortunately, fs tree cannot be represented '.
        'as a perl structure =(';
}

1;

