# README

## App setup

- Clone the repo
- Add a new entry your /etc/hosts

```
$ vim /etc/hosts
# add 127.0.0.1       myapp.com
$ dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```

- Run the server

```
$ rails s
$ open http://myapp.com
```

- Give the app the permissions with a Twitter account when prompted
