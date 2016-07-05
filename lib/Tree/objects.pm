package Tree::objects;
use strict;
use warnings;

use base 'Tree';

use Carp qw/confess/;

#
#   Descrition
#
#   No special meaning.
#   Just support for another more verbose initial
#   tree representation, made for diversity of examples.
#   Actually, not blessed objects are used here.
#
#   Structure example:
#
#   {
#       'label'     => 'A',
#       'children'  => [
#           {
#               'label'     => 'B',
#               'children'  => [],
#           },
#           {
#               'label'     => 'C',
#               'children'  => [
#                   {
#                       'label'     => 'D',
#                       'children'  => []
#                   }
#               ],
#           }
#       ],
#   }
#
#   Please refer to lib/Tree.pm for details
#   on terms of use.
#

sub extract_label {
    my ($class, $node) = @_;
    confess('bad input data: invalid node') if (
        ref($node) ne 'HASH'
    );
    return $node->{'label'};
}

sub extract_children {
    my ($class, $node) = @_;
    confess('bad input data: invalid node') if (
        ref($node) ne 'HASH'
    );
    return $node->{'children'};
}

sub make_node {
    my ($class, $label) = @_;
    return {
        'label'     => $label,
        'children'  => []
    };
}

sub append_child {
    my ($class, $node, $cnode) = @_;
    confess(
        'please provide the node as the first '.
        'argument and the child node as the second argument'
    ) if (
        grep { ref($_) ne 'HASH' } ($node, $cnode)
    );
    push(@{ $node->{'children'} }, $cnode);
}

1;

