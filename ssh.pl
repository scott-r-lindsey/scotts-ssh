#!/usr/bin/perl -w
# Scott's ssh key inserter script.
# This will insert public keys in the current user's authorized_keys file
#
# README:
# https://github.com/scott-r-lindsey/scotts-ssh

# ------------------------------------------------------------------------------
$home               = $ENV{HOME};
$authorized_keys    = "$home/.ssh/authorized_keys";
$key_identifier     = 'SL-AUTO-SSH';

# ------------------------------------------------------------------------------
# Setup any missing files / folders and fix common permission issues
if (!-e $home . '/.ssh'){
    mkdir $home . '/.ssh', 0700;
    print "Created $home/.ssh (0700)\n";
}
if (!-e $authorized_keys){
    `>$authorized_keys`;
    chmod 0600, $authorized_keys;
    print "Created $authorized_keys (0600)\n";
}
`chmod g-w $home`;
`chmod o-w $home`;

# ------------------------------------------------------------------------------

my @lines;
my $keys = &keys();

# ------------------------------------------------------------------------------
# Read in current file, drop lines containing "SL-AUTO-SSH"
# This will avoid adding a key twice and remove any old keys
if (-e $authorized_keys){
    open AUTHKEY, $authorized_keys;
    foreach (<AUTHKEY>){
        if (!/$key_identifier/){
            chop;
            if ($_){
                push @lines, $_;
            }
        }
    }
    close AUTHKEY;
}

# ------------------------------------------------------------------------------
# This writes back the pre-existing contents of authorized_keys and any keys 
# that are listed in the keys() subroutine
open AUTHKEY, ">$authorized_keys";
foreach (@lines){
    print AUTHKEY "$_\n";
}
foreach (@$keys){
    print AUTHKEY "$_-$key_identifier\n";
}
close AUTHKEY;

print "inserted public keys in $authorized_keys\n";
# ------------------------------------------------------------------------------

sub keys{
    return [
        # tower
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcAG6yeW+Y5qceRuHhegrGw5W0CMi4/d/6Mjiobf27sqyR7dFXavx8QFRV6uJBiFJvnQicVi8gJOzWiWHQhIWho/AHba4sJTok2PnoLncwUtymc6koFD5gtTZKf2l+AxlDmx59wGsCB5EoIOGMa3R6JCPqHwm0KLkBWAkKcXQaR9fuo8uzOlWBN6w7K+j3ZBGwJ2gqaZnULwdZnaf0OO6liqvsQcQ9+IyukUgoV44rSklu1fuDxuA9On0jyIuGtcBU0nJPkrbzXgquSigQHcCBgXiscyNBoPr8xqRG4UpCtTBR88Jo6egosCPOR8jMAOgfEEahu6p90Ss1/1TnLf8sJbQXIQdoy60NeAK0pPaG1HlZsMgvtevI6YBzNT2karm7G6o4P9FQU1+5LVefeAZrMCIZTsuiT2DmuVDSh9vZCUthkwLXA2yhRau59B01P+8Jsknl1QIY0v/dLvQhP15jw8o1KPgIZ//pu2x1pZ3uJKaEl/HL6z2sNE79XDR90ndl+TOmpS/sthAPvTIWQxvcLsrMjFTNpTZLxu2ue1/BL6ZuB+7Rkcm5X9i1uzpSYuvWcj2zTLycztAVxWIWYjvhPfiiwmLjAqsVOHC6feZGvOIyuCD8j+4hs/08BTcDdLfCt/8UBdqRuwb7TGzymyFPJxue+fmxs6JyyZDZNPSPcQ== scott@toadie',
        # tank
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaNpSgUOJwHTBiXdEgML/NjDIVehiLnVb07izWAc2/cc3J+KA6N/C9Od0Qx5KpIXtS9x3T4ie6+NxM2oAutA4LRDuIfguospgfqDSDyzp9WeySvvk+4fyVsckqw2r9GDv4+oVpfBkIVVAF3vvOes/kBYvEYl4R9QJ1q8Eragbk+GABbxT1xRc5FaQ6an/b49sCx57cYxcqwWhvUR/AZz2TPLEdwFIRMRKPSHUmYBMonFu2uhx4ftOCa0p1fZRkkvCr7zWF+cGRfVe5HpT55DE1oAvX/b+oEmIBnKL/Q2gGgaDY7eWk6oQjb1hdcrvUdpNOXrjNL9egE4n+2jH+Kz8Fdd9j08Gn6DSndo6uT1MXYxQM7hLTGB0YDJhzfc89myQpjNjJK0Kwx1pMC1nYA+zaGMySnxb+4BOGJk1g+B+jcFScfHhf2Y8TZv0UO6nJXBPsrjyoCcNk0IE3UMrUZCVaCaShXz7zFvXezIy+tIOlbMtLNNkAwo218aIsK4SWFPOBPUdwRdLLgVXUJi3iNLbK+gACz+6Wo7pdzYspdB2oCES8xv7HAFWH2wXCeNvyqhJn2t8m/3axY6P/pOkoYEVU8nBkYzaEwfH6kjCE47uqVf7RlUgNktvr9mnecEOP9XdQNT3Yw85ae78wjpodaitk0nR0v1EjzTfMpeMO1pDO7Q== slindsey@tank',
        # mother
        'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/y85I38Q47i5Q8omEBCJAw0HbAt7Z4oRIVwG7ZS8bY scott@scott.to',
    ];
}

