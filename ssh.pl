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
        # lappy
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVXG5NmmBvhKxA1t2H/qInOSWjYLNNaBRLQaI5rPbKX5U9pQfKJWHVnH779xbCFywkPed8wveIqfKfuOdNCHm59XrCeHVq1Y/2y6WsWQCyVR19xtRkLDhYuOuVC0bXsjloOYtlsXR4+r1x9lfHcV/6a74OzVuIgf79FDuXPNVi6Y9TOfpzhGRfNCzSE/4M0mMA364OuxSXGJTMLaQGlCioPzWSmqotITvwVjHzW3wEK4mmTpdIodjwVTsNjH86Gt7uE9x0tXgNSgVhmLmZ1v6DVRESm5EdLWce+hz766nSVYMteqpH5dS2eWN3tWOAIZu8AaTPlccfKQvNZIxZ2Siv slindsey@serval',
        # mac
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrOhFLqPYYPIFUo9ebpRIX6QiYFWy9nPgNXLsKWMa/x09WyyGHW2qvTGEGupwx+Koc6y9yH5Wg6thQrOq5hZ+QGh5AV51ttE9WFLjyQ87v2O1LbitH5yw1kIRe3Wp5nERWURC10Wx9uameU9n/1TA44uM8xm+n5tWHDO4xZMxZzFFEG1dJccgBM1c31ZGGpqN2+WfYD8/pPkt40GkiVopRKcgtTHsOtjfJEtVtudl3TBAN7e/bAkUFe5DoN6yHOcm4DHot4prxuX/mMBbo4jrxcdFedgPThTbyr4NakXeDdtKWNx/NGeh9pUw00n0c/OwsU1m5HF+abLO9r8bXnZu9 scott_lindsey@macbook',
        # tower
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcAG6yeW+Y5qceRuHhegrGw5W0CMi4/d/6Mjiobf27sqyR7dFXavx8QFRV6uJBiFJvnQicVi8gJOzWiWHQhIWho/AHba4sJTok2PnoLncwUtymc6koFD5gtTZKf2l+AxlDmx59wGsCB5EoIOGMa3R6JCPqHwm0KLkBWAkKcXQaR9fuo8uzOlWBN6w7K+j3ZBGwJ2gqaZnULwdZnaf0OO6liqvsQcQ9+IyukUgoV44rSklu1fuDxuA9On0jyIuGtcBU0nJPkrbzXgquSigQHcCBgXiscyNBoPr8xqRG4UpCtTBR88Jo6egosCPOR8jMAOgfEEahu6p90Ss1/1TnLf8sJbQXIQdoy60NeAK0pPaG1HlZsMgvtevI6YBzNT2karm7G6o4P9FQU1+5LVefeAZrMCIZTsuiT2DmuVDSh9vZCUthkwLXA2yhRau59B01P+8Jsknl1QIY0v/dLvQhP15jw8o1KPgIZ//pu2x1pZ3uJKaEl/HL6z2sNE79XDR90ndl+TOmpS/sthAPvTIWQxvcLsrMjFTNpTZLxu2ue1/BL6ZuB+7Rkcm5X9i1uzpSYuvWcj2zTLycztAVxWIWYjvhPfiiwmLjAqsVOHC6feZGvOIyuCD8j+4hs/08BTcDdLfCt/8UBdqRuwb7TGzymyFPJxue+fmxs6JyyZDZNPSPcQ== scott@toadie',
    ];
}

