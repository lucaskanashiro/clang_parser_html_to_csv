#!/usr/bin/perl -w

use strict;
use warnings;

use Tree;

my $num_args = $#ARGV + 1;

if($num_args != 2){
  print "\nUsage: main.pl <HTML_file> <CSV_file>\n";
  exit;
}

my $metrics= {
  'Argument with \'nonnull\' attribute passed null'=>'an',
  'Allocator sizeof operand mismatch'=>'asom',
  'Assigned value is garbage or undefined'=>'auv',
  'Bad deallocator'=>'bd',
  'Bad free'=>'bf',
  'Dead assignment'=>'da',
  'Divisions by zero'=>'dbz',
  'Double free'=>'df',
  'Depth of Inheritance Tree'=>'dit',
  'Dereference of null pointer'=>'dnp',
  'Dereference of undefined pointer value'=>'dupv',
  'Potential buffer overflow in call to \'gets\''=>'fgbo',
  'Memory leak'=>'mlk',
  'Out-of-bound array access'=>'obaa',
  'Offset free'=>'osf',
  'Potential insecure temporary file in call \'mktemp\''=>'pitfc',
  'Result of operation is garbage or undefined'=>'rogu',
  'Return of stack variable address'=>'rsva',
  'Stack address stored into global variable'=>'saigv',
  'Undefined allocation of 0 bytes (CERT MEM04-C; CWE-131)'=>'ua',
  'Use-after-free'=>'uaf',
  'Uninitialized argument value'=>'uav'};

my $tree_instance = new Tree;
my $tree;
my $file = $ARGV[0];
my $csv_file = $ARGV[1];
my $html_handler;

open($html_handler, '<', $file) or die $!;

while(<$html_handler>) {
  $tree = $tree_instance->building_tree($_);
}

close $html_handler;

open my $csv_handler, '>'.$csv_file.'.csv' or die $!;

print $csv_handler "Filename";

foreach my $metric (values %$metrics) {
  print $csv_handler ",".$metric;
}

print $csv_handler "\n";

foreach my $filename (keys %$tree) {
  my $bugs_hash = $tree->{$filename};

  print $csv_handler $filename;

  foreach my $metric (keys %$metrics) {
    if(!defined $tree->{$filename}->{$metric}) {
      print $csv_handler ",0";
    }
    else {
      my $value = $tree->{$filename}->{$metric};
      print $csv_handler ",".$value;
    }
  }

  print $csv_handler "\n";
}

close $csv_handler;

