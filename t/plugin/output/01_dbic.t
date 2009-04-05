use strict;
use warnings;
use Test::Base;
use App::Hachero;
use App::Hachero::Result;

BEGIN {
    eval {require 'DBIx::Class::Schema::Loader'};
    if ($@) {
        plan skip_all => 'DBIx::Class::Schema::Loader not found. So skip this test';
    } elsif ($ENV{TEST_HACHERO_DBIC}) {
        plan tests => (5 * blocks) + 2;
        use_ok 'App::Hachero::Plugin::Output::DBIC';
    } else {
        plan skip_all => 'set "TEST_HACHERO_DBIC" to run this test.';
    }
}

my $config = {
    plugins => [
        {
            module => 'Output::DBIC',
            config => {
                connect_info => [
                    'dbi:mysql:test',
                ],
            }
        },
    ]
};

my $app = App::Hachero->new({config => $config});
ok $app;

filters {
    input => [qw(yaml)],
    expected => [qw(yaml)],
};

my $schema = App::Hachero::Plugin::Output::DBIC::Schema
    ->connect('dbi:mysql:test');

run {
    my $block = shift;
    my $exp = $block->expected;
    my $rs = $schema->resultset($exp->{tablename});
    $rs->delete_all;
    my ($key, $value) = %{$block->input};
    my $res = App::Hachero::Result->new;
    for (@{$value}) {
        $res->primary([ keys %{$_} ]) unless $res->primary;
        $res->push($_); 
    }
    $app->result({$key => $res});
    $app->run_hook('output');
    my @rows = $rs->all;
    is @rows, scalar @{$exp->{rows}}; 
    for my $exp_row (@{$exp->{rows}}) {
        my $row = $rs->search($exp_row);
        for ( keys %{$exp_row} ) {
            is $row->get_column($_)->next, $exp_row->{$_};
        }
    }
    $rs->delete_all;
}

__END__
=== test1
--- input
AccessCount:
    - datetime: '2008-08-21 18:13:00'
    - datetime: '2008-08-21 18:13:00'
    - datetime: '2008-08-21 18:13:00'
    - datetime: '2008-08-21 18:13:00'
    - datetime: '2008-08-21 18:13:00'
    - datetime: '2008-08-21 18:14:00'
    - datetime: '2008-08-21 18:14:00'
--- expected
tablename: AccessCount
rows:
    - datetime: '2008-08-21 18:14:00'
      count: 2
    - datetime: '2008-08-21 18:13:00'
      count: 5
