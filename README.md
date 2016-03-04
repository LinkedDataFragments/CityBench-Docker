# CityBench Executor
This Docker container can execute the CityBench benchmark for C-SPARQL, CQELS and TPF Query Streamer

```
docker build -t citybench . && docker run -it --rm -v $(pwd)/result_log/:/home/citybench/CityBench/result_log/ citybench
```

