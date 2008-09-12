package App::Hachero;
use strict;
use warnings;
use 5.00800;
our $VERSION = '0.01';
use Class::Component;
use base qw(Class::Accessor::Fast);
use UNIVERSAL::require;
use File::Spec;
use Module::Collect;

__PACKAGE__->load_components(qw/DisableDynamicPlugin Plaggerize Autocall::InjectMethod/);
__PACKAGE__->mk_accessors(qw/currentline currentlog currentinfo result work_path/);

my $packages_from_plugin_path;
my $context;
sub context { $context }

sub new {
    my $class = shift;
    my $args = $_[0];
    my $config = $class->setup_config( $args->{config} );

    my @plugins;
    my $plugin_list = $config->{global}->{pluginloader}->{plugin_list};
    for my $plugin (@{ $config->{$plugin_list} }) {
        push @plugins, { module => $plugin->{module}, config => $plugin };
    }

    if (my $path = $config->{global}{plugin_path}) {
        my $collect = Module::Collect->new(
            path => $path,
            pattern => '*.pm',
            prefix => 'App::Hachero::Plugin',
        );
        $packages_from_plugin_path = $collect->modules;
    }

    $class->load_plugins(@plugins);

    my $self = $class->SUPER::new(@_);
    $self->result({});
    $context = $self;
    $self;
}

sub run_hook_and_check {
    my $self = shift;
    $self->run_hook(@_);
    return $self->currentline;
}

sub run {
    my $self = shift;
    $self->initialize;
    $self->run_hook('fetch');
    while( $self->set_currentline ){
        $self->run_hook_and_check('parse') or next;
        $self->run_hook_and_check('classify') or next;
        $self->run_hook_and_check('analyze') or next;
    }
    $self->run_hook('associate');
    $self->run_hook('output');
}

sub set_currentline {
    my $self = shift;
    $self->currentline('');
    $self->currentlog( {} );
    $self->currentinfo( {} );
    return $self->run_hook_and_check('input');
}

sub initialize {
    my $self = shift;
    my $work_path = File::Spec->catfile( $self->conf->{global}->{work_path} || '' );
    $self->work_path($work_path);
    if( !-d $work_path ){
        mkdir $work_path;
    }
}

sub class_component_load_plugin_resolver {
    my ($self, $package) = @_;
    $package = "App::Hachero::Plugin::$package";
    for my $pkg (@{ $packages_from_plugin_path }) {
        return $pkg if $pkg->{package} eq $package;
    }
    return undef;
}

1;
