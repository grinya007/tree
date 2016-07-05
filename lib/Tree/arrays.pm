package Tree::arrays;
use strict;
use warnings;

use base 'Tree';

use Carp qw/confess/;

#
#   Descrition
#
#   Driver module for trees represented
#   as labeled arrays, where each node is
#   an array with it's label at the 0 index
#   and all subsequent elements (if any)
#   are references to child nodes.
#
#   Structure example:
#
#   ['A', ['B'], ['C', ['D']]]
#
#   Please refer to lib/Tree.pm for details
#   on terms of use.
#

sub extract_label {
    my ($class, $node) = @_;
    confess('bad input data: invalid node') if (
        ref($node) ne 'ARRAY'
    );
    return $node->[0];
}

sub extract_children {
    my ($class, $node) = @_;
    confess('bad input data: invalid node') if (
        ref($node) ne 'ARRAY'
    );
    return [ @$node[ 1 .. $#$node ] ];
}

sub make_node {
    my ($class, $label) = @_;
    return [ $label ];
}

sub append_child {
    my ($class, $node, $cnode) = @_;
    confess(
        'please provide the node as the first '.
        'argument and the child node as the second argument'
    ) if (
        grep { ref($_) ne 'ARRAY' } ($node, $cnode)
    );
    push(@$node, $cnode);
}

1;

