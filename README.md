Custom Sensu Plugins
====================

![sensu-logo](https://raw.githubusercontent.com/gogobot/custom-sensu-plugins/master/sensu-logo.png)

Custom Sensu plugins that we feel are too custom in order to contribute back to the community, either it's too tailored around our AWS infra or simply too "simplistic" around our use case, however, open source is open source, you might find those useful.

Feel free to for and use.

## List of plugins

### check-url-content-match.rb

This will check 2 URLS, one on the local box and one on the load balancer and compare the content, we do that in order to make sure that no server is lagging and hasn't received the new deployment.

We found that under heavy load sometimes deployment will fail to a specific server and we want to be alerted when that happens.

Example check syntax:

```
check-url-content-match.rb -b www.gogobot.com -h elb-some-id-of-your-elb.us-west-2.elb.amazonaws.com -s 0 -p /deployed-git-sha-string
```

## LICENCE

Read more under LICENSE.md, or know that it's MIT :)
