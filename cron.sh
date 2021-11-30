#!/bin/bash
curl -s http://localhost:9100/metrics | curl --data-binary @- http://210.68.203.26/metrics/job/oecusse1_VM1node/instance/oecusse1_VM1node/NODE/oecusse1_VM1/ENV/oecusse1_VM1
curl -s http://localhost:8307/prometheus | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/GEE_oecusse1/instance/GEE_oecusse1/GEE/oecusse1/ENV/oecusse1
curl -s http://localhost:9080/prometheus | curl --data-binary @- http://pushgateway.insynerger.com/metrics/job/CS_oecusse1/instance/CS_oecusse1/CS/oecusse1/ENV/oecusse1
