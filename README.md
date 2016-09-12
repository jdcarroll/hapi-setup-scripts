# hapi-setup-scripts
Full Stack Deployment scripts for Hapi js

## Frameworks and libraries built in

* Hapi Js
* Angular
* Inert
* Good Console

## Installation

Make sure that you add the following to your .bashrc or .bash_profile to activate functions.


```
source PATH_TO/hapi-setup-scripts/hapi-setup.sh
source PATH_TO/hapi-setup-scripts/hapi-clean.sh
```

At this point simply resource your .bashrc or .bash_profile

```
$ source ~/.bash_profile
```

## Usage

### hapiSetup

To Setup a project simply invoke the function and pass it two arguments the project name and the port the project is running on.

```
$ hapiSetup PROJECT_NAME PORT_NUMBER
```

### hapiClean

The purpose of hapiClean is to verify that all gulp tasks and servers are indeed killed and it will clean your process table. This is a backup utility and meant to simplify the the kill process if necessary.

```
$ hapiClean
```
