const fs = require('fs')
const exec = require('child_process').exec
const CHECK_INTERVAL = 5 * 60

const Config = require('./config')

function checkRig() {
  let status = fs.readFileSync(Config.status_file)
  let allCommands = Config.commands
  for (command in allCommands) {
    let executeContent = allCommands[command]
    if (status.indexOf(command) != -1 )
    {
      exec(executeContent)
      break
    }
  }
}

setInterval(checkRig, CHECK_INTERVAL * 1000)

console.log('Start EthOS Monitoring...')
console.log('Check Interval is ' + CHECK_INTERVAL + ' seconds')

checkRig()