# Scott's ssh public key installer

Maybe around the hundredeth time I installed public keys on a server, I decided I really ought to add some automation.  This is what I came up with.  

Use like so:

```bash
curl https://raw.githubusercontent.com/scott-r-lindsey/scotts-ssh/master/ssh.pl | perl
```

or:
```bash
su [username] -c 'curl https://raw.githubusercontent.com/scott-r-lindsey/scotts-ssh/master/ssh.pl | perl'
```

or:
```bash
useradd [username]; su slindsey -c 'curl https://raw.githubusercontent.com/scott-r-lindsey/scotts-ssh/master/ssh.pl | perl'
```

Please feel free to fork this repo, no credit required.  Just make changes to this file and to ssh.pl as needed.
