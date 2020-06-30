---
title: linux_variables
date: 2020-06-02 02:00:10
tags:
---


### How do I add environment variables?

- To set variable only for current shell:

`VARNAME="my value"`

- To set it for current shell and all processes started from current shell:

`export VARNAME="my value" `
*shorter, less portable version*

- To set it permanently for all future bash sessions add such line to your .bashrc file in your $HOME directory.

- To set it permanently, and system wide (all users, all processes) add set variable in /etc/environment:

`sudo -H gedit /etc/environment`

This file only accepts variable assignments like:

`VARNAME="my value"`

Do not use the export keyword here.

You need to logout from current user and login again so environment variables changes take place.