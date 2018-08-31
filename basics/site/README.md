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

### Answers

#### How can you access your web app?

Open the URL in a web browser.

#### What differences are there in the manifest? Why are these needed?

`no-route: true`, to prevent Diego from treating the app as a web app and marking it as crashed for not listening on `$PORT`.

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

Students who aren't particularly technical may not get so much benefit from this exercise, and will need extra guidance to recognise the value provided by buildpacks.

### Answers

#### If you don’t specify a buildpack, what is the first one that will be tested for?

The one at the top of the list.

#### How can you check that you pushed your app successfully?

Access it in a browser, or use `cf app`.

#### How does the running droplet compare to your app directory?

Amongst other things, it moves the `index.html` file and adds NGiNX and associated config.

#### Why is CF able to scale instances so quickly?

Because the droplet is already built, and possibly already exists in the cache of each Diego cell.

#### Which buildpack do you think will be used to run this app? Staticfile, or PHP?

Whichever of the two is higher in the list.

#### What happens this time? Why?

NGiNX doesn't understand how to render PHP, so sends headers that prompt the browser to treat it as a file download.

### Common Issues

#### `cf ssh` appearing to hang on Windows

Some terminal emulators on Windows particularly (including Git Bash's bundled emu) don't display a prompt when `cf ssh` has successfully connected, making it _look_ like the command is hanging.

_Resolution:_ None needed.

#### Students don't understand how to explore the running container

Novice command-line users may need some help navigating the filesystem, and an explanation of what the files present _mean_.

_Resolution:_ Draw common filesystem navigation commands on the whiteboard; discuss file differences in the recap.

## 5. Availability

### Answers

#### Can you see it in the “crashed” state before Cloud Foundry restarts it?

Probably not. If Diego is having a good day, on the first crash, it should restart the app almost immediately.

#### What happens if you make a request whilst they are all down?

The GoRouter returns a 404.

### Common Issues

This lab tends to go smoothly - the only likely problems are to do with pushing apps from the wrong directory.

## 6. Debugging

If the New Relic section is attempted, this is likely the longest lab of the course.

### Answers

#### What does Cloud Foundry think the health of the app is? How did it draw this conclusion?

Cloud Foundry thinks the app is healthy, because the default healthcheck is merely to check that the app is listening on the given port. It is likely that we will want to know if our web app is only returning 500 errors, hence the change to a HTTP-based healthcheck.

#### How do the two compare? What help does Cloud Foundry give you in determining the cause of failure?

The events should differ based on the nature of the crash; however the exact output differs as Garden/Diego change.

#### What happens? Is this what you expected?

Exhausting the disk does _not_ immediately crash an app. It is considered a recoverable situation, so the platform does not terminate the app. The app may, however, crash of its own accord by merit of having no disk space.

### Common Issues

#### New Relic data takes a long time to appear

Sometimes data and charts don't appear in the New Relic dashboard in a timely fashion.

_Resolution:_ Wait, or move on. It shouldn't take more than a few minutes, and certainly not more than fifteen.

## 7. Dealing with State

This lab has many steps, and as a result is one of the longer ones.

### Answers

#### Does this work immediately? If not, why not? What commands can you use to find out more?

No. The app needs to be started, but the CLI will ask the user to restage, which will fail because the app has never staged. Neither the CLI nor CAPI team wanted to fix this behaviour when asked.

#### What commands can you use to tell if you’ve bound the service instance to the correct app?

`cf services` is the easiest answer.

#### What will happen when we unbind the app?

No data is lost.

#### Can you use cf delete-service redis?

No, as it is still bound to the app. Unbind it first.

### Common Issues

#### Students misunderstand parameters

Students sometimes don't understand the name parameter.

_Resolution:_ Make sure to explain that they can name the service instance whatever they like, for example "_You might store user data in it, and call it `users`._"

#### Provisioning on Swisscom times out

Sometimes service provisioning has been observed to time out after 10 minutes. The operation cannot be cancelled.

_Resolution:_ Contact Swisscom if this issue is seen, and the only option is to wait.

## 8. Routes

This exercise is often quite long, and students are confused by the route-mapping. It may help to draw the route-mapping on a whiteboard, linking routes and apps with arrows.

### Answers

#### Does the push work? If not, why not? Can you fix this with a commandline argument?

No, as the route is probably already-taken. The student should use the `--random-route` functionality.

#### Could you leave the v1.0 app running in case you need to roll-back?

Yes.

### Common Issues

#### Arguments in the wrong order

The argument order in `cf create-route` and `cf map-route` are counter-intuitive:

`cf create-route space domain.com --hostname www`

The thing that usually appears on the left (`www`) appears on the right in the command, and the command misuses terminology.

_Resolution:_ Explicitly highlight this confusing issue on a white board.
