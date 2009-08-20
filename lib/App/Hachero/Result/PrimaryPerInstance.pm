package App::Hachero::Result::PrimaryPerInstance;
use strict;
use warnings;
use base qw(App::Hachero::Result);
__PACKAGE__->mk_accessors(qw(primary sort_key sort_reverse));

1;
