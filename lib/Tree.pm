package Tree;
use 5.010;
use strict;
use warnings;
use Carp qw/confess/;

#
#   Descrition
#
#   Base class that implements representation independent
#   methods and defines abstract interfaces for driver-subclasses.
#   Instances keep the initail tree represented as
#   adjacency list. This class must not be used directly.
#   Representation dependent interfaces are explained
#   below.
#
#   Synopsis
#
#       use Tree::arrays;
#
#       my $input = ['A', ['B'], ['C', ['D']]];
#       my $tree = Tree::arrays->build($input);
#       $tree->reroot('C');
#       my $output = $tree->represent();
#
#       # Now $output will keep
#       # ['C', ['A', ['B']], ['D']]
#

# Constructor
# should not be used directly since it requires the initial
# tree to be already converted to adjacency list.
#
# Use Tree::[type]->build([type specific tree])
# in order to instantiate an object from the tree
# of a perticular type (representation)
sub new {
    my ($class, $root, $list) = @_;
    confess(__PACKAGE__ . ' class is abstract') if (
        $class eq __PACKAGE__
    );
    confess(
        'please provide root label as the first argument'
    ) if (
        ! defined($root)
    );
    confess(
        'please provide adjacency list being the hash reference '.
        'of { label => [adjacent_node_label, ...], ... } '.
        'as the second argument'
    ) if (
        ref($list) ne 'HASH' ||
        grep { ref($_) ne 'ARRAY' } values %$list
    );
    return bless {
        
        # label of the root node
        '_root' => $root,

        # adjacency list
        '_list' => $list

    }, $class;
}

# Tree builder static method.
# The only argumentneeded is whatever
# tree structure representation.
# Also does some consitency checking.
sub build {
    my ($class, $data) = @_;

    my $list = {};
    my $root_label;

    # The BFS (breadth-first search) algorithm
    # is used here to traverse given tree
    # and to produce the adjacency list
    # Each item in the queue is a tuple of two elements
    #   - raw node in it's native representation
    #   - label of parent node or undef for root node
    my @queue = ([$data, undef]);
    while (my $item = shift(@queue)) {
        my ($node, $parent) = @$item;

        # both extract_label and extract_children
        # are type specific static methods
        # they are explained below
        my $label = $class->extract_label($node);
        confess(
            'bad input data: node label is undefined or '.
            'node labels are not unique'
        ) if (
            ! defined($label) ||
            exists($list->{$label})
        );

        $list->{$label} = [];
        $root_label //= $label;

        if (defined($parent)) {
            push(@{ $list->{$label} }, $parent);
            push(@{ $list->{$parent} }, $label);
        }

        my $children = $class->extract_children($node);
        for my $child (@$children) {
            push(@queue, [$child, $label]);
        }
    }

    return $class->new($root_label, $list);
}

#   Abstractions

# type specific static method
# must be implemented in subclass
# takes tree node as a single argument
# returns node's label
sub extract_label       { ... }

# type specific static method
# must be implemented in subclass
# takes tree node as a single argument
# returns node's children or the reference
# to an empty array in case when given node
# is leaf
sub extract_children    { ... }


# type specific static method
# must be implemented in subclass
# takes node label as a single argument
# returns the newly created node
# in the type specific format
sub make_node           { ... }

# type specific static method
# must be implemented in subclass
# takes two nodes as arguments
# and appends the second one to the first
# as a child
# returns nothing valueable 
sub append_child        { ... }



# changes the root of the tree to the
# node identified by given label
sub reroot {
    my ($self, $new_root) = @_;
    confess('new root lable is unknown') if (
        ! defined($new_root) || ! $self->{'_list'}{$new_root}
    );
    $self->{'_root'} = $new_root;
}

# serializes the tree to the type specific format
sub represent {
    my ($self) = @_;
    my %nodes;

    # Here once again BFS is used for tree traversal
    # Each item in the queue is the tuple of two elements:
    #   - current node label
    #   - it's parent label or undef for root
    my @queue = ([ $self->{'_root'}, undef ]);
    while (my $vertex = shift(@queue)) {
        my ($label, $parent) = @$vertex;
        next if ($nodes{$label});

        $nodes{$label} = $self->make_node($label);
        if (defined($parent)) {
            $self->append_child(
                $nodes{$parent},
                $nodes{$label}
            );
        }
        my $adjacent = $self->{'_list'}{$label};
        push(@queue, [ $_, $label ]) for (@$adjacent);
    }
    return $nodes{ $self->{'_root'} };
}

# serializes tree as a string
# places one label on a single line
sub to_string {
    my ($self) = @_;
    my $string = '';

    # Here the DFS (depth-first search) algorithm
    # is used to traverse the tree
    # Each item in the queue is the array of:
    #   - current node's label
    #   - it's parent label or undef for root
    #   - all subsequent elements are indentation
    #     symbol indexes

    my @symbols = (' ', '`', '|');
    my @queue = ([ $self->{'_root'}, undef, () ]);
    while (my $vertex = pop(@queue)) {
        my ($label, $parent, @indent) = @$vertex;

        if ($parent) {
            for (my $i = 0; $i <= $#indent; $i++) {
                $string .= ' ' if ($i);
                $string .= $symbols[
                    ($indent[$i] <=> 0) + 1
                ];
                $indent[$i] ||= -1;
            }
            $string .= '-';
        }
        $string .= "$label\n";

        my @adjacent = @{ $self->{'_list'}{$label} };
        for (my ($i, $j) = (0, 0); $i <= $#adjacent; $i++) {
            next if ($parent && $adjacent[$i] eq $parent);
            push(@queue, [
                $adjacent[$i], $label,
                @indent, $j
            ]);
            $j++;
        }
    }
    return $string;
}

1;
