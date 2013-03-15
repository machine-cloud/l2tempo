curl -X POST --header 'Content-Type: application/logplex-1' -d "foo=bar" http://localhost:5000/logs
curl -X POST --header 'Content-Type: application/logplex-1' -d "device_id=logplex-test battery=100 temp=50 status=OK readings=true" http://localhost:5000/logs
