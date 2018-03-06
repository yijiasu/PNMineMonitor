'use strict';

var fs = require('fs');
var exec = require('child_process').exec;
var CHECK_INTERVAL = 5 * 60;

var Config = require('./config');

function checkRig() {
  var status = fs.readFileSync(Config.status_file);
  var allCommands = Config.commands;
  for (command in allCommands) {
    var executeContent = allCommands[command];
    if (status.indexOf(command) != -1) {
      exec(executeContent);
      break;
    }
  }
}

setInterval(checkRig, CHECK_INTERVAL * 1000);

console.log('Start EthOS Monitoring...');
console.log('Check Interval is ' + CHECK_INTERVAL + ' seconds');

checkRig();