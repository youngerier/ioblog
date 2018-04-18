const fs = require('fs')


async function func1() {
    console.log(1)
    await fs.readFile("./cs/a.txt", { flag: 'r+', encoding: 'utf-8' }, (err, content) => {
        console.log(content)
    })
    console.log(2)
}

function func2() {
    console.log(3)
    fs.readFile("./cs/a.txt", { flag: 'r+', encoding: 'utf-8' }, (err, content) => {
        console.log(content)
    })
    console.log(4)
}


func1()
console.log("------------------------")
func2()