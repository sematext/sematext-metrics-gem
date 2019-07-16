# This repo has been deprecated

# sematext-metrics gem[![Build Status](https://travis-ci.org/sematext/sematext-metrics-gem.png)](https://travis-ci.org/sematext/sematext-metrics-gem)

Ruby gem for sending [Custom Metrics](https://sematext.atlassian.net/wiki/display/PUBSPM/Custom+Metrics) to [SPM](http://sematext.com/spm/index.html).

## Installation

Add this line to your application's Gemfile:

    gem 'sematext-metrics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sematext-metrics

## Usage

Initialize client:

    Sematext::Metrics.initialize("[token]")

Send datapoint:

    Sematext::Metrics.send(
      :timestamp => 1370969400767,
      :name => 'coffee-consumed',
      :value => 1000,
      :agg_type => :sum,
      :filter1 => 'floor=1',
      :filter2 => 'machine=1'
    )

Batch sending:

    datapoints = [{
      :name => 'coffee-consumed', 
      :value => 10,
      :agg_type => :sum,
      :filter1 => 'floor=1',
      :filter2 => 'machine=1'
    }, { 
      :name => 'coffee-consumed',
      :value => 11,
      :agg_type => :sum,
      :filter1 => 'floor=1',
      :filter2 => 'machine=2'
    }]

    Sematext::Metrics.send_batch datapoints    

## Configuration

To use different tokens for different applications, use `sync` or `async` factory method to instantiate a new client:

    user_metrics = Sematext::Metrics::Client.sync("[elasticseach_app_token]")
    search_metrics = Sematext::Metrics::Client.sync("[web_app_token]")

    #send data
    user_metrics.send_batch user_datapoints
    search_metrics.send_batch search_datapoints

To send metrics to on-premises SPM setup you can also configure endpoint url:

    user_metrics = Sematext::Metrics::Client.sync("[token]", "http://spm-receiver.example.com/spm-receiver/custom/receive.raw")
    search_metrics = Sematext::Metrics::Client.async("[token]", "http://spm-receiver.example.com/spm-receiver/custom/receive.raw")

or

    Sematext::Metrics.initialize("[token]", :receiver_url => "http://spm-receiver.example.com/spm-receiver/custom/receive.raw")

## Asynchronous sending

Client can send data asynchronously using `em-http-request` extension for [EventMachine](http://http://rubyeventmachine.com/). 
In order to use this extension add  `em-http-request` gem to your application manually. Ensure EventMachine's reactor loop is running:

    Thread.new { EventMachine.run }

Asynchronous data sending can be configured during initialization:

    Sematext::Metrics.initialize("[token]", :async => true)

Or use `async` factory method to create a client instance:

    client = Sematext::Metrics::Client.async("[token]")

## Further reading

[SPM Custom Metrics Wiki](https://sematext.atlassian.net/wiki/display/PUBSPM/Custom+Metrics).

## License

Copyright 2013 Sematext Group, Inc.

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0

