use strict;
use Test::More;

use FindBin qw/$RealBin/;
use lib "$RealBin/../lib";

use_ok('Tree::arrays');

my $raw_tree = ["A", ["B", ["D"], ["F", ["H"]]], ["C"], ["G"]];
my $tree = Tree::arrays->build($raw_tree);

is_deeply(
    $raw_tree,
    $tree->represent(),
    'initial state representation is ok'
);

ok($tree->to_string() eq <<TREE, 'initial state is ok');
A
  G
  C
  B
    F
      H
    D
TREE

eval { $tree->reroot('Z') };
ok(defined($@), 'attempt to reroot to inexistent node is prevented');

$tree->reroot('B');
ok($tree->to_string() eq <<TREE, 'root is now B');
B
  F
    H
  D
  A
    G
    C
TREE

is_deeply(
    $tree->represent(),
    ["B", ["A", ["C"], ["G"]], ["D"], ["F", ["H"]]],
    'rerooted tree native representation is ok'
);

done_testing();

