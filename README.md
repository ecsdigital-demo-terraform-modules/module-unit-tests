# Module Unit Test

## Introduction

The code provided in this repo is to demonstrate the capabilites of *terratest*, a Go library that make it easier to write automated tests for your infrastructure code.

The tests currently configured are straight forward and are provided as a foundation to build upon.

These tests are intended to be used with the terrafor modules located here:

https://github.com/ecsdigital-demo-terraform-modules 

## Tests Executed

1. Confirms the correct number of subnets are created.
2. Checks that the private subnet is private.
3. Checks that the public subnet is public.

## How to run the tests

Ensure the *terratest* requirements are met. (See link below)

Clone this repository.

Create an environment variable call *GOPATH* that points to the top level repository folder.

```
export GOPATH=/path/to/module-unit-tests
```

*cd** into the *unit-tests* directory.

Initialise the dependencies, run:

```
dep init
```

Run the unit tests:

```
go test -v -run .
```

Sample Output:

```
...

--- PASS: TestTerraformAwsBasicNetwork (94.91s)
PASS
ok      unit-tests      94.934s

```


## Resources

Terratest - https://github.com/gruntwork-io/terratest