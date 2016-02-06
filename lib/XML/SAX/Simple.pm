package XML::SAX::Simple;

=head1 NAME

XML::SAX::Simple - SAX version of XML::Simple

=cut

$VERSION = '0.02';

use strict;
use warnings;
use Data::Dumper;

use vars qw(@ISA @EXPORT);
use XML::Simple ();
use XML::SAX;
use XML::Handler::Trees;

@ISA    = ('XML::Simple');
@EXPORT = qw(XMLin XMLout);

=head1 DESCRIPTION

XML::SAX::Simple is a very simple version of XML::Simple but for
SAX. It can be used as a complete drop-in replacement for XML::Simple.

See the documentation for XML::Simple (which is required for this module
to work) for details.

=head1 SYNOPSIS

  use XML::SAX::Simple qw(XMLin XMLout);
  my $hash = XMLin("foo.xml");

=cut

sub XMLin {
    my $self;
    if($_[0] and UNIVERSAL::isa($_[0], 'XML::Simple')) {
        $self = shift;
    }
    else {
        $self = new XML::SAX::Simple();
    }

    $self->SUPER::XMLin(@_);
}

sub XMLout {
    my $self;

    if ($_[0] and UNIVERSAL::isa($_[0], 'XML::Simple')) {
        $self = shift;
    }
    else {
        $self = new XML::SAX::Simple();
    }
    $self->SUPER::XMLout(@_);
}

sub build_tree {
    my $self     = shift;
    my $filename = shift;
    my $string   = shift;

    if ($filename and $filename eq '-') {
        local($/);
        $string = <STDIN>;
        $filename = undef;
    }

    my $handler = XML::Handler::Tree->new();
    my $parser  = XML::SAX::ParserFactory->parser(Handler => $handler);

    $self->{nocollapse} = 1;
    my $tree;
    if ($filename) {
        $tree = $parser->parse_uri($filename);
    }
    else {
        if (ref($string) && ref($string) ne 'SCALAR') {
            $tree = $parser->parse_file($string);
        }
        else {
            $tree = $parser->parse_string($string);
        }
    }

    return $tree;
}

=head1 AUTHOR

Matt Sergeant, matt@sergeant.org

=head1 SEE ALSO

L<XML::Simple>, L<XML::SAX>.

=cut

1; # end of XML::SAX::Simple
