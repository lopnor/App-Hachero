#!perl
use strict;
use warnings;
use Test::More;
use App::Hachero;
use File::Temp;
use File::Basename;

BEGIN {
    eval {require Net::Amazon::S3};
    if ($@) {
        plan skip_all => 'no Net::Amazon::S3 found';
    } else {
        for (qw(
                HACHERO_TEST_S3 
                HACHERO_TEST_S3_BUCKET 
                HACHERO_TEST_S3_PREFIX
                AWS_ACCESS_KEY_ID 
                AWS_SECRET_ACCESS_KEY 
            )) {
            $ENV{$_} or plan skip_all => "set $_ to run this test";
            exit 0;
        }   
        plan tests => 2;
    }
}   

my $work_path = File::Temp::tempdir(CLEANUP => 1, DIR => 't');
my $prefix = $ENV{HACHERO_TEST_S3_PREFIX};
my $config = {
    plugins => [
    {
        module => 'Fetch::S3',
        config => {
            aws_access_key_id => $ENV{AWS_ACCESS_KEY_ID},
            aws_secret_access_key => $ENV{AWS_SECRET_ACCESS_KEY},
            bucket => $ENV{HACHERO_TEST_S3_BUCKET},
            prefix => $prefix,
        }
    }   
    ],  
    global => {
        work_path => $work_path,
    },  
};  

my $app = App::Hachero->new({config => $config});
$app->initialize;
ok $app->run_hook('fetch');

is scalar grep({basename($_) !~ /^$prefix/} glob("$work_path/*")), 0;
