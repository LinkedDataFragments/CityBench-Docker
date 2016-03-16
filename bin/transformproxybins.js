#!/usr/bin/env node
var fs = require('fs');

process.stdin.setEncoding('utf8');

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
  config.binsTotalBytes.forEach((e) => console.log(e));
});
