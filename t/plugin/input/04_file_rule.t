use strict;
use warnings;
use Test::Base;
use App::Hachero;
use DateTime;

BEGIN {
    eval {require 'File::Find::Rule'; require 'File::Find::Rule::Age';};
    if ($@) {
        plan skip_all => 'File::Find::Rule or File::Find::Rule::Age not found. So skip this test';
    } else {
        plan tests => 1 * blocks;
    }
}

filters {
    config => [qw(yaml)],
    files => [qw(yaml)],
    expected => [qw(yaml)],
};

run {
    my $block = shift;
    for my $file (@{$block->files}) {
        open my $fh, '>', $file->{path};
        print $fh $file->{contents};
        close $fh;
        if ($file->{mtime}) {
            my $mtime = DateTime->now->subtract(days => $file->{mtime})->epoch;
            utime $mtime, $mtime, $file->{path};
        }
    }
    my $app = App::Hachero->new({config => $block->config});
    my @result;
    while ($app->set_currentline) {
        push @result, $app->currentline;
    }
    is_deeply [sort @result], [sort @{$block->expected}];
    for my $file (@{$block->files}) {
        unlink $file->{path};
    }
};

__END__
=== 
--- config
global:
    log:
        level: error
plugins:
    - module: Input::File
      config: 
        path: t/work
        rule:
            name: access_log*
--- files
- path: t/work/access_log.1
  contents: contents of access_log.1
- path: t/work/access_log.2
  contents: contents of access_log.2
--- expected
- contents of access_log.1
- contents of access_log.2
=== 
--- config
global:
    log:
        level: error
plugins:
    - module: Input::File
      config: 
        path: t/work
        rule:
            name: access_log*
--- files
- path: t/work/access_log
  contents: contents of access_log
- path: t/work/hoge
  contents: contents of hoge
--- expected
- contents of access_log
=== 
--- config
global:
    log:
        level: error
plugins:
    - module: Input::File
      config: 
        path: t/work
        rule:
            name: access_log*
            age:
                newer: 2D
--- files
- path: t/work/access_log
  mtime: 0
  contents: contents of access_log
- path: t/work/access_log.1
  mtime: 1
  contents: contents of access_log.1
- path: t/work/access_log.2
  mtime: 2
  contents: contents of access_log.2
--- expected
- contents of access_log
- contents of access_log.1
