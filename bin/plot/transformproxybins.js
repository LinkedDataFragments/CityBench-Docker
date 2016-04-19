#!/usr/bin/env node
var fs = require('fs');

process.stdin.setEncoding('utf8');

var binsize=1000;//ms
var divisor=1024;//KB

var body = '';
process.stdin.on('readable', () => {
  var chunk = process.stdin.read();
  if (chunk !== null) {
      body += chunk;
  }
});

process.stdin.on('end', () => {
  var config = JSON.parse(body);
  console.log("bytes");
  var tocollect=binsize/config.binLength;
  var collected=0;
  var collectsum=0;
  config.binsTotalBytes.forEach((e) => {
      collectsum += e;
      if(collected++ >= tocollect) {
          collected = 0;
          console.log(collectsum/divisor);
          collectsum = 0;
      }
  });
  if(collected > 0) {
      console.log(collectsum/divisor);
  }
});
