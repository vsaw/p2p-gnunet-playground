# Problem
<!--
	Messaging Protocols in genearl are cool, allow for scalable, reliable
	information exchange
-->

We plan to implement a reliable peer-to-peer messaging protocol on top of GNUnet
that could replace current centralized protocols like AMQP and MQTT.

It should have many of the desired properties of classical messaging protocols
like e.g.

- reliability
- low-latency
- decoupling of data-producers and consumers

without sacrificing the security, scalability or distributed nature of the
proposed system.


# Motivation
<!--
	Messaging Protocols all share a single point of failure: The borker. Let's
	get rid of the broker!
-->

Classical architecture use a central message broker that routes all the messages
transmitted within the system. This has a few downsides.


## Central point of failure
The broker as the main hub is a central point of failure. If the broker is not
available all the connected peers can not exchange information anymore.

Unfortunately brokers offer a large attack surface for degration/denial of
service attacks

- malicous peers could simply flood the broker by transmitting a large amount of
  packets
- the broker could be forced to transmitt unecessarily often by subscribing to
  all the messages exchanged by the broker
- bot networks could open a large amount of connections to the broker and thus
  overloading it


## Privacy concerns
As the central point of communication the broker is also a honeypot for
compromising the confidentiality of the exchanged messages. Wrong access control
lists could allow for message routing to untrusted peers. The broker itself
could also read the exchanged messages, or at least have a complete log of
meta-data of the communication.


## Scalibility
Current high performance brokers can handle up to a couple of thousand
(maybe 100) simultaneus connections while still allowing for decent message
latency. However growing any further than this is not feasible for most systems
<!--
	TODO: Quote or some external reference to show that I'm not making this up
-->


# Related Work
<!--
	**TODO Research this:**
	- How to establish Trust decetralized? -> see BitCoin, look for more
	- QoS - correctness: Compare to GNS p2p dns update records
	- QoS - timeliness: Find comparable protocol (on  p2p)
	- Properties of Messaging Protocols

	Some links:
	- http://blogs.vmware.com/vfabric/2013/02/choosing-your-messaging-protocol-amqp-mqtt-or-stomp.html
	- http://www.prismtech.com/opensplice/resources/white-papers
	- http://mqtt.org/
	- http://www.eejournal.com/archives/articles/20140324-rti/
-->


# Plan
<!--
	- Research, Model/Design Solution approach, learn about GNUnet
		- chose possible and desired features of classical Messaging Protocols
		  to bring to the wonderful world of p2p
	- Find solved sub-problems and transfer solution to our domain
	- Start Coding after there is a tight plan of the software to be build
-->
