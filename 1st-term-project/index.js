#!/usr/bin/env node
'use strict'

const program = require('commander')
const fs = require('fs')
var csv = require('fast-csv')

let options = {
  headers: true
}

let analyze = function (file) {
  let collection = []
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      collection.push(data)
    })
    .on('end', function () {
      console.log(Object.keys(collection[1]))
      console.log('Number of procesable entries: ' + collection.length)
    })
  stream.pipe(csvStream)
}

let analyzeColumn = function (file, column) {
  var valueMapping = {}
  valueMapping.NoValueFound = 0
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      if (data[column] !== '') {
        valueMapping[data[column]] = (valueMapping[data[column]] || 0) + 1
      }
      else valueMapping.NoValueFound += 1
    })
    .on('end', function () {
      console.log(valueMapping)
    })
  stream.pipe(csvStream)
}

let analyzeMissingValues = function (file, column) {
  let noValueFound = 0
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      if (data[column] === '') {
        noValueFound += 1
      }
    })
    .on('end', function () {
      console.log('Empty records: ' + noValueFound)
    })
  stream.pipe(csvStream)
}

let reorder = function (file, column) {
  let collection = []
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      collection.push(data)
    })
    .on('end', function () {
      collection.sort(function (a, b) {
        return a[column] - b[column]
      })
      csv
       .writeToPath('out-r.csv', collection, options)
       .on('finish', function () {
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let searchColumn = function (file, column, value) {
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      if (data[column] === value) {
        console.log(data)
      }
    })
  stream.pipe(csvStream)
}

let searchDuplicates = function (file, column) {
  let collection = []
  let signatureCollection = []
  let signature = ''
  let row = {}
  let sign = function (key) {
    if (key !== column) signature = signature + row[key]
  }
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      signature = ''
      row = data
      Object.keys(data).forEach(sign)
      if (signatureCollection.indexOf(signature) === -1) {
        collection.push(data)
        signatureCollection.push(signature)
      } else {
        console.log('Found duplicate: ')
        console.log(data)
      }
    })
  stream.pipe(csvStream)
}

let removeMissing = function (file, column) {
  let collection = []
  let removed = 0
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      if (data[column].length > 0) {
        collection.push(data)
      }
      else removed++
    })
    .on('end', function () {
      csv
       .writeToPath('out-rm.csv', collection, options)
       .on('finish', function () {
         console.log('Removed: ' + removed)
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let removeDuplicates = function (file, column) {
  let collection = []
  let keys = []
  let removed = 0
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      if (keys.indexOf(data[column]) === -1) {
        collection.push(data)
        keys.push(data[column])
      }
      else removed++
    })
    .on('end', function () {
      csv
       .writeToPath('out-rd.csv', collection, options)
       .on('finish', function () {
         console.log('Removed: ' + removed)
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let removeValues = function (file, column, value) {
  let collection = []
  let keys = []
  let removed = 0
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      if (data[column] !== value) {
        collection.push(data)
        keys.push(data[column])
      }
      else removed++
    })
    .on('end', function () {
      csv
       .writeToPath('out-rv.csv', collection, options)
       .on('finish', function () {
         console.log('Removed: ' + removed)
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let switchConst = function (file, column, origValue, newValue) {
  let collection = []
  let replacedValues = 0
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      if (data[column] === origValue) {
        data[column] = newValue
        collection.push(data)
        replacedValues++
      } else collection.push(data)
    })
    .on('end', function () {
      csv
       .writeToPath('out-sc.csv', collection, options)
       .on('finish', function () {
         console.log('Replaced: ' + replacedValues)
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let fillConst = function (file, column, c) {
  let collection = []
  let modified = 0
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      if (data[column] === '') {
        data[column] = c
        collection.push(data)
        modified++
      }
    })
    .on('end', function () {
      csv
       .writeToPath('out-fc.csv', collection, {headers: true})
       .on('finish', function () {
         console.log('Modified: ' + modified)
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let fillMean = function (file, column, type) {
  let collection = []
  let c
  let modified = 0
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
    if (o[column] === '') {
      o[column] = c
      modified++
    }
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
       .writeToPath('out-fm.csv', collection, {headers: true})
       .on('finish', function () {
         console.log('Modified: ' + modified)
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

let fillMeanClass = function (file, column, classColumn, type) {
  let collection = []
  let c
  let cl = 0
  let modified = 0
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
    if (o[column] === '') {
      o[column] = Math.round(c[cl].value)
      modified++
    }
  }
  var stream = fs.createReadStream(file)
  var csvStream = csv(options)
    .on('data', function (data) {
      collection.push(data)
    })
    .on('end', function () {
      collection.sort(function (a, b) {
        if (a[classColumn] < b[classColumn]) return -1
        if (a[classColumn] > b[classColumn]) return 1
        return 0
      })
      if (type === '2') c = getMode(collection)
      else c = getMean(collection)
      collection.forEach(fillRow)
      csv
       .writeToPath('out-fmc.csv', collection, {headers: true})
       .on('finish', function () {
         console.log('Modified: ' + modified)
         console.log('Done!')
       })
    })
  stream.pipe(csvStream)
}

// let fillMeanClass2 = function (file, column, classColumn, type) {
//   let collection = []
//   let c
//   let cl = 0
//   let modified = 0
//   let getMode = function (arr) {
//     var classMapping = []
//     var currentClass = arr[1][classColumn]
//     var modeMapping = {}
//     var greatestFreq = 0
//     var mode
//     var appendClass = function (cClass, nClass) {
//       var classMode = {
//         class: cClass,
//         value: mode,
//         freq: greatestFreq
//       }
//       classMapping.push(classMode)
//       currentClass = nClass
//       modeMapping = {}
//       greatestFreq = 0
//     }
//     arr.forEach(function (o) {
//       if (o[column] !== '') {
//         modeMapping[o[column]] = (modeMapping[o[column]] || 0) + 1
//         if (greatestFreq < modeMapping[o[column]]) {
//           greatestFreq = modeMapping[o[column]]
//           mode = o[column]
//         }
//       }
//       if (currentClass !== o[classColumn]) {
//         appendClass(currentClass, o[classColumn])
//       }
//     })
//     appendClass(currentClass, null)
//     console.log(classMapping)
//     return classMapping
//   }
//   let getMean = function (arr) {
//     let classMapping = []
//     var currentClass = arr[1][classColumn]
//     var sum = 0
//     var count = 0
//     let appendClass = function (cClass, nClass) {
//       var classMean = {
//         class: cClass,
//         value: sum / count
//       }
//       classMapping.push(classMean)
//       currentClass = nClass
//     }
//     arr.forEach(function (o) {
//       if (o[column] !== '') {
//         if (currentClass !== o[classColumn]) {
//           appendClass(currentClass, o[classColumn])
//           sum = 0
//           count = 0
//         }
//         sum += parseFloat(o[column])
//         count++
//       }
//     })
//     appendClass(currentClass, null)
//     console.log(classMapping)
//     return classMapping
//   }
//   let fillRow = function (o) {
//     if (c[cl].class !== o[classColumn]) cl++
//     if (o[column] === '') {
//       o[column] = c[cl].value
//       modified++
//     }
//   }
//   var stream = fs.createReadStream(file)
//   var csvStream = csv(options)
//     .on('data', function (data) {
//       collection.push(data)
//     })
//     .on('end', function () {
//       collection.sort(function (a, b) {
//         return a[classColumn] - b[classColumn]
//       })
//       console.log(collection)
//       if (type === '2') c = getMode(collection)
//       else c = getMean(collection)
//       collection.forEach(fillRow)
//       csv
//        .writeToPath('out-fmc.csv', collection, {headers: true})
//        .on('finish', function () {
//          console.log('Modified: ' + modified)
//          console.log('Done!')
//        })
//     })
//   stream.pipe(csvStream)
// }

program
.command('analyze <file>')
.description('show headers and number of procesable entries')
.action(analyze)

program
.command('analyze-column <file> <column>')
.description('show values and its freq in a specified column')
.action(analyzeColumn)

program
.command('analyze-missing <file> <column>')
.description('Report how many values are missing in a specified column')
.action(analyzeMissingValues)

program
.command('reorder <file> <column>')
.description('Reorder by column')
.action(reorder)

program
.command('search-column-value <file> <column> <value>')
.description('search for entries with a specific value in the specified column')
.action(searchColumn)

program
.command('search-duplicates <file> <omitColumn>')
.description('search duplicates with all values, ommiting a column (like ID)')
.action(searchDuplicates)

program
.command('remove-missing <file> <column>')
.description('remove registers missing a value in a specified column')
.action(removeMissing)

program
.command('remove-duplicates <file> <column>')
.description('remove duplicates registers using a value in a specified column, will conserve the first one to appear in the file')
.action(removeDuplicates)

program
.command('remove-by-value <file> <column> <value>')
.description('remove registers using a value in a specified column')
.action(removeValues)

program
.command('switch-const <file> <column> <valueToReplace> <const>')
.description('fill some column select values with a constant')
.action(switchConst)

program
.command('fill-const <file> <column> <const>')
.description('fill a column missing values with a constant')
.action(fillConst)

program
.command('fill-mean <file> <column> <isNumeric>')
.description('fill a column missing values with the mean for numeric values or the mode for other types')
.action(fillMean)

program
.command('fill-mean-class <file> <column> <classColumn> <isNumeric>')
.description('fill a column missing values with the mean or mode, taking into account the class')
.action(fillMeanClass)

// program
// .command('fill-mean-2class <file> <column> <classColumn1> <classColumn2> <isNumeric>')
// .description('fill a column missing values with the mean or mode, taking into account two classes for calculating')
// .action(fillMeanClass2)

program.parse(process.argv)
if (program.args.length === 0) program.help()
