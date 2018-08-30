# Lab Instructor Notes

This document collates notes on the course exercises.

## 1. Sign Up - Pivotal Web Services or Swisscom Application Cloud

### Common Issues

#### Network connectivity

As this is the first lab, this is when you discover that PWS is blocked by a corporate proxy!

_Resolution:_ Tether (everyone) to a mobile device or contact network administrators.

#### Existing accounts

Students may have work accounts, and then ignore instructions to create a new one, or accidentally use the wrong account.

_Resolution:_ Log out of everything, create a new browser user profile, or use private browsing sessions.

#### PWS activation emails expiring

They can only be viewed once, and if you sign up for a new account in a private window, and then try verifying your account in a window logged into another account, your activation will expire.

_Resolution:_ It may be easier to use instructor-provisioned accounts (see the `scripts` directory).

#### PWS requires SMS verification

This can be an issue when teaching an international audience (eg at a conference).

_Resolution:_ It may be easier to use instructor-provisioned accounts (see the `scripts` directory).

#### Swisscom web UI slowing down

The Swisscom web UI for sign-up has been known to slow down when an entire class has hit it at once.

_Resolution:_ It may be easier to use instructor-provisioned accounts (see the `scripts` directory), although this has only been tried for PWS.

## 2. CLI Basics

### Common Issues

#### Unable to install software

Windows users often have their permissions limited, preventing them from installing the CLI.

_Resolution:_ Pair with another student. The ability to install software is a class pre-requisite.

#### Account lock-outs

The UAA will lock an account if the wrong password is used three times in succession.

_Resolution:_ Wait an unspecified amount of time (try again after the next slides), or use an instructor-provided account.

#### Immediate login failure

An unexplained issue has been observed on Windows machines whereby the CLI will fail on `cf login` with an authentication issue without even prompting for a username/password.

_Resolution:_ Delete the contents of the `~/.cf` directory.
