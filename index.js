#!/usr/bin/env node

const exec = require("child_process").exec
const prettier = require("prettier")
const [node, script, html_type, read_url, write_url] = process.argv

if (!read_url) {
  console.log("请输入读文件路径")
  return
}
if (!write_url) {
  console.log("请输入写文件路径")
  return
}
exec(
  `perl ${__dirname}/go.pl ${html_type} ${read_url} ${write_url}`,
  (err, stdout, stderr) => {
    if (err) {
      console.log(err)
      return
    }
    if (stderr) {
      console.log(`Error: ${stderr}`)
    }
    console.log(`${stdout}`)
  }
)
