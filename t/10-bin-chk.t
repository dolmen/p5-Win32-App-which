use Test::More;

my @scripts = qw( which );

use Module::Build;
diag(keys %{Module::Build->current->scripts});

plan tests => 8*@scripts;

foreach (@scripts) {
    my $s = "$_.cmd";

    # Checks that the scripts are prepared with the proper extension
    my @files = grep { -f $_ } map { ("blib/script/$_", "blib/bin/$_") } $s;
    ok(@files eq 1, "$s ready for install");

    # Checks that the toolchain does not create bloat
    foreach (map { ("blib/script/$_", "blib/bin/$_") } map { ("$_.cmd", "$_.bat", "$_.pl") } $s) {
	ok(! -f "$_", "$_ has not been created");
    }

    SKIP: {
	skip "$s not prepared", 1 unless @files eq 1;

	# Check that EOL is Windows-style
	open my $f, '<', $files[0];
	binmode $f;
	my ($content) = do { local $/; (<$f>) };
	close $f;
	$content =~ s/\r\n//g;
	ok($content !~ /[\n\r]/, "only CRLF") or diag length($content);
    }
}
