exports.assembler = {
    /**
     * Takes the given values and stores them into an integer which
     * represents the format of an R type instruction.
     */
    createRType: function(opcode, rd, rs, rt, shamt, funcfield) {
        var instruction = opcode;
        instruction = (instruction << 5) | rd;
        instruction = (instruction << 5) | rs;
        instruction = (instruction << 5) | rt;
        instruction = (instruction << 5) | shamt;
        instruction = (instruction << 6) | funcfield;
        return instruction;
    },

    /**
     * Takes the given values and stores them into an integer which
     * represents the format of an I type instruction.
     */
    createIType: function(opcode, rd, rs, immediate16) {
        var instruction = opcode;
        instruction = (instruction << 5)  | rd;
        instruction = (instruction << 5)  | rs;
        instruction = (instruction << 16) | immediate16;
        return instruction;
    },

    /**
     * Takes the given values and stores them into an integer which
     * represents the format of an J type instruction.
     */
    createJType: function(opcode, address26) {
        var instruction = opcode;
        instruction = (instruction << 26) | address26;
        return instruction;
    }
};
