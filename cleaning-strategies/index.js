#!/usr/bin/env node
'use strict'

const program = require('commander')
const fs = require('fs')
var csv = require('fast-csv')

let options = {
  headers: true
}

let remove = function (file, column) {
  let collection = []
  let finalCollection = []
  let collect = function (row) {
    if (row[column].length > 0) finalCollection.push(row)
  }
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      collection.push(data)
    })
    .on('end', function () {
      collection.forEach(collect)
      csv
       .writeToPath('out1.csv', finalCollection, options)
       .on('finish', function () {
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let replConst = function (file, column, c) {
  let collection = []
  let finalCollection = []
  let fill = function (row) {
    if (row[column] === '') row[column] = c
    finalCollection.push(row)
  }
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      collection.push(data)
    })
    .on('end', function () {
      collection.forEach(fill)
      csv
       .writeToPath('out2.csv', finalCollection, {headers: true})
       .on('finish', function () {
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let replMean = function (file, column, type) {
  let collection = []
  let c
  let getMode = function (arr) {
    var modeMapping = {}
    var greatestFreq = 0
    var mode
    arr.forEach(function (o) {
      if (o[column] !== '') {
        modeMapping[o[column]] = (modeMapping[o[column]] || 0) + 1
        if (greatestFreq < modeMapping[o[column]]) {
          greatestFreq = modeMapping[o[column]]
          mode = o[column]
        }
      }
    })
    console.log('Mode' + mode)
    return mode
  }
  let getMean = function (arr) {
    var sum = 0
    var count = 0
    arr.forEach(function (o) {
      console.log(0)
      if (o[column] !== '') {
        sum += parseFloat(o[column])
        count++
      }
    })
    console.log(sum + '/' + count)
    return (sum / count)
  }
  let fillRow = function (o) {
    if (o[column] === '') o[column] = c
  }
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      collection.push(data)
    })
    .on('end', function () {
      if (type === '2') c = getMode(collection)
      else c = getMean(collection)
      collection.forEach(fillRow)
      csv
       .writeToPath('out3.csv', collection, {headers: true})
       .on('finish', function () {
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let replMeanClass = function (file, column, classColumn, type) {
  let collection = []
  let c
  let cl = 0
  let getMode = function (arr) {
    var classMapping = []
    var currentClass = arr[1][classColumn]
    var modeMapping = {}
    var greatestFreq = 0
    var mode
    var appendClass = function (cClass, nClass) {
      var classMode = {
        class: cClass,
        value: mode,
        freq: greatestFreq
      }
      classMapping.push(classMode)
      currentClass = nClass
      modeMapping = {}
      greatestFreq = 0
    }
    arr.forEach(function (o) {
      if (o[column] !== '') {
        modeMapping[o[column]] = (modeMapping[o[column]] || 0) + 1
        if (greatestFreq < modeMapping[o[column]]) {
          greatestFreq = modeMapping[o[column]]
          mode = o[column]
        }
      }
      if (currentClass !== o[classColumn]) {
        appendClass(currentClass, o[classColumn])
      }
    })
    appendClass(currentClass, null)
    console.log(classMapping)
    return classMapping
  }
  let getMean = function (arr) {
    let classMapping = []
    var currentClass = arr[1][classColumn]
    var sum = 0
    var count = 0
    let appendClass = function (cClass, nClass) {
      var classMean = {
        class: cClass,
        value: sum / count
      }
      classMapping.push(classMean)
      currentClass = nClass
    }
    arr.forEach(function (o) {
      if (o[column] !== '') {
        if (currentClass !== o[classColumn]) {
          appendClass(currentClass, o[classColumn])
          sum = 0
          count = 0
        }
        sum += parseFloat(o[column])
        count++
      }
    })
    appendClass(currentClass, null)
    console.log(classMapping)
    return classMapping
  }
  let fillRow = function (o) {
    if (c[cl].class !== o[classColumn]) cl++
    if (o[column] === '') o[column] = c[cl].value
  }
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      collection.push(data)
    })
    .on('end', function () {
      collection.sort(function (a, b) {
        return a[classColumn] - b[classColumn]
      })
      console.log(collection)
      if (type === '2') c = getMode(collection)
      else c = getMean(collection)
      collection.forEach(fillRow)
      csv
       .writeToPath('out4.csv', collection, {headers: true})
       .on('finish', function () {
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

program
.command('remove <file> <column>')
.description('remove registers missing a value in a specified column')
.action(remove)

program
.command('repl-const <file> <column> <const>')
.description('fill a column missing values with a constant')
.action(replConst)

program
.command('repl-mean <file> <column> <isNumeric>')
.description('fill a column missing values with the mean for numeric values or the mode for other types')
.action(replMean)

program
.command('repl-mean-class <file> <column> <classColumn> <isNumeric>')
.description('fill a column missing values with the mean for numeric values or the mode for other types, taking into account the class')
.action(replMeanClass)

program.parse(process.argv)
if (program.args.length === 0) program.help()
