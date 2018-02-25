# Vagabond (Under Heavy Development)

![Vagabond Image][logo]

[logo]: https://img2.picload.org/image/dadldcwa/vagabond.jpg "Vagabond"

Simple But Powerful WebServer Maker For PHP Projects


## Simple Example
```sh
$ vag   
```

#### it will boots up nginx and php-fpm on default localhost:8000/ based on current directory


## Other Examples
```sh
$ vag -s localhost -p 9000  
```
```sh
$ vag -p 9000  
```

## Installation

### Through Wget

```sh
$ sh -c "$(wget https://raw.githubusercontent.com/nerdial/Vagabond/master/install.sh -O -)" 
```

### Through Curl

```sh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/nerdial/Vagabond/master/install.sh)"  
```


## Available Options

available options you may use with Vag command:

| --option  | -shortcut | Description  |
| --------- |:---------:|:------------|
| --help   | **-h**   | shows the help|
| --server | **-s**   | defines which host project should run on, default=localhost|
| --port   | **-p**   | application port  ,default=8000|
| --default| **-d**   | uses php built-in webserver instead|
| --root   | **-r**   | set application root ,default=current directory|
| --version| **-v**   | shows the version of vagabond|
| --ini    | **-i**   | specify .ini file for php-fpm or php built-in server ,default=looks for php.ini in the current directory,if could not find any, i will use default file located in /etc/vag/php.ini|

