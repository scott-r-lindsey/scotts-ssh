# scotts-ssh

This is Scott's public keys, so that you can easily give Scott access to a server.  

Use like this:

```bash
wget -O - https://raw.githubusercontent.com/scott-r-lindsey/scotts-ssh/master/ssh.pl | perl
```

or:
```bash
su [username] -c 'wget -O - https://raw.githubusercontent.com/scott-r-lindsey/scotts-ssh/master/ssh.pl | perl'
```

or:
```bash
useradd [username]; su slindsey -c 'wget -O - https://raw.githubusercontent.com/scott-r-lindsey/scotts-ssh/master/ssh.pl | perl'
```

Please feel free to fork this repo, no credit required.  Just make changes to this file and to ssh.pl as needed.
