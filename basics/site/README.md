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

## 3. Pushing Your First App

### Common Issues

#### Being in the wrong directory

Many users are command-line novices, and end up pushing from the wrong directory. Symptoms will be either the CLI unexpectedly asking for an app name (because there is no manifest in the directory), or incredibly slow pushes (because the CLI is trying to upload the user's entire home directory).

_Resolution:_ Draw common filesystem navigation commands on the whiteboard.

#### Wrong version of the CLI

The symptoms of this are typically errors about unknown flags. If you seen unexpected behaviour, check the user's CLI version.

_Resolution:_ Ensure the student has the latest CF CLI release.

#### Users getting stuck tailing logs

Users may run `cf logs` which tails, and either think it hasn't worked because an app isn't logging, or may not know how to exit.

_Resolution:_ CTRL+C

## 4. Buildpacks

### Common Issues

#### `cf ssh` appearing to hang on Windows

Some terminal emulators on Windows particularly (including Git Bash's bundled emu) don't display a prompt when `cf ssh` has successfully connected, making it _look_ like the command is hanging.

_Resolution:_ None needed.

#### Students don't understand how to explore the running container

Novice command-line users may need some help navigating the filesystem, and an explanation of what the files present _mean_.

_Resolution:_ Draw common filesystem navigation commands on the whiteboard; discuss file differences in the recap.

## 5. Availability

### Common Issues

This lab tends to go smoothly - the only likely problems are to do with pushing apps from the wrong directory.

## 6. Debugging

### Common Issues

#### New Relic data takes a long time to appear

Sometimes data and charts don't appear in the New Relic dashboard in a timely fashion.

_Resolution:_ Wait, or move on. It shouldn't take more than a few minutes, and certainly not more than fifteen.
