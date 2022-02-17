# README

## Architecture

An application like this one might be used the most right before the start of any course. At that moment the most amount of students would be browsing for courses and subscribing to them. The rest of the time, it might have a much lower request rate.
Being that the case, the amount of instances of the app shoud scale up or down according to that demand. If hosted on a cloud, the service should provide sufficient tools to keep track of how many instances are running at a given time.

## Performance metrics

An application like this one, should be accompanied by some observations systems:

 - Error logging: A system like sentry or rollbar to monitor errors happening in production is a must for rails applications. Otherwise, the app could be failing and the development team would be blind to it.
 - Performance logging: If the architecture needs to be upgraded, we need a system like Data Dog or New Relic to obtain metrics about memory usage and procesing power usage, RPMs, database lookup time, etc.
 - Request logging: A system such as kibana would be necessary to keep track of the requests sent by the front-end to debug possible errors. It is also a source for the RPM metric, as well know if too many 4xxs errors are returned.
