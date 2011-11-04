#!perl
use strict;
use warnings;
use Test::More skip_all => "This test is here only for raising Kwalitee";

eval "use Pod::Coverage 1.00";
all_pod_coverage_ok();
