# Big definition of tests to run

our %TESTS = (
	'mkstr' => {
		# Simple v4
		'1.2.3.4' => [
			{ 'res' => '1.2.3.4/32', },
			{ 'args' => '-m', 'res' => '1.2.3.4/255.255.255.255', },
			{ 'args' => '-mw', 'res' => '1.2.3.4/0.0.0.0', },
			{ 'args' => '-6', 'res' => '::ffff:1.2.3.4/128', },
			{ 'args' => '-6c', 'res' => '::1.2.3.4/128', },
			{ 'args' => '-a', 'res' => '1.2.3.4', },
			{ 'args' => '-p', 'res' => '32', },
			{ 'args' => '-pm', 'res' => '255.255.255.255', },
			{ 'args' => '-pmw', 'res' => '0.0.0.0', },
			{ 'args' => '-r', 'res' => '4.3.2.1.in-addr.arpa', },
		],
		'0' => [
			{ 'res' => '0.0.0.0/32', },
		],
		# Quick test of single-digit version in dec/oct/hex
		'12' => [
			{ 'res' => '0.0.0.12/32', },
		],
		'12' => [
			{ 'res' => '0.0.0.12/32', },
		],
		'012' => [
			{ 'res' => '0.0.0.10/32', },
		],
		'0x12' => [
			{ 'res' => '0.0.0.18/32', },
		],


		# Simple v6
		'0102:0304:0506:0708:0910:1112:1314:1516' => [
			{ 'res' => '102:304:506:708:910:1112:1314:1516/128', },
			{ 'args' => '-m',
				'res' => '102:304:506:708:910:1112:1314:1516/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff', },
			{ 'args' => '-mw',
				'res' => '102:304:506:708:910:1112:1314:1516/::', },
			{ 'args' => '-mwe',
				'res' => '102:304:506:708:910:1112:1314:1516/0:0:0:0:0:0:0:0', },
			{ 'args' => '-mwev',
				'res' => '0102:0304:0506:0708:0910:1112:1314:1516/0000:0000:0000:0000:0000:0000:0000:0000', },
			{ 'args' => '-a',
				'res' => '102:304:506:708:910:1112:1314:1516', },
			{ 'args' => '-p', 'res' => '128', },
			{ 'args' => '-pm',
				'res' => 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff', },
			{ 'args' => '-pmw', 'res' => '::', },
			{ 'args' => '-r',
				'res' => '6.1.5.1.4.1.3.1.2.1.1.1.0.1.9.0.8.0.7.0.6.0.5.0.4.0.3.0.2.0.1.0.ip6.arpa', },
		],
		'::' => [
			{ 'args' => '-e', 'res' => '0:0:0:0:0:0:0:0/128', },
			{ 'args' => '-ev',
			  'res' => '0000:0000:0000:0000:0000:0000:0000:0000/128', },
		],

		# Various minimized v6 forms
		'::fe12:ab13/ffff:ff00::' => [
			{ 'res' => '::fe12:ab13/24', },
			{ 'args' => '-e', 'res' => '0:0:0:0:0:0:fe12:ab13/24', },
			{ 'args' => '-em',
				'res' => '0:0:0:0:0:0:fe12:ab13/ffff:ff00:0:0:0:0:0:0', },
		],
		'fe12::ab13' => [
			{ 'res' => 'fe12::ab13/128', },
			{ 'args' => '-e', 'res' => 'fe12:0:0:0:0:0:0:ab13/128', },
		],
		'fe12::cd98:0:ab13' => [
			{ 'res' => 'fe12::cd98:0:ab13/128', },
			{ 'args' => '-e', 'res' => 'fe12:0:0:0:0:cd98:0:ab13/128', },
		],
		'fe12::cd98:e:0:0:0:ab13' => [
			{ 'res' => 'fe12:0:cd98:e::ab13/128', },
			{ 'args' => '-e', 'res' => 'fe12:0:cd98:e:0:0:0:ab13/128', },
		],
		'fe12::cd98:0:0:0:ab13' => [
			{ 'res' => 'fe12:0:0:cd98::ab13/128', },
			{ 'args' => '-e', 'res' => 'fe12:0:0:cd98:0:0:0:ab13/128', },
		],


		# Now test netmask/pflen parsing
		'0/0' => [
			{ 'res' => '0.0.0.0/0', },
			{ 'args' => '-m', 'res' => '0.0.0.0/0.0.0.0', },
		],
		'0/24' => [
			{ 'res' => '0.0.0.0/24', },
			{ 'args' => '-m', 'res' => '0.0.0.0/255.255.255.0', },
		],
		'0/19' => [
			{ 'res' => '0.0.0.0/19', },
			{ 'args' => '-m', 'res' => '0.0.0.0/255.255.224.0', },
		],
		'0/255.192.0.0' => [
			{ 'res' => '0.0.0.0/10', },
			{ 'args' => '-m', 'res' => '0.0.0.0/255.192.0.0', },
		],
		'0.0.0.0/255.192.0.0' => [
			{ 'res' => '0.0.0.0/10', },
			{ 'args' => '-m', 'res' => '0.0.0.0/255.192.0.0', },
		],
		'::/::' => [
			{ 'res' => '::/0', },
		],


		# Wacky v4 address format
		'127.0347.0xfe8/0xff.0340.0' => [
			{ 'res' => '127.231.15.232/11', },
			{ 'args' => '-m', 'res' => '127.231.15.232/255.224.0.0', },
		],


		# Stuff we expect to fail
		'27.226.49.7.11' => [
			{ 'res' => 'FROMFAILED', },
		],
		'17.29.393.195' => [
			{ 'res' => 'FROMFAILED', },
		],
		'1.2.3.4/255.255.255.17' => [
			{ 'res' => 'FROMFAILED', },
		],
		'fe27::eeb97' => [
			{ 'res' => 'FROMFAILED', },
		],
		'fe27::geb9' => [
			{ 'res' => 'FROMFAILED', },
		],

	},
);
