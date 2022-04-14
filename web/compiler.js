const peg = require("./pegjs/kla.js");

function makeUseableVar(origin) {
    if (origin[0] == 'var') {
        return 'getVarValue\n' + origin[1]
    }
    return origin[1]
}

function compile(code) {
    let parsedCode = peg.parse(code)
    let resultCode = ''

    function addCode(content) {
        resultCode += content + '\n'
    }

    let lineCount = 0
    let variables = {}

    for (const line of parsedCode) {
        lineCount++

        if (line[0] == "import") {
            if (line[1][0] !== 'str' && line[1][0] !== 'var') {
                console.log(lineCount, "TypeError: Imported module must be string or var", line[0])
            }

            if (line[1][0] == 'var') {
                if (!variables[line[1][1]]) {
                    console.log(lineCount, "NotFoundException: Variable does not exist.", line[0])
                    return
                }
                addCode('#import ' + variables[line[1][1]])

            } else {
                addCode('#import ' + line[1][1])
            }
        }

        if (line[0] == "wait") {
            addCode('wait local time')
            addCode(makeUseableVar(line[1]))
        }

        if (line[0] == "set") {
            if (variables[line[1][1]]) {

                addCode('game.local.var=')
                addCode(line[1][1])
                addCode(line[2][1])

                variables[line[1][1]] = line[2][1]

            } else {
                addCode('game.local.var+')
                addCode(line[1][1])
                addCode('0')

                addCode('game.local.var=')
                addCode(line[1][1])
                addCode(makeUseableVar(line[2]))

                variables[line[1][1]] = line[2][1]
            }
        }

        if (line[0] == "set_playerPosX") {
            addCode('set player.x')
            addCode(makeUseableVar(line[1]))
        }

        if (line[0] == "set_playerPosY") {
            addCode('set player.y')
            addCode(makeUseableVar(line[1]))
        }

        if (line[0] == "run_js") {
            addCode('OpenShapes run JavaScript')
            addCode(makeUseableVar(line[1]))
        }
    }

    return resultCode
}

function recompile() {
    try {
        document.getElementById('codeOutput').value = compile(document.getElementById('codeEditor').value)
    } catch (e) {
        document.getElementById('codeOutput').value = 'Compile Error: \n' + e
    }
}

document.getElementById('codeEditor').oninput = function() {
    recompile()
}

recompile()