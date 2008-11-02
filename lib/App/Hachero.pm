package App::Hachero;
use strict;
use warnings;
use 5.00800;
our $VERSION = '0.05';
use Class::Component;
use base qw(Class::Accessor::Fast);
use UNIVERSAL::require;
use File::Spec;
use Module::Collect;

__PACKAGE__->load_components(qw/DisableDynamicPlugin Plaggerize Autocall::InjectMethod/);
__PACKAGE__->mk_accessors(qw/
    currentline 
    currentlog 
    currentinfo 
    result 
    work_path 
    /);

my $packages_from_plugin_path;
my $context;
sub context { $context }

sub new {
    my ($class,$args) = @_;
    $class->_setup_plugins_static($args);
    my $self = $class->SUPER::new($args);
    $self->result({});
    $context = $self;
    $self->initialize;
    $self;
}

sub _setup_plugins_static {
    my ($class, $args) = @_;
    my $config = $class->setup_config( $args->{config} );

    my @plugins;
    my $plugin_list = $config->{global}->{pluginloader}->{plugin_list};
    for my $plugin (@{ $config->{$plugin_list} }) {
        push @plugins, { 
            module => $plugin->{module}, 
            config => $plugin,
        };
    }

    if (my $path = $config->{global}{plugin_path}) {
        my $collect = Module::Collect->new(
            path => $path,
            pattern => '*.pm',
            prefix => 'App::Hachero::Plugin',
            multiple => 1,
        );
        $packages_from_plugin_path = $collect->modules;
    }
    $class->load_plugins(@plugins);
}

sub run_hook_and_check {
    my ($self, $hook) = @_;
    $self->run_hook($hook);
    unless ($self->currentline) {
        $self->log(debug => "run_hook_and_check: $hook failed and skip this line.");
        return 0;
    }
    1;
}

sub run {
    my $self = shift;
    $self->log(debug => sprintf ('run start: %s', scalar localtime));
    $self->run_hook('fetch');
    while( $self->set_currentline ){
        $self->run_hook_and_check('parse') or next;
        $self->run_hook_and_check('classify') or next;
        $self->run_hook_and_check('filter') or next;
        $self->run_hook_and_check('analyze') or next;
        $self->run_hook('output_line');
    }
    $self->run_hook('output');
    $self->run_hook('cleanup');
    $self->log(debug => sprintf ('run end: %s', scalar localtime));
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
    $self->run_hook('initialize');
}

sub class_component_load_plugin_resolver {
    my ($self, $package) = @_;
    if ( $package !~ m{App::Hachero::Plugin::} ) {
        $package = "App::Hachero::Plugin::$package";
    }
    for my $pkg (@{ $packages_from_plugin_path }) {
        return $pkg if $pkg->package eq $package;
    }
    return undef;
}

1;
__END__

=pod

=head1 NAME

App::Hachero - a plaggable log analyzing framework

=head1 SYNOPSYS

  % hachero.pl -c config.yaml

=head1 DESCRIPTION

Hachero is plaggable log analyzing framework. You can make your own plugin to analyze log in your way. Plagger style configuration file makes it easy to run your analyzer in different environments.

=head2 configuration

You can set work_path and plugin_path configuration in the global section. Put your plugin in the plugin_path.

  ---
  global:
    log:
        level: error
    work_path: /path/to/work_path
    plugin_path: /path/to/plugin_path

  plugins:
    - module: Input::Stdin

See L<Class::Component::Component::Plaggerize> for more informations.

=head2 plugins

See L<Class::Component::Plugin> and L<App::Hachero::Plugin::Base> for implementation informations.

=head1 METHODS

=head2 new({config => $config})

instanciates App::Hachero application. you can pass config in Plagger style.

=head2 initialize (internal use only)

setups work directory.

=head2 run

runs the application.

=head2 context

returns context object of the application.

=head2 set_currentline (internal use only)

cleanups previous line and calls 'input' hook to input new line.

=head2 run_hook_and_check($hook)

runs specified hook and checks whether currentline exists. returns 1 if 
currentline exists.

=head2 class_component_load_plugin_resolver

returns plugin modules in plugin_path for Class::Component.

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<Plagger>

L<Class::Component>

L<Class::Component::Component::Plaggerize>

L<Class::Component::Component::DisableDynamicPlugin>

L<App::MadEye>

=head1 REPOSITORY

  svn co http://svn.coderepos.org/share/lang/perl/App-Hachero/trunk hachero

The svn repository of this module is hosted at L<http://coderepos.org/share/>.
Patches and commits are welcome.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
