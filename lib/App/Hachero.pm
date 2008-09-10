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

__PACKAGE__->load_components(qw/Plaggerize Autocall::InjectMethod/);
__PACKAGE__->mk_accessors(qw/currentline currentlog currentinfo result work_path packages_from_plugin_path/);

my $context;
sub context { $context }

sub new {
    my $class = shift;

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

sub setup_plugins {
    my ($self, @args) = @_;

    my $class_component_plugins = $self->class_component_plugins;

    $self->packages_from_plugin_path([]);

    if (my $path = $self->conf->{global}{plugin_path}) {
        my $collect = Module::Collect->new(
            path => $path,
            pattern => '*.pm',
            prefix => 'App::Hachero::Plugin',
        );
        my $packages = $collect->modules;

        $self->packages_from_plugin_path($packages);
    }
    $self->NEXT( setup_plugins => @args );
}

sub class_component_load_plugin_resolver {
    my ($self, $package) = @_;
    $package = "App::Hachero::Plugin::$package";
    for my $pkg (@{ $self->packages_from_plugin_path }) {
        return $pkg if $pkg->{package} eq $package;
    }
    return undef;
}

1;
