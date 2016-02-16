/* Mips assembly grammer */

%{
    /* read in a configuration file containing instructions */
    var instructionset = require('./instructionset');
    var assembler = require('./assemble').assembler;

    /* Human readable register mapping */
    var registers = ['$zero', '$at', '$v0', '$v1', '$a0', '$a1', '$a2', '$a3',
    '$t0', '$t1', '$t2', '$t3', '$t4', '$t5', '$t6', '$t7', '$s0', '$s1', '$s2',
    '$s3', '$s4', '$s5', '$s6', '$s7', '$t8', '$t9', '$k0', '$k1', '$gp', '$sp',
    '$fp', '$ra'];

    /**
     * Takes a human readable register name and finds the number mapping to it.
     * @param Human readable register name.
     * @return Returns the register number if it exists, else -1.
     */
    function regNameToRegNum(reg) {
        var found = -1;
        for (var i = 0; i < registers.length; ++i) {
            if (registers[i] === reg) {
                found = i;
                break;
            }
        }
        return found;
    }

    function containsInstruction(mnemonic, instructionset) {
        var instruction = null;
        for (var i in instructionset) {
            if (instructionset[i].name == mnemonic) {
                instruction = instructionset[i];
                break;
            }
        }
        return instruction;
    }

    function assemble(yy, instruction, values) {
        var lineno = yy.lexer.yylineno;
        // console.log(yy);
        if (instruction !== null && instruction.fields.length == values.length) {
            // Make locations to store values
            var machinecode = 0;
            var positions = {
                rd: 0x0,
                rs: 0x0,
                rt: 0x0,
                shamt: 0x0,
                immediate16: 0x0,
                address26: 0x0
            };
            // Begin looping through the field
            for (var f in instruction.fields) {
                var field = instruction.fields[f];
                var value = 0;
                if (values[f][0] === '$') {
                    value = regNameToRegNum(values[f]);
                } else if (values[f][0] === '0' && values[f][0] === 'x') {
                    value = parseInt(values[f], 16);
                } else {
                    value = parseInt(values[f], 10);
                }
                // Assign the value to the field
                positions[field] = value;
            }
            // Now build the instruction based on the type
            if (instruction.type.name === 'r') {
                machinecode = assembler.createRType(
                    parseInt(instruction.type.opcode, 16),
                    positions.rd,
                    positions.rs,
                    positions.rt,
                    positions.shamt,
                    parseInt(instruction.type.func, 16)
                );
                console.log('0x' + machinecode.toString('16'));
            } else if (instruction.type.name === 'i') {
            } else if (instruction.type.name === 'j') {
            } else {
                // TODO: Malformed format in instruction config file
            }
        } else if (instruction === null) {
            // console.log("ERROR:Line" + lineno + ": Instruction not found - " + $1 + " " + $2 + ", " + $4)
        } else {
            // console.log("ERROR:Line" + lineno + ": Malformed instruction - " + $1 + " " + $2 + ", " + $4);
        }
    }
%}

%%

pgm:
      sequence
    ;

sequence:
      statement sequence
    | directive sequence
    |
    ;

statement:
      MNEMONIC REGISTER COMMA REGISTER
        {{
            // Search for the instruction
            var instruction = containsInstruction($1, instructionset);
            // Make sure the instruction was set
            assemble(yy, instruction, [$2, $4]);
        }}
    | MNEMONIC REGISTER COMMA REGISTER COMMA NUMBER
        {{
            // Search for the instruction
            var instruction = containsInstruction($1, instructionset);
            // Make sure the instruction was set
            assemble(yy, instruction, [$2, $4, $6]);
        }}
    | MNEMONIC REGISTER COMMA REGISTER COMMA REGISTER
        {{
            // Search for the instruction
            var instruction = containsInstruction($1, instructionset);
            // Make sure the instruction was set
            assemble(yy, instruction, [$2, $4, $6]);
        }}
    | MNEMONIC REGISTER COMMA number
        {{
            // Search for the instruction
            var instruction = containsInstruction($1, instructionset);
            // Make sure the instruction was set
            assemble(yy, instruction, [$2, $4]);
        }}
    /* lw/sw type instructions */
    | MNEMONIC REGISTER COMMA number LPAREN REGISTER RPAREN
        {{
            // Search for the instruction
            var instruction = containsInstruction($1, instructionset);
            // Make sure the instruction was set
            assemble(yy, instruction, [$2, $4, $6]);
        }}
    | MNEMONIC REGISTER COMMA LPAREN REGISTER RPAREN
        {{
            // Search for the instruction
            var instruction = containsInstruction($1, instructionset);
            // Make sure the instruction was set
            assemble(yy, instruction, [$2, $5]);
        }}
    ;

directive:
      TEXT
    | DATA
    | KTEXT
    | KDATA
    // | GLOBL SYMBOL
    | ALIGN number
    | SPACE number
    | datatype typelist
    // | datatype typelist
    // | EXTERN SYMBOL INTLITERAL
    ;

datatype:
      BYTE
    | DOUBLE
    | FLOAT
    | HALF
    | WORD
    ;


typelist:
      numlist
    | fplist
    ;

numlist:
      number COMMA numlist
    | number
    ;

fplist:
      FPLITERAL COMMA fplist
    | FPLITERAL
    ;

number:
      INTLITERAL
    | HEXLITERAL
    ;
