package App::Hachero::Plugin::Input::File;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use File::Find::Rule;
use File::Find::Rule::Age;
use File::stat;

sub init {
    my ($self, $context) = @_;
}

sub _fetch {
    my ($self, $context) = @_;
    $self->{rule} ||= $self->_get_rule($context);
    my $file = $self->{rule}->match or return;

    if ($context->conf->{global}->{log}->{level} eq 'debug') {
        $context->log(debug => "opening file: $file");
        $self->{readsize} = 0;
        $self->{filesize} = stat($file)->size;
    }
    open my $fh, '<', $file or die;
    $self->{fh} = $fh;
}

sub _get_rule {
    my ($self, $context) = @_;
    my $path = $self->config->{config}->{path} || $context->work_path;
    my $rule = File::Find::Rule->file();
    my $config = $self->config->{config}->{rule};
    for my $key (keys %{$config}) {
        my $value = $config->{$key};
        $rule->$key(
            ref $value eq 'HASH' ? %{$value} :
            ref $value eq 'ARRAY' ? @{$value} :
            $value
        );
    }
    $self->{rule} = $rule->start( $path );
    return $self->{rule};
}

sub input : Hook {
    my ($self, $context, $args) = @_;
    my $line = '';
    until ($line) {
        my $fh = $self->{fh} || $self->_fetch($context) or return;
        $line = <$fh>;
        if ($context->conf->{global}->{log}->{level} eq 'debug') {
            $self->{readsize}+= do {use bytes; length $line} if $line;
            print STDERR "\rreading file: $self->{readsize}/$self->{filesize}";
        }
        if ($line) {
#            $context->log(debug => 'the line: '. $line);
        } else {
            if ($context->conf->{global}->{log}->{level} eq 'debug') {
                print STDERR "\n";
            }
            close $self->{fh};
            delete $self->{fh};
        }
    }
    $context->currentline( $line );
}

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Input::File - reads logs from specified direcotry

=head1 SYNOPSYS

=head1 DESCRIPTION

=head1 IMPLEMENTED HOOKS
    
=head2 input 

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
