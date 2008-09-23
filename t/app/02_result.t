use strict;
use warnings;
use Test::More tests => 3;

BEGIN {
    use_ok 'App::Hachero::Result';
}

my $res = App::Hachero::Result->new;
isa_ok $res, 'App::Hachero::Result';
$res->primary([qw(primary)]);
for (1 .. 3) {
    $res->push(
        {
            primary => $_,
        }
    );
}

my @values = $res->values;
is_deeply \@values, [
    {primary => 1, count => 1},
    {primary => 2, count => 1},
    {primary => 3, count => 1},
];
