# Flynn Certbot Standlone
This repo was forked from https://github.com/nrempel/flynn-certbot.

This tool can help you automatically issue and renew SSL certificates and secure Flynn routes for related domains. The tool uses [Let's Encrypt](https://letsencrypt.org) to generate certificates.

Pull requests with improvements are welcome. For significant changes, create an issue first to discuss the topic.

## Caveats

I'm using this tool right now and it works for me but it is not well tested. I would recommend reading the script before following these instructions.

Currently, this only works for clusters hosted on Digital Ocean.

Since Flynn does not support persistent volumes, every time the process starts it issues a certificate then begins watching to renew the certificate. Due to [Let's Encrypt rate limits](https://letsencrypt.org/docs/rate-limits/), this can only happen 20 times per week.

Scaling the process will trigger this. Changing environment variables will trigger this. Deployments will trigger this. I recommend double checking your configuration is correct before scaling up the process.

If you scale deployment past a single process, you may see problems.

You've been warned!

## Setup

Clone this repository.

Run `./deploy_certbot_app.sh` and follow the instructions.

If everything goes well, the domain `$DOMAIN` should now support https routes with a valid certificate!

