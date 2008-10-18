package App::Hachero::Plugin::Base;
use strict;
use warnings;
use base qw/Class::Component::Plugin Class::Accessor::Fast/;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self;
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Base - base class of plugin for App::Hachero

=head1 SYNOPSYS

  package App::Hachero::Plugin::Analyze::MyAnalyzer;
  use base App::Hachero::Plugin::Base;

  sub init {
      my ($self, $app) = @_;
      # prepare something
  }

  sub analyzer : Hook {
      my ($self, $context) = @_;
      # do something
  }
  
  1;

=head1 DESCRIPTION

base class of App::Hachero plugin. You can subclass this to implement your analyzer or
other plugins.

=head2 preparation

you can setup your plugin in init method.

=over 4

=item * init($self, $app)

$self is instanciated plugin object and so you can setup your plugin before running hooks.
$app is not application instance but classname "App::Hachero" string.

=back

=head2 available hooks

=over 4

=item * initialize

called once after the application is instancieated.
you can access to $context->conf->{global} and setup your plugins.

=item * fetch

called once at the begining of the application. 
See L<App::Hachero::Plugin::Fetch::FTP> for detailed example.

=item * input

called to set the current log line.
See L<App::Hachero::Plugin::Input::Stdin> for detailed example.

=item * parse

called in each line to parse the current log line.
See L<App::Hachero::Plugin::Parse::Common> for detailed example.

=item * classify

called to distingwish the log type (for example, whether robot access or not).
See L<App::Hachero::Plugin::Classify::Robot> for detailed example.

=item * filter

called to exclude needless log.
See L<App::Hachero::Plugin::Filter::AccessTime> for detailed example.

=item * analyze

called to analyze the log and store result.
See L<App::Hachero::Plugin::Analyze::AccessCount> for detailed example.

=item * output_line

called to output result of the current log line.
See L<App::Hachero::Plugin::OutputLine::HadoopMap> for detailed example.

=item * output

called once the end of process to output calculated result.
See L<App::Hachero::Plugin::Output::Dump> for detailed example.

=item * cleanup

called once after the process to cleanup.

=back

=head1 METHODS

=head2 new

Constructor. You don't need to think about it.

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
