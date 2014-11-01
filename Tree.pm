package Tree;

use strict;
use warnings;

my $tree;

sub new {
  $tree = undef;
  my $package = shift;
  return bless {@_}, $package;
}

sub building_tree {
  my ($self, $line) = @_;
  my $bug_name;
  my $file_name;

  if($line =~ m/<\/td>\s*<td class="DESC">(.*?)<\/td>\s*<td>(.*?)<\/td>/) {
    $bug_name = $1;
    $file_name = $2;
    $file_name =~ s/<span[^>]*>.*?<\/span>//g;

    if(!defined $tree->{$file_name}->{$bug_name}) {
      $tree->{$file_name}->{$bug_name} = 1;
    }
    else {
      $tree->{$file_name}->{$bug_name}++;
    }
  }

  return $tree;
}

1;
