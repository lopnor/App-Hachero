package App::Hachero;
use strict;
use warnings;
use 5.00800;
our $VERSION = '0.01';
use Class::Component;
use base qw(Class::Accessor::Fast);
#use Params::Validate;
use UNIVERSAL::require;
use File::Spec;
#use Log::Dispatch;
__PACKAGE__->load_components(qw/Plaggerize Autocall::InjectMethod/);
__PACKAGE__->mk_accessors(qw/currentline currentlog currentinfo result work_path/);

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

1;
