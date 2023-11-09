title: How to deploy Haunt site on sourcehut pages
date: 2023-11-08 20:04
tags: metablogging, haunt, guile, guix, sourcehut
style: little
---

How is this site deployed?

It's hosted on [sourcehut pages](https://srht.site/) and build straight from the repository.

What are sourcehut pages?

It's a service that allows you to host static websites. It's a part of
broader [sourcehut](https://sourcehut.org/) ecosystem.

Is it free?

It is free if you build your website locally and upload it to sourcehut pages.

And if you want to build it on sourcehut?

Then you need to have a paid account to use another part of sourcehut
ecosystem - [build service](https://man.sr.ht/builds.sr.ht/).

What is the advantage of building on sourcehut?

We will get to that. First, let's see how to upload locally built website to
sourcehut pages.

Do we follow
the [official Haunt 
documentation](https://dthompson.us/manuals/haunt/index.html)?

Yes, we do. We just run `haunt build`

With [default configuration](https://dthompson.us/manuals/haunt/Sites.html) that
produces `site` directory with all the files. Is it enough?

We need to create a `tar.gz` archive from that directory. We can do it
with `tar -czf site.tar.gz site` command

How do we upload it to sourcehut?

The easiest way is to use `hut` cli tool.

How to install it?

Check your distribution. For example, it is packaged [for 
Guix](https://packages.guix.gnu.org/packages/hut/0.2.0/) and also [for 
Arch](https://archlinux.org/packages/extra/x86_64/hut/).

What if it is not my case?

Follow the [instructions](https://sr.ht/~emersion/hut/) how to build and install
it from source. It's not that scary.

What is the next step?

You need to run `hut init` command to initialize hut. Follow the instructions
and provide your OAuth token.

Where do I get the OAuth token?

Go to your sourcehut [account settings](https://meta.sr.ht/oauth2) and create a
new OAuth token.

Are we ready to upload our website?

Almost, but we need to decide if it is going to use default domain provided by
sourcehut or custom domain.

What is the default domain?

It is `yourusername.srht.site`

What if I already have a custom domain?

Then you need to add a CNAME record to your DNS configuration. It should point
to `pages.sr.ht.`

What if it is a naked domain?

Then you need to add an A record to your DNS configuration. As for today, it 
should point to `173.195.146.139` but that [may change in the 
future](https://srht.site/custom-domains).

Ok, I know what domain to use. How do I upload my website?

Run `hut push -d yourusername.srht.site site.tar.gz` command. Replace 
`yourusername.srht.site` with your custom domain if you have one.

Is it all?

Yes, it is. You can now check your website at `yourusername.srht.site` or on
your custom domain.

What about the ssl certificate?

It's provided for your site by sourcehut automatically.

So, what about the fully automated build and deployment?

We need to use build service that, as we mentioned before, requires paid
account.

Is it worth it?

You can decide for yourself. I'm not going to convince you, but the minimal plan
is $2/month.

Ok, let's do it. How do I start?

You need to create a remote repository on sourcehut. When you push to it, it
will trigger a build.

I already have my website repository on some other git forge. How to add
sourcehut remote?

Run `git remote add sourcehut git@git.sr.ht:~yourusername/my-site-repo` command.
Modify it to match your details.

If I push to sourcehut remote, will it trigger a build?

No, you need to add `.build.yml` file to your repository. It should contain
build instructions.

What to put there?

Take a look at
the [build file of this 
site](https://git.sr.ht/~filiplajszczak/filip-lajszczak-dev/tree/master/item/.build.yml).
It has all the necessary parts.

It looks like it's running Guix.

Neat, isn't it? It's a Scheme all the way down.

How to trigger a build?

Just push to sourcehut remote. It will not only trigger a build but also provide
a link to the build log.

What if build fails for some reason?

The great thing about sourcehut is that you have four hours to ssh into the build
machine and debug it.

Why that blog looks so weird?

We explained it
in [obligatory metablogging 
post](https://filip.lajszczak.dev/obligatory-metablogging-post.html).