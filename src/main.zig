const std = @import("std");
const math = std.math;
const testing = std.testing;

pub const IntConvertError = error{NotANumber};

pub fn charToInt(comptime tipo: type, caractere: u8) !tipo {
    switch (caractere) {
        48 => return 0,
        49 => return 1,
        50 => return 2,
        51 => return 3,
        52 => return 4,
        53 => return 5,
        54 => return 6,
        55 => return 7,
        56 => return 8,
        57 => return 9,
        else => return IntConvertError.NotANumber,
    }
}

pub fn indexOfChar(str: []const u8, char: u8) usize {
    var index: usize = 0;
    for (str) |caractere| {
        if (caractere == char) {
            break;
        }
        index += 1;
    }
    return index;
}

pub fn strToInt(comptime tipo: type, str: []const u8) !tipo {
    var resultado: tipo = 0;
    var contador: tipo = @intCast(tipo, str.len) - 1;
    var sinal: tipo = 1;
    for (str) |caractere| {
        if (caractere == '-') {
            contador -= 1;
            sinal = -1;
            continue;
        }
        var numero = try charToInt(tipo, caractere);

        resultado += math.pow(tipo, 10, contador) * numero;

        contador -= 1;
    }

    return sinal * resultado;
}

pub fn strToFloat(comptime tipo: type, str: []const u8) !tipo {
    var resultado: tipo = undefined;
    var comeco: usize = 0;
    var sinal: tipo = 1.0;
    if (str[0] == '-') {
        comeco = 1;
        sinal = -1.0;
    }
    var parteInteira: []const u8 = str[comeco..indexOfChar(str, '.')];
    var parteDecimal: []const u8 = str[indexOfChar(str, '.') + 1 ..];
    std.debug.warn("{}\n", .{parteDecimal});
    std.debug.warn("{}\n", .{parteInteira});
    comptime var tipoInteiro: type = switch (tipo) {
        f16 => i16,
        f32 => i32,
        f64 => i64,
        f128 => i128,
        else => i64,
    };
    resultado = sinal * (@intToFloat(tipo, try strToInt(tipoInteiro, parteInteira)) +
        @intToFloat(tipo, try strToInt(tipoInteiro, parteDecimal)) / math.pow(tipo, 10, @intToFloat(tipo, parteDecimal.len)));
    std.debug.warn("{}\n", .{@intToFloat(tipo, try strToInt(tipoInteiro, parteDecimal))});
    return resultado;
}

test "charToIntTest" {
    var x = try charToInt(i32, '3');
    std.debug.assert(x == 3);
    var y = try charToInt(i32, '2');
    std.debug.assert(y == 2);
    _ = if (charToInt(i32, 'q')) |varlor| {
        std.debug.assert(-1 == 1);
    } else |erro| {
        std.debug.assert(erro == IntConvertError.NotANumber);
    };
}

test "strToIntTest" {
    var x = try strToInt(i32, "101");
    //std.debug.warn("{}\n",.{x});
    std.debug.assert(x == 101);
    var y = try strToInt(i32, "-100");
    std.debug.assert(y == -100);
    _ = if (strToInt(i32, "lakitu")) |varlor| {
        std.debug.assert(-1 == 1);
    } else |erro| {
        std.debug.assert(erro == IntConvertError.NotANumber);
    };
}

test "indexOfCharTest" {
    std.debug.assert(indexOfChar("123.123", '.') == 3);
    std.debug.assert(indexOfChar("1.00", '.') == 1);
}

test "strToFloatTest" {
    var x = try strToFloat(f32, "-1.0");
    std.debug.warn("{}\n", .{x});
}
