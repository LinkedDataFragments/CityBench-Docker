FROM onsdigital/java-node-component

# Install location
ENV rundir /home/citybench

# Install git
RUN apt-get update && apt-get install -y git make gawk

# Download files
WORKDIR ${rundir}
RUN git clone https://github.com/rubensworks/Benchmark.git CityBench
RUN git clone https://github.com/rubensworks/TPFStreamingQueryExecutor.git

# Prepare files
RUN cd CityBench && ./gradlew fatJar
RUN cd TPFStreamingQueryExecutor && npm install --ignore-scripts

# Add benchmark script
ADD run_benchmark.sh .
RUN mkdir -p CityBench/CQELS_DB

# Run the benchmark(s)
ENTRYPOINT ["/bin/bash", "run_benchmark.sh"]
