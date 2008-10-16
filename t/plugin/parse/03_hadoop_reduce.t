use strict;
use warnings;
use Test::More tests => 5;
use App::Hachero;
use App::Hachero::Plugin::Analyze::AccessCount;
use Digest::MD5 qw(md5_hex);

BEGIN {
    use_ok 'App::Hachero::Plugin::Parse::HadoopReduce';
}

my $config = {
    plugins => [
        { module => 'Parse::HadoopReduce' }
    ]
};

my $app = App::Hachero->new({config => $config});

my $dt = '2008-10-17 04:03:15';
my $secondary = md5_hex($dt);
{
    $app->currentline(qq(AccessCount-$secondary\t\$VAR1=bless({'data' => {'$secondary' => bless( {"datetime"=> "$dt","count" => 3}, 'App::Hachero::Result::Data' )}}, 'App::Hachero::Result::AccessCount');\n));
    $app->run_hook('parse');
    my ($data) = $app->result->{AccessCount}->values;
    isa_ok $data, 'App::Hachero::Result::Data';
    is_deeply $data->hashref, {datetime => $dt, count => 3};
}
{
    $app->currentline(qq(AccessCount-$secondary\t\$VAR1=bless({'data' => {'$secondary' => bless( {"datetime"=> "$dt","count" => 7}, 'App::Hachero::Result::Data' )}}, 'App::Hachero::Result::AccessCount' );\n));
    $app->run_hook('parse');
    my ($data) = $app->result->{AccessCount}->values;
    isa_ok $data, 'App::Hachero::Result::Data';
    is_deeply $data->hashref, {datetime => $dt, count => 10};
}
