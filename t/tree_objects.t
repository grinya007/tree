use strict;
use Test::More;

use FindBin qw/$RealBin/;
use lib "$RealBin/../lib";

use_ok('Tree::objects');

my $raw_tree = {
    'label'     => 'A',
    'children'  => [
        {
            'label'     => 'B',
            'children'  => [],
        },
        {
            'label'     => 'C',
            'children'  => [
                {
                    'label'     => 'D',
                    'children'  => [],
                }
            ],
        },
        {
            'label'     => 'E',
            'children'  => [
                {
                    'label'     => 'F',
                    'children'  => [],
                },
                {
                    'label'     => 'G',
                    'children'  => [],
                }
            ],
        }
    ],
};

my $tree = Tree::objects->build($raw_tree);

is_deeply(
    $raw_tree,
    $tree->represent(),
    'initial state representation is ok'
);

ok($tree->to_string() eq <<TREE, 'initial state is ok');
A
|-E
| |-G
| `-F
|-C
| `-D
`-B
TREE

$tree->reroot('E');
ok($tree->to_string() eq <<TREE, 'root is now E');
E
|-G
|-F
`-A
  |-C
  | `-D
  `-B
TREE

done_testing();

