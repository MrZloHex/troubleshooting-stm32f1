# Simple instruction

1. Clone repo
```sh
$ git clone https://github.com/MrZloHex/troubleshooting-stm32f1.git
```

2. Change working directory
```sh
$ cd troublshooting-stm32f1
```

3. Install all needful packages
```sh
$ ./install.sh
```

4. Run program for testing
```sh
$ ./test_stm32.sh [DEVICE ID]
```

5. Copy folder for trasmiting to us

# Results

In repo directory after running tests, will be created subdirectory `results` with one more directory with name `device_<ID>`, where `<ID>` is a number which you specifed by passing it at running tests.</br>
E.g.: running like this
`
$ /test-stm32.sh 34
`
would create directory with name `device_34`.

# Complex instruction
