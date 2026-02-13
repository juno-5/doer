When you're ready to work on Doer again, run `vagrant up` (no need to
pass the `--provider` option required above). You will also need to
connect to the virtual machine with `vagrant ssh` and re-start the
Doer server:

```console
$ vagrant up
$ vagrant ssh

(doer-server) vagrant@vagrant:/srv/zulip$ ./tools/run-dev
```
