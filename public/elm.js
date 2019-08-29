(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.0/optimize for better performance and smaller assets.');


var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File === 'function' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[94m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = elm$core$Set$toList(x);
		y = elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? elm$core$Basics$LT : n ? elm$core$Basics$GT : elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === elm$core$Basics$EQ ? 0 : ord === elm$core$Basics$LT ? -1 : 1;
	}));
});



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return word
		? elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? elm$core$Maybe$Nothing
		: elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? elm$core$Maybe$Just(n) : elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? elm$core$Result$Ok(value)
		: (value instanceof String)
			? elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!elm$core$Result$isOk(result))
					{
						return elm$core$Result$Err(A2(elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return elm$core$Result$Ok(elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if (elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return elm$core$Result$Err(elm$json$Json$Decode$OneOf(elm$core$List$reverse(errors)));

		case 1:
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!elm$core$Result$isOk(result))
		{
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2(elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	result = init(result.a);
	var model = result.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		result = A2(update, msg, model);
		stepper(model = result.a, viewMetadata);
		_Platform_dispatchEffects(managers, result.b, subscriptions(model));
	}

	_Platform_dispatchEffects(managers, result.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				p: bag.n,
				q: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.q)
		{
			x = temp.p(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		r: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		r: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,'')) ? '' : value;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,''))
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2(elm$json$Json$Decode$map, func, handler.a)
				:
			A3(elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});


function _Url_percentEncode(string)
{
	return encodeURIComponent(string);
}

function _Url_percentDecode(string)
{
	try
	{
		return elm$core$Maybe$Just(decodeURIComponent(string));
	}
	catch (e)
	{
		return elm$core$Maybe$Nothing;
	}
}



// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? elm$browser$Browser$Internal(next)
							: elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return elm$core$Result$isOk(result) ? elm$core$Maybe$Just(result.a) : elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail(elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}


// CREATE

var _Regex_never = /.^/;

var _Regex_fromStringWith = F2(function(options, string)
{
	var flags = 'g';
	if (options.multiline) { flags += 'm'; }
	if (options.caseInsensitive) { flags += 'i'; }

	try
	{
		return elm$core$Maybe$Just(new RegExp(string, flags));
	}
	catch(error)
	{
		return elm$core$Maybe$Nothing;
	}
});


// USE

var _Regex_contains = F2(function(re, string)
{
	return string.match(re) !== null;
});


var _Regex_findAtMost = F3(function(n, re, str)
{
	var out = [];
	var number = 0;
	var string = str;
	var lastIndex = re.lastIndex;
	var prevLastIndex = -1;
	var result;
	while (number++ < n && (result = re.exec(string)))
	{
		if (prevLastIndex == re.lastIndex) break;
		var i = result.length - 1;
		var subs = new Array(i);
		while (i > 0)
		{
			var submatch = result[i];
			subs[--i] = submatch
				? elm$core$Maybe$Just(submatch)
				: elm$core$Maybe$Nothing;
		}
		out.push(A4(elm$regex$Regex$Match, result[0], result.index, number, _List_fromArray(subs)));
		prevLastIndex = re.lastIndex;
	}
	re.lastIndex = lastIndex;
	return _List_fromArray(out);
});


var _Regex_replaceAtMost = F4(function(n, re, replacer, string)
{
	var count = 0;
	function jsReplacer(match)
	{
		if (count++ >= n)
		{
			return match;
		}
		var i = arguments.length - 3;
		var submatches = new Array(i);
		while (i > 0)
		{
			var submatch = arguments[i];
			submatches[--i] = submatch
				? elm$core$Maybe$Just(submatch)
				: elm$core$Maybe$Nothing;
		}
		return replacer(A4(elm$regex$Regex$Match, match, arguments[arguments.length - 2], count, _List_fromArray(submatches)));
	}
	return string.replace(re, jsReplacer);
});

var _Regex_splitAtMost = F3(function(n, re, str)
{
	var string = str;
	var out = [];
	var start = re.lastIndex;
	var restoreLastIndex = re.lastIndex;
	while (n--)
	{
		var result = re.exec(string);
		if (!result) break;
		out.push(string.slice(start, result.index));
		start = re.lastIndex;
	}
	out.push(string.slice(start));
	re.lastIndex = restoreLastIndex;
	return _List_fromArray(out);
});

var _Regex_infinity = Infinity;
var elm$core$Basics$EQ = {$: 'EQ'};
var elm$core$Basics$LT = {$: 'LT'};
var elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var elm$core$Array$foldr = F3(
	function (func, baseCase, _n0) {
		var tree = _n0.c;
		var tail = _n0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3(elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3(elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			elm$core$Elm$JsArray$foldr,
			helper,
			A3(elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var elm$core$Array$toList = function (array) {
	return A3(elm$core$Array$foldr, elm$core$List$cons, _List_Nil, array);
};
var elm$core$Basics$GT = {$: 'GT'};
var elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3(elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var elm$core$Dict$toList = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var elm$core$Dict$keys = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2(elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var elm$core$Set$toList = function (_n0) {
	var dict = _n0.a;
	return elm$core$Dict$keys(dict);
};
var elm$core$List$cons = _List_cons;
var author$project$Data$Document$cons = F2(
	function (element, document) {
		return _Utils_update(
			document,
			{
				body: A2(elm$core$List$cons, element, document.body)
			});
	});
var author$project$Data$Document$titleRoot = 'CtPaint';
var elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var elm$core$Basics$add = _Basics_add;
var elm$core$Basics$gt = _Utils_gt;
var elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var elm$core$List$reverse = function (list) {
	return A3(elm$core$List$foldl, elm$core$List$cons, _List_Nil, list);
};
var elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							elm$core$List$foldl,
							fn,
							acc,
							elm$core$List$reverse(r4)) : A4(elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4(elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var elm$core$Maybe$Nothing = {$: 'Nothing'};
var elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var elm$core$Basics$identity = function (x) {
	return x;
};
var elm$core$Basics$False = {$: 'False'};
var elm$core$Basics$True = {$: 'True'};
var elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var elm$core$Array$branchFactor = 32;
var elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var elm$core$Basics$ceiling = _Basics_ceiling;
var elm$core$Basics$fdiv = _Basics_fdiv;
var elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var elm$core$Basics$toFloat = _Basics_toFloat;
var elm$core$Array$shiftStep = elm$core$Basics$ceiling(
	A2(elm$core$Basics$logBase, 2, elm$core$Array$branchFactor));
var elm$core$Elm$JsArray$empty = _JsArray_empty;
var elm$core$Array$empty = A4(elm$core$Array$Array_elm_builtin, 0, elm$core$Array$shiftStep, elm$core$Elm$JsArray$empty, elm$core$Elm$JsArray$empty);
var elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _n0 = A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodes);
			var node = _n0.a;
			var remainingNodes = _n0.b;
			var newAcc = A2(
				elm$core$List$cons,
				elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var elm$core$Basics$eq = _Utils_equal;
var elm$core$Tuple$first = function (_n0) {
	var x = _n0.a;
	return x;
};
var elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = elm$core$Basics$ceiling(nodeListSize / elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2(elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var elm$core$Basics$floor = _Basics_floor;
var elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var elm$core$Basics$mul = _Basics_mul;
var elm$core$Basics$sub = _Basics_sub;
var elm$core$Elm$JsArray$length = _JsArray_length;
var elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.tail),
				elm$core$Array$shiftStep,
				elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * elm$core$Array$branchFactor;
			var depth = elm$core$Basics$floor(
				A2(elm$core$Basics$logBase, elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2(elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2(elm$core$Basics$max, 5, depth * elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var elm$core$Basics$idiv = _Basics_idiv;
var elm$core$Basics$lt = _Utils_lt;
var elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = elm$core$Array$Leaf(
					A3(elm$core$Elm$JsArray$initialize, elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2(elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var elm$core$Basics$le = _Utils_le;
var elm$core$Basics$remainderBy = _Basics_remainderBy;
var elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return elm$core$Array$empty;
		} else {
			var tailLen = len % elm$core$Array$branchFactor;
			var tail = A3(elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - elm$core$Array$branchFactor;
			return A5(elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var elm$core$Basics$and = _Basics_and;
var elm$core$Basics$append = _Utils_append;
var elm$core$Basics$or = _Basics_or;
var elm$core$Char$toCode = _Char_toCode;
var elm$core$Char$isLower = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var elm$core$Char$isUpper = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var elm$core$Char$isAlpha = function (_char) {
	return elm$core$Char$isLower(_char) || elm$core$Char$isUpper(_char);
};
var elm$core$Char$isDigit = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var elm$core$Char$isAlphaNum = function (_char) {
	return elm$core$Char$isLower(_char) || (elm$core$Char$isUpper(_char) || elm$core$Char$isDigit(_char));
};
var elm$core$List$length = function (xs) {
	return A3(
		elm$core$List$foldl,
		F2(
			function (_n0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var elm$core$List$map2 = _List_map2;
var elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2(elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var elm$core$List$range = F2(
	function (lo, hi) {
		return A3(elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			elm$core$List$map2,
			f,
			A2(
				elm$core$List$range,
				0,
				elm$core$List$length(xs) - 1),
			xs);
	});
var elm$core$String$all = _String_all;
var elm$core$String$fromInt = _String_fromNumber;
var elm$core$String$uncons = _String_uncons;
var elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var elm$json$Json$Decode$indent = function (str) {
	return A2(
		elm$core$String$join,
		'\n    ',
		A2(elm$core$String$split, '\n', str));
};
var elm$json$Json$Encode$encode = _Json_encode;
var elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + (elm$core$String$fromInt(i + 1) + (') ' + elm$json$Json$Decode$indent(
			elm$json$Json$Decode$errorToString(error))));
	});
var elm$json$Json$Decode$errorToString = function (error) {
	return A2(elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _n1 = elm$core$String$uncons(f);
						if (_n1.$ === 'Nothing') {
							return false;
						} else {
							var _n2 = _n1.a;
							var _char = _n2.a;
							var rest = _n2.b;
							return elm$core$Char$isAlpha(_char) && A2(elm$core$String$all, elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2(elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + (elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2(elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									elm$core$String$join,
									'',
									elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										elm$core$String$join,
										'',
										elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + (elm$core$String$fromInt(
								elm$core$List$length(errors)) + ' ways:'));
							return A2(
								elm$core$String$join,
								'\n\n',
								A2(
									elm$core$List$cons,
									introduction,
									A2(elm$core$List$indexedMap, elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								elm$core$String$join,
								'',
								elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + (elm$json$Json$Decode$indent(
						A2(elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var elm$json$Json$Decode$map = _Json_map1;
var elm$json$Json$Decode$map2 = _Json_map2;
var elm$json$Json$Decode$succeed = _Json_succeed;
var elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var elm$virtual_dom$VirtualDom$node = function (tag) {
	return _VirtualDom_node(
		_VirtualDom_noScript(tag));
};
var elm$virtual_dom$VirtualDom$keyedNode = function (tag) {
	return _VirtualDom_keyedNode(
		_VirtualDom_noScript(tag));
};
var elm$virtual_dom$VirtualDom$keyedNodeNS = F2(
	function (namespace, tag) {
		return A2(
			_VirtualDom_keyedNodeNS,
			namespace,
			_VirtualDom_noScript(tag));
	});
var elm$virtual_dom$VirtualDom$nodeNS = function (tag) {
	return _VirtualDom_nodeNS(
		_VirtualDom_noScript(tag));
};
var elm$core$Dict$Black = {$: 'Black'};
var elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var elm$core$Basics$compare = _Utils_compare;
var elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var elm$core$Dict$Red = {$: 'Red'};
var elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _n1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _n3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Red,
					key,
					value,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _n5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _n6 = left.d;
				var _n7 = _n6.a;
				var llK = _n6.b;
				var llV = _n6.c;
				var llLeft = _n6.d;
				var llRight = _n6.e;
				var lRight = left.e;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Red,
					lK,
					lV,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5(elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, elm$core$Dict$RBEmpty_elm_builtin, elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _n1 = A2(elm$core$Basics$compare, key, nKey);
			switch (_n1.$) {
				case 'LT':
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3(elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5(elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3(elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _n0 = A3(elm$core$Dict$insertHelp, key, value, dict);
		if ((_n0.$ === 'RBNode_elm_builtin') && (_n0.a.$ === 'Red')) {
			var _n1 = _n0.a;
			var k = _n0.b;
			var v = _n0.c;
			var l = _n0.d;
			var r = _n0.e;
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _n0;
			return x;
		}
	});
var elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles = F2(
	function (_n0, styles) {
		var newStyles = _n0.b;
		var classname = _n0.c;
		return elm$core$List$isEmpty(newStyles) ? styles : A3(elm$core$Dict$insert, classname, newStyles, styles);
	});
var rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute = function (_n0) {
	var val = _n0.a;
	return val;
};
var rtfeldman$elm_css$VirtualDom$Styled$accumulateKeyedStyledHtml = F2(
	function (_n6, _n7) {
		var key = _n6.a;
		var html = _n6.b;
		var pairs = _n7.a;
		var styles = _n7.b;
		switch (html.$) {
			case 'Unstyled':
				var vdom = html.a;
				return _Utils_Tuple2(
					A2(
						elm$core$List$cons,
						_Utils_Tuple2(key, vdom),
						pairs),
					styles);
			case 'Node':
				var elemType = html.a;
				var properties = html.b;
				var children = html.c;
				var combinedStyles = A3(elm$core$List$foldl, rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles, styles, properties);
				var _n9 = A3(
					elm$core$List$foldl,
					rtfeldman$elm_css$VirtualDom$Styled$accumulateStyledHtml,
					_Utils_Tuple2(_List_Nil, combinedStyles),
					children);
				var childNodes = _n9.a;
				var finalStyles = _n9.b;
				var vdom = A3(
					elm$virtual_dom$VirtualDom$node,
					elemType,
					A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties),
					elm$core$List$reverse(childNodes));
				return _Utils_Tuple2(
					A2(
						elm$core$List$cons,
						_Utils_Tuple2(key, vdom),
						pairs),
					finalStyles);
			case 'NodeNS':
				var ns = html.a;
				var elemType = html.b;
				var properties = html.c;
				var children = html.d;
				var combinedStyles = A3(elm$core$List$foldl, rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles, styles, properties);
				var _n10 = A3(
					elm$core$List$foldl,
					rtfeldman$elm_css$VirtualDom$Styled$accumulateStyledHtml,
					_Utils_Tuple2(_List_Nil, combinedStyles),
					children);
				var childNodes = _n10.a;
				var finalStyles = _n10.b;
				var vdom = A4(
					elm$virtual_dom$VirtualDom$nodeNS,
					ns,
					elemType,
					A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties),
					elm$core$List$reverse(childNodes));
				return _Utils_Tuple2(
					A2(
						elm$core$List$cons,
						_Utils_Tuple2(key, vdom),
						pairs),
					finalStyles);
			case 'KeyedNode':
				var elemType = html.a;
				var properties = html.b;
				var children = html.c;
				var combinedStyles = A3(elm$core$List$foldl, rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles, styles, properties);
				var _n11 = A3(
					elm$core$List$foldl,
					rtfeldman$elm_css$VirtualDom$Styled$accumulateKeyedStyledHtml,
					_Utils_Tuple2(_List_Nil, combinedStyles),
					children);
				var childNodes = _n11.a;
				var finalStyles = _n11.b;
				var vdom = A3(
					elm$virtual_dom$VirtualDom$keyedNode,
					elemType,
					A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties),
					elm$core$List$reverse(childNodes));
				return _Utils_Tuple2(
					A2(
						elm$core$List$cons,
						_Utils_Tuple2(key, vdom),
						pairs),
					finalStyles);
			default:
				var ns = html.a;
				var elemType = html.b;
				var properties = html.c;
				var children = html.d;
				var combinedStyles = A3(elm$core$List$foldl, rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles, styles, properties);
				var _n12 = A3(
					elm$core$List$foldl,
					rtfeldman$elm_css$VirtualDom$Styled$accumulateKeyedStyledHtml,
					_Utils_Tuple2(_List_Nil, combinedStyles),
					children);
				var childNodes = _n12.a;
				var finalStyles = _n12.b;
				var vdom = A4(
					elm$virtual_dom$VirtualDom$keyedNodeNS,
					ns,
					elemType,
					A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties),
					elm$core$List$reverse(childNodes));
				return _Utils_Tuple2(
					A2(
						elm$core$List$cons,
						_Utils_Tuple2(key, vdom),
						pairs),
					finalStyles);
		}
	});
var rtfeldman$elm_css$VirtualDom$Styled$accumulateStyledHtml = F2(
	function (html, _n0) {
		var nodes = _n0.a;
		var styles = _n0.b;
		switch (html.$) {
			case 'Unstyled':
				var vdomNode = html.a;
				return _Utils_Tuple2(
					A2(elm$core$List$cons, vdomNode, nodes),
					styles);
			case 'Node':
				var elemType = html.a;
				var properties = html.b;
				var children = html.c;
				var combinedStyles = A3(elm$core$List$foldl, rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles, styles, properties);
				var _n2 = A3(
					elm$core$List$foldl,
					rtfeldman$elm_css$VirtualDom$Styled$accumulateStyledHtml,
					_Utils_Tuple2(_List_Nil, combinedStyles),
					children);
				var childNodes = _n2.a;
				var finalStyles = _n2.b;
				var vdomNode = A3(
					elm$virtual_dom$VirtualDom$node,
					elemType,
					A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties),
					elm$core$List$reverse(childNodes));
				return _Utils_Tuple2(
					A2(elm$core$List$cons, vdomNode, nodes),
					finalStyles);
			case 'NodeNS':
				var ns = html.a;
				var elemType = html.b;
				var properties = html.c;
				var children = html.d;
				var combinedStyles = A3(elm$core$List$foldl, rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles, styles, properties);
				var _n3 = A3(
					elm$core$List$foldl,
					rtfeldman$elm_css$VirtualDom$Styled$accumulateStyledHtml,
					_Utils_Tuple2(_List_Nil, combinedStyles),
					children);
				var childNodes = _n3.a;
				var finalStyles = _n3.b;
				var vdomNode = A4(
					elm$virtual_dom$VirtualDom$nodeNS,
					ns,
					elemType,
					A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties),
					elm$core$List$reverse(childNodes));
				return _Utils_Tuple2(
					A2(elm$core$List$cons, vdomNode, nodes),
					finalStyles);
			case 'KeyedNode':
				var elemType = html.a;
				var properties = html.b;
				var children = html.c;
				var combinedStyles = A3(elm$core$List$foldl, rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles, styles, properties);
				var _n4 = A3(
					elm$core$List$foldl,
					rtfeldman$elm_css$VirtualDom$Styled$accumulateKeyedStyledHtml,
					_Utils_Tuple2(_List_Nil, combinedStyles),
					children);
				var childNodes = _n4.a;
				var finalStyles = _n4.b;
				var vdomNode = A3(
					elm$virtual_dom$VirtualDom$keyedNode,
					elemType,
					A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties),
					elm$core$List$reverse(childNodes));
				return _Utils_Tuple2(
					A2(elm$core$List$cons, vdomNode, nodes),
					finalStyles);
			default:
				var ns = html.a;
				var elemType = html.b;
				var properties = html.c;
				var children = html.d;
				var combinedStyles = A3(elm$core$List$foldl, rtfeldman$elm_css$VirtualDom$Styled$accumulateStyles, styles, properties);
				var _n5 = A3(
					elm$core$List$foldl,
					rtfeldman$elm_css$VirtualDom$Styled$accumulateKeyedStyledHtml,
					_Utils_Tuple2(_List_Nil, combinedStyles),
					children);
				var childNodes = _n5.a;
				var finalStyles = _n5.b;
				var vdomNode = A4(
					elm$virtual_dom$VirtualDom$keyedNodeNS,
					ns,
					elemType,
					A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties),
					elm$core$List$reverse(childNodes));
				return _Utils_Tuple2(
					A2(elm$core$List$cons, vdomNode, nodes),
					finalStyles);
		}
	});
var elm$core$Dict$empty = elm$core$Dict$RBEmpty_elm_builtin;
var elm$core$Dict$singleton = F2(
	function (key, value) {
		return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, key, value, elm$core$Dict$RBEmpty_elm_builtin, elm$core$Dict$RBEmpty_elm_builtin);
	});
var elm$core$String$isEmpty = function (string) {
	return string === '';
};
var rtfeldman$elm_css$VirtualDom$Styled$stylesFromPropertiesHelp = F2(
	function (candidate, properties) {
		stylesFromPropertiesHelp:
		while (true) {
			if (!properties.b) {
				return candidate;
			} else {
				var _n1 = properties.a;
				var styles = _n1.b;
				var classname = _n1.c;
				var rest = properties.b;
				if (elm$core$String$isEmpty(classname)) {
					var $temp$candidate = candidate,
						$temp$properties = rest;
					candidate = $temp$candidate;
					properties = $temp$properties;
					continue stylesFromPropertiesHelp;
				} else {
					var $temp$candidate = elm$core$Maybe$Just(
						_Utils_Tuple2(classname, styles)),
						$temp$properties = rest;
					candidate = $temp$candidate;
					properties = $temp$properties;
					continue stylesFromPropertiesHelp;
				}
			}
		}
	});
var rtfeldman$elm_css$VirtualDom$Styled$stylesFromProperties = function (properties) {
	var _n0 = A2(rtfeldman$elm_css$VirtualDom$Styled$stylesFromPropertiesHelp, elm$core$Maybe$Nothing, properties);
	if (_n0.$ === 'Nothing') {
		return elm$core$Dict$empty;
	} else {
		var _n1 = _n0.a;
		var classname = _n1.a;
		var styles = _n1.b;
		return A2(elm$core$Dict$singleton, classname, styles);
	}
};
var elm$core$List$singleton = function (value) {
	return _List_fromArray(
		[value]);
};
var elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var rtfeldman$elm_css$Css$Preprocess$stylesheet = function (snippets) {
	return {charset: elm$core$Maybe$Nothing, imports: _List_Nil, namespaces: _List_Nil, snippets: snippets};
};
var elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3(elm$core$List$foldr, elm$core$List$cons, ys, xs);
		}
	});
var elm$core$List$concat = function (lists) {
	return A3(elm$core$List$foldr, elm$core$List$append, _List_Nil, lists);
};
var elm$core$List$concatMap = F2(
	function (f, list) {
		return elm$core$List$concat(
			A2(elm$core$List$map, f, list));
	});
var rtfeldman$elm_css$Css$Preprocess$unwrapSnippet = function (_n0) {
	var declarations = _n0.a;
	return declarations;
};
var elm$core$Basics$neq = _Utils_notEqual;
var elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return elm$core$Maybe$Just(x);
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var elm$core$List$tail = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return elm$core$Maybe$Just(xs);
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2(elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var elm$core$List$takeTailRec = F2(
	function (n, list) {
		return elm$core$List$reverse(
			A3(elm$core$List$takeReverse, n, list, _List_Nil));
	});
var elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _n0 = _Utils_Tuple2(n, list);
			_n0$1:
			while (true) {
				_n0$5:
				while (true) {
					if (!_n0.b.b) {
						return list;
					} else {
						if (_n0.b.b.b) {
							switch (_n0.a) {
								case 1:
									break _n0$1;
								case 2:
									var _n2 = _n0.b;
									var x = _n2.a;
									var _n3 = _n2.b;
									var y = _n3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_n0.b.b.b.b) {
										var _n4 = _n0.b;
										var x = _n4.a;
										var _n5 = _n4.b;
										var y = _n5.a;
										var _n6 = _n5.b;
										var z = _n6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _n0$5;
									}
								default:
									if (_n0.b.b.b.b && _n0.b.b.b.b.b) {
										var _n7 = _n0.b;
										var x = _n7.a;
										var _n8 = _n7.b;
										var y = _n8.a;
										var _n9 = _n8.b;
										var z = _n9.a;
										var _n10 = _n9.b;
										var w = _n10.a;
										var tl = _n10.b;
										return (ctr > 1000) ? A2(
											elm$core$List$cons,
											x,
											A2(
												elm$core$List$cons,
												y,
												A2(
													elm$core$List$cons,
													z,
													A2(
														elm$core$List$cons,
														w,
														A2(elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											elm$core$List$cons,
											x,
											A2(
												elm$core$List$cons,
												y,
												A2(
													elm$core$List$cons,
													z,
													A2(
														elm$core$List$cons,
														w,
														A3(elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _n0$5;
									}
							}
						} else {
							if (_n0.a === 1) {
								break _n0$1;
							} else {
								break _n0$5;
							}
						}
					}
				}
				return list;
			}
			var _n1 = _n0.b;
			var x = _n1.a;
			return _List_fromArray(
				[x]);
		}
	});
var elm$core$List$take = F2(
	function (n, list) {
		return A3(elm$core$List$takeFast, 0, n, list);
	});
var elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return elm$core$Maybe$Just(
				f(value));
		} else {
			return elm$core$Maybe$Nothing;
		}
	});
var elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var rtfeldman$elm_css$Css$Preprocess$Resolve$collectSelectors = function (declarations) {
	collectSelectors:
	while (true) {
		if (!declarations.b) {
			return _List_Nil;
		} else {
			if (declarations.a.$ === 'StyleBlockDeclaration') {
				var _n1 = declarations.a.a;
				var firstSelector = _n1.a;
				var otherSelectors = _n1.b;
				var rest = declarations.b;
				return _Utils_ap(
					A2(elm$core$List$cons, firstSelector, otherSelectors),
					rtfeldman$elm_css$Css$Preprocess$Resolve$collectSelectors(rest));
			} else {
				var rest = declarations.b;
				var $temp$declarations = rest;
				declarations = $temp$declarations;
				continue collectSelectors;
			}
		}
	}
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$last = function (list) {
	last:
	while (true) {
		if (!list.b) {
			return elm$core$Maybe$Nothing;
		} else {
			if (!list.b.b) {
				var singleton = list.a;
				return elm$core$Maybe$Just(singleton);
			} else {
				var rest = list.b;
				var $temp$list = rest;
				list = $temp$list;
				continue last;
			}
		}
	}
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$lastDeclaration = function (declarations) {
	lastDeclaration:
	while (true) {
		if (!declarations.b) {
			return elm$core$Maybe$Nothing;
		} else {
			if (!declarations.b.b) {
				var x = declarations.a;
				return elm$core$Maybe$Just(
					_List_fromArray(
						[x]));
			} else {
				var xs = declarations.b;
				var $temp$declarations = xs;
				declarations = $temp$declarations;
				continue lastDeclaration;
			}
		}
	}
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$oneOf = function (maybes) {
	oneOf:
	while (true) {
		if (!maybes.b) {
			return elm$core$Maybe$Nothing;
		} else {
			var maybe = maybes.a;
			var rest = maybes.b;
			if (maybe.$ === 'Nothing') {
				var $temp$maybes = rest;
				maybes = $temp$maybes;
				continue oneOf;
			} else {
				return maybe;
			}
		}
	}
};
var rtfeldman$elm_css$Css$Structure$FontFeatureValues = function (a) {
	return {$: 'FontFeatureValues', a: a};
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$resolveFontFeatureValues = function (tuples) {
	var expandTuples = function (tuplesToExpand) {
		if (!tuplesToExpand.b) {
			return _List_Nil;
		} else {
			var properties = tuplesToExpand.a;
			var rest = tuplesToExpand.b;
			return A2(
				elm$core$List$cons,
				properties,
				expandTuples(rest));
		}
	};
	var newTuples = expandTuples(tuples);
	return _List_fromArray(
		[
			rtfeldman$elm_css$Css$Structure$FontFeatureValues(newTuples)
		]);
};
var rtfeldman$elm_css$Css$Structure$DocumentRule = F5(
	function (a, b, c, d, e) {
		return {$: 'DocumentRule', a: a, b: b, c: c, d: d, e: e};
	});
var rtfeldman$elm_css$Css$Preprocess$Resolve$toDocumentRule = F5(
	function (str1, str2, str3, str4, declaration) {
		if (declaration.$ === 'StyleBlockDeclaration') {
			var structureStyleBlock = declaration.a;
			return A5(rtfeldman$elm_css$Css$Structure$DocumentRule, str1, str2, str3, str4, structureStyleBlock);
		} else {
			return declaration;
		}
	});
var rtfeldman$elm_css$Css$Structure$MediaRule = F2(
	function (a, b) {
		return {$: 'MediaRule', a: a, b: b};
	});
var rtfeldman$elm_css$Css$Structure$SupportsRule = F2(
	function (a, b) {
		return {$: 'SupportsRule', a: a, b: b};
	});
var rtfeldman$elm_css$Css$Preprocess$Resolve$toMediaRule = F2(
	function (mediaQueries, declaration) {
		switch (declaration.$) {
			case 'StyleBlockDeclaration':
				var structureStyleBlock = declaration.a;
				return A2(
					rtfeldman$elm_css$Css$Structure$MediaRule,
					mediaQueries,
					_List_fromArray(
						[structureStyleBlock]));
			case 'MediaRule':
				var newMediaQueries = declaration.a;
				var structureStyleBlocks = declaration.b;
				return A2(
					rtfeldman$elm_css$Css$Structure$MediaRule,
					_Utils_ap(mediaQueries, newMediaQueries),
					structureStyleBlocks);
			case 'SupportsRule':
				var str = declaration.a;
				var declarations = declaration.b;
				return A2(
					rtfeldman$elm_css$Css$Structure$SupportsRule,
					str,
					A2(
						elm$core$List$map,
						rtfeldman$elm_css$Css$Preprocess$Resolve$toMediaRule(mediaQueries),
						declarations));
			case 'DocumentRule':
				var str1 = declaration.a;
				var str2 = declaration.b;
				var str3 = declaration.c;
				var str4 = declaration.d;
				var structureStyleBlock = declaration.e;
				return A5(rtfeldman$elm_css$Css$Structure$DocumentRule, str1, str2, str3, str4, structureStyleBlock);
			case 'PageRule':
				return declaration;
			case 'FontFace':
				return declaration;
			case 'Keyframes':
				return declaration;
			case 'Viewport':
				return declaration;
			case 'CounterStyle':
				return declaration;
			default:
				return declaration;
		}
	});
var rtfeldman$elm_css$Css$Structure$CounterStyle = function (a) {
	return {$: 'CounterStyle', a: a};
};
var rtfeldman$elm_css$Css$Structure$FontFace = function (a) {
	return {$: 'FontFace', a: a};
};
var rtfeldman$elm_css$Css$Structure$Keyframes = function (a) {
	return {$: 'Keyframes', a: a};
};
var rtfeldman$elm_css$Css$Structure$PageRule = F2(
	function (a, b) {
		return {$: 'PageRule', a: a, b: b};
	});
var rtfeldman$elm_css$Css$Structure$Selector = F3(
	function (a, b, c) {
		return {$: 'Selector', a: a, b: b, c: c};
	});
var rtfeldman$elm_css$Css$Structure$StyleBlock = F3(
	function (a, b, c) {
		return {$: 'StyleBlock', a: a, b: b, c: c};
	});
var rtfeldman$elm_css$Css$Structure$StyleBlockDeclaration = function (a) {
	return {$: 'StyleBlockDeclaration', a: a};
};
var rtfeldman$elm_css$Css$Structure$Viewport = function (a) {
	return {$: 'Viewport', a: a};
};
var rtfeldman$elm_css$Css$Structure$mapLast = F2(
	function (update, list) {
		if (!list.b) {
			return list;
		} else {
			if (!list.b.b) {
				var only = list.a;
				return _List_fromArray(
					[
						update(only)
					]);
			} else {
				var first = list.a;
				var rest = list.b;
				return A2(
					elm$core$List$cons,
					first,
					A2(rtfeldman$elm_css$Css$Structure$mapLast, update, rest));
			}
		}
	});
var rtfeldman$elm_css$Css$Structure$withPropertyAppended = F2(
	function (property, _n0) {
		var firstSelector = _n0.a;
		var otherSelectors = _n0.b;
		var properties = _n0.c;
		return A3(
			rtfeldman$elm_css$Css$Structure$StyleBlock,
			firstSelector,
			otherSelectors,
			_Utils_ap(
				properties,
				_List_fromArray(
					[property])));
	});
var rtfeldman$elm_css$Css$Structure$appendProperty = F2(
	function (property, declarations) {
		if (!declarations.b) {
			return declarations;
		} else {
			if (!declarations.b.b) {
				switch (declarations.a.$) {
					case 'StyleBlockDeclaration':
						var styleBlock = declarations.a.a;
						return _List_fromArray(
							[
								rtfeldman$elm_css$Css$Structure$StyleBlockDeclaration(
								A2(rtfeldman$elm_css$Css$Structure$withPropertyAppended, property, styleBlock))
							]);
					case 'MediaRule':
						var _n1 = declarations.a;
						var mediaQueries = _n1.a;
						var styleBlocks = _n1.b;
						return _List_fromArray(
							[
								A2(
								rtfeldman$elm_css$Css$Structure$MediaRule,
								mediaQueries,
								A2(
									rtfeldman$elm_css$Css$Structure$mapLast,
									rtfeldman$elm_css$Css$Structure$withPropertyAppended(property),
									styleBlocks))
							]);
					default:
						return declarations;
				}
			} else {
				var first = declarations.a;
				var rest = declarations.b;
				return A2(
					elm$core$List$cons,
					first,
					A2(rtfeldman$elm_css$Css$Structure$appendProperty, property, rest));
			}
		}
	});
var rtfeldman$elm_css$Css$Structure$appendToLastSelector = F2(
	function (f, styleBlock) {
		if (!styleBlock.b.b) {
			var only = styleBlock.a;
			var properties = styleBlock.c;
			return _List_fromArray(
				[
					A3(rtfeldman$elm_css$Css$Structure$StyleBlock, only, _List_Nil, properties),
					A3(
					rtfeldman$elm_css$Css$Structure$StyleBlock,
					f(only),
					_List_Nil,
					_List_Nil)
				]);
		} else {
			var first = styleBlock.a;
			var rest = styleBlock.b;
			var properties = styleBlock.c;
			var newRest = A2(elm$core$List$map, f, rest);
			var newFirst = f(first);
			return _List_fromArray(
				[
					A3(rtfeldman$elm_css$Css$Structure$StyleBlock, first, rest, properties),
					A3(rtfeldman$elm_css$Css$Structure$StyleBlock, newFirst, newRest, _List_Nil)
				]);
		}
	});
var rtfeldman$elm_css$Css$Structure$applyPseudoElement = F2(
	function (pseudo, _n0) {
		var sequence = _n0.a;
		var selectors = _n0.b;
		return A3(
			rtfeldman$elm_css$Css$Structure$Selector,
			sequence,
			selectors,
			elm$core$Maybe$Just(pseudo));
	});
var rtfeldman$elm_css$Css$Structure$appendPseudoElementToLastSelector = F2(
	function (pseudo, styleBlock) {
		return A2(
			rtfeldman$elm_css$Css$Structure$appendToLastSelector,
			rtfeldman$elm_css$Css$Structure$applyPseudoElement(pseudo),
			styleBlock);
	});
var rtfeldman$elm_css$Css$Structure$CustomSelector = F2(
	function (a, b) {
		return {$: 'CustomSelector', a: a, b: b};
	});
var rtfeldman$elm_css$Css$Structure$TypeSelectorSequence = F2(
	function (a, b) {
		return {$: 'TypeSelectorSequence', a: a, b: b};
	});
var rtfeldman$elm_css$Css$Structure$UniversalSelectorSequence = function (a) {
	return {$: 'UniversalSelectorSequence', a: a};
};
var rtfeldman$elm_css$Css$Structure$appendRepeatable = F2(
	function (selector, sequence) {
		switch (sequence.$) {
			case 'TypeSelectorSequence':
				var typeSelector = sequence.a;
				var list = sequence.b;
				return A2(
					rtfeldman$elm_css$Css$Structure$TypeSelectorSequence,
					typeSelector,
					_Utils_ap(
						list,
						_List_fromArray(
							[selector])));
			case 'UniversalSelectorSequence':
				var list = sequence.a;
				return rtfeldman$elm_css$Css$Structure$UniversalSelectorSequence(
					_Utils_ap(
						list,
						_List_fromArray(
							[selector])));
			default:
				var str = sequence.a;
				var list = sequence.b;
				return A2(
					rtfeldman$elm_css$Css$Structure$CustomSelector,
					str,
					_Utils_ap(
						list,
						_List_fromArray(
							[selector])));
		}
	});
var rtfeldman$elm_css$Css$Structure$appendRepeatableWithCombinator = F2(
	function (selector, list) {
		if (!list.b) {
			return _List_Nil;
		} else {
			if (!list.b.b) {
				var _n1 = list.a;
				var combinator = _n1.a;
				var sequence = _n1.b;
				return _List_fromArray(
					[
						_Utils_Tuple2(
						combinator,
						A2(rtfeldman$elm_css$Css$Structure$appendRepeatable, selector, sequence))
					]);
			} else {
				var first = list.a;
				var rest = list.b;
				return A2(
					elm$core$List$cons,
					first,
					A2(rtfeldman$elm_css$Css$Structure$appendRepeatableWithCombinator, selector, rest));
			}
		}
	});
var rtfeldman$elm_css$Css$Structure$appendRepeatableSelector = F2(
	function (repeatableSimpleSelector, selector) {
		if (!selector.b.b) {
			var sequence = selector.a;
			var pseudoElement = selector.c;
			return A3(
				rtfeldman$elm_css$Css$Structure$Selector,
				A2(rtfeldman$elm_css$Css$Structure$appendRepeatable, repeatableSimpleSelector, sequence),
				_List_Nil,
				pseudoElement);
		} else {
			var firstSelector = selector.a;
			var tuples = selector.b;
			var pseudoElement = selector.c;
			return A3(
				rtfeldman$elm_css$Css$Structure$Selector,
				firstSelector,
				A2(rtfeldman$elm_css$Css$Structure$appendRepeatableWithCombinator, repeatableSimpleSelector, tuples),
				pseudoElement);
		}
	});
var rtfeldman$elm_css$Css$Structure$appendRepeatableToLastSelector = F2(
	function (selector, styleBlock) {
		return A2(
			rtfeldman$elm_css$Css$Structure$appendToLastSelector,
			rtfeldman$elm_css$Css$Structure$appendRepeatableSelector(selector),
			styleBlock);
	});
var rtfeldman$elm_css$Css$Structure$concatMapLastStyleBlock = F2(
	function (update, declarations) {
		_n0$12:
		while (true) {
			if (!declarations.b) {
				return declarations;
			} else {
				if (!declarations.b.b) {
					switch (declarations.a.$) {
						case 'StyleBlockDeclaration':
							var styleBlock = declarations.a.a;
							return A2(
								elm$core$List$map,
								rtfeldman$elm_css$Css$Structure$StyleBlockDeclaration,
								update(styleBlock));
						case 'MediaRule':
							if (declarations.a.b.b) {
								if (!declarations.a.b.b.b) {
									var _n1 = declarations.a;
									var mediaQueries = _n1.a;
									var _n2 = _n1.b;
									var styleBlock = _n2.a;
									return _List_fromArray(
										[
											A2(
											rtfeldman$elm_css$Css$Structure$MediaRule,
											mediaQueries,
											update(styleBlock))
										]);
								} else {
									var _n3 = declarations.a;
									var mediaQueries = _n3.a;
									var _n4 = _n3.b;
									var first = _n4.a;
									var rest = _n4.b;
									var _n5 = A2(
										rtfeldman$elm_css$Css$Structure$concatMapLastStyleBlock,
										update,
										_List_fromArray(
											[
												A2(rtfeldman$elm_css$Css$Structure$MediaRule, mediaQueries, rest)
											]));
									if ((_n5.b && (_n5.a.$ === 'MediaRule')) && (!_n5.b.b)) {
										var _n6 = _n5.a;
										var newMediaQueries = _n6.a;
										var newStyleBlocks = _n6.b;
										return _List_fromArray(
											[
												A2(
												rtfeldman$elm_css$Css$Structure$MediaRule,
												newMediaQueries,
												A2(elm$core$List$cons, first, newStyleBlocks))
											]);
									} else {
										var newDeclarations = _n5;
										return newDeclarations;
									}
								}
							} else {
								break _n0$12;
							}
						case 'SupportsRule':
							var _n7 = declarations.a;
							var str = _n7.a;
							var nestedDeclarations = _n7.b;
							return _List_fromArray(
								[
									A2(
									rtfeldman$elm_css$Css$Structure$SupportsRule,
									str,
									A2(rtfeldman$elm_css$Css$Structure$concatMapLastStyleBlock, update, nestedDeclarations))
								]);
						case 'DocumentRule':
							var _n8 = declarations.a;
							var str1 = _n8.a;
							var str2 = _n8.b;
							var str3 = _n8.c;
							var str4 = _n8.d;
							var styleBlock = _n8.e;
							return A2(
								elm$core$List$map,
								A4(rtfeldman$elm_css$Css$Structure$DocumentRule, str1, str2, str3, str4),
								update(styleBlock));
						case 'PageRule':
							var _n9 = declarations.a;
							return declarations;
						case 'FontFace':
							return declarations;
						case 'Keyframes':
							return declarations;
						case 'Viewport':
							return declarations;
						case 'CounterStyle':
							return declarations;
						default:
							return declarations;
					}
				} else {
					break _n0$12;
				}
			}
		}
		var first = declarations.a;
		var rest = declarations.b;
		return A2(
			elm$core$List$cons,
			first,
			A2(rtfeldman$elm_css$Css$Structure$concatMapLastStyleBlock, update, rest));
	});
var rtfeldman$elm_css$Css$Structure$styleBlockToMediaRule = F2(
	function (mediaQueries, declaration) {
		if (declaration.$ === 'StyleBlockDeclaration') {
			var styleBlock = declaration.a;
			return A2(
				rtfeldman$elm_css$Css$Structure$MediaRule,
				mediaQueries,
				_List_fromArray(
					[styleBlock]));
		} else {
			return declaration;
		}
	});
var Skinney$murmur3$Murmur3$HashData = F4(
	function (shift, seed, hash, charsProcessed) {
		return {charsProcessed: charsProcessed, hash: hash, seed: seed, shift: shift};
	});
var Skinney$murmur3$Murmur3$c1 = 3432918353;
var Skinney$murmur3$Murmur3$c2 = 461845907;
var elm$core$Bitwise$and = _Bitwise_and;
var elm$core$Bitwise$shiftLeftBy = _Bitwise_shiftLeftBy;
var elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var Skinney$murmur3$Murmur3$multiplyBy = F2(
	function (b, a) {
		return ((a & 65535) * b) + ((((a >>> 16) * b) & 65535) << 16);
	});
var elm$core$Bitwise$or = _Bitwise_or;
var Skinney$murmur3$Murmur3$rotlBy = F2(
	function (b, a) {
		return (a << b) | (a >>> (32 - b));
	});
var elm$core$Bitwise$xor = _Bitwise_xor;
var Skinney$murmur3$Murmur3$finalize = function (data) {
	var acc = data.hash ? (data.seed ^ A2(
		Skinney$murmur3$Murmur3$multiplyBy,
		Skinney$murmur3$Murmur3$c2,
		A2(
			Skinney$murmur3$Murmur3$rotlBy,
			15,
			A2(Skinney$murmur3$Murmur3$multiplyBy, Skinney$murmur3$Murmur3$c1, data.hash)))) : data.seed;
	var h0 = acc ^ data.charsProcessed;
	var h1 = A2(Skinney$murmur3$Murmur3$multiplyBy, 2246822507, h0 ^ (h0 >>> 16));
	var h2 = A2(Skinney$murmur3$Murmur3$multiplyBy, 3266489909, h1 ^ (h1 >>> 13));
	return (h2 ^ (h2 >>> 16)) >>> 0;
};
var Skinney$murmur3$Murmur3$mix = F2(
	function (h1, k1) {
		return A2(
			Skinney$murmur3$Murmur3$multiplyBy,
			5,
			A2(
				Skinney$murmur3$Murmur3$rotlBy,
				13,
				h1 ^ A2(
					Skinney$murmur3$Murmur3$multiplyBy,
					Skinney$murmur3$Murmur3$c2,
					A2(
						Skinney$murmur3$Murmur3$rotlBy,
						15,
						A2(Skinney$murmur3$Murmur3$multiplyBy, Skinney$murmur3$Murmur3$c1, k1))))) + 3864292196;
	});
var Skinney$murmur3$Murmur3$hashFold = F2(
	function (c, data) {
		var res = data.hash | ((255 & elm$core$Char$toCode(c)) << data.shift);
		var _n0 = data.shift;
		if (_n0 === 24) {
			return {
				charsProcessed: data.charsProcessed + 1,
				hash: 0,
				seed: A2(Skinney$murmur3$Murmur3$mix, data.seed, res),
				shift: 0
			};
		} else {
			return {charsProcessed: data.charsProcessed + 1, hash: res, seed: data.seed, shift: data.shift + 8};
		}
	});
var elm$core$String$foldl = _String_foldl;
var Skinney$murmur3$Murmur3$hashString = F2(
	function (seed, str) {
		return Skinney$murmur3$Murmur3$finalize(
			A3(
				elm$core$String$foldl,
				Skinney$murmur3$Murmur3$hashFold,
				A4(Skinney$murmur3$Murmur3$HashData, 0, seed, 0, 0),
				str));
	});
var elm$core$String$cons = _String_cons;
var rtfeldman$elm_css$Hash$murmurSeed = 15739;
var elm$core$Basics$negate = function (n) {
	return -n;
};
var elm$core$String$fromList = _String_fromList;
var elm$core$Basics$modBy = _Basics_modBy;
var rtfeldman$elm_hex$Hex$unsafeToDigit = function (num) {
	unsafeToDigit:
	while (true) {
		switch (num) {
			case 0:
				return _Utils_chr('0');
			case 1:
				return _Utils_chr('1');
			case 2:
				return _Utils_chr('2');
			case 3:
				return _Utils_chr('3');
			case 4:
				return _Utils_chr('4');
			case 5:
				return _Utils_chr('5');
			case 6:
				return _Utils_chr('6');
			case 7:
				return _Utils_chr('7');
			case 8:
				return _Utils_chr('8');
			case 9:
				return _Utils_chr('9');
			case 10:
				return _Utils_chr('a');
			case 11:
				return _Utils_chr('b');
			case 12:
				return _Utils_chr('c');
			case 13:
				return _Utils_chr('d');
			case 14:
				return _Utils_chr('e');
			case 15:
				return _Utils_chr('f');
			default:
				var $temp$num = num;
				num = $temp$num;
				continue unsafeToDigit;
		}
	}
};
var rtfeldman$elm_hex$Hex$unsafePositiveToDigits = F2(
	function (digits, num) {
		unsafePositiveToDigits:
		while (true) {
			if (num < 16) {
				return A2(
					elm$core$List$cons,
					rtfeldman$elm_hex$Hex$unsafeToDigit(num),
					digits);
			} else {
				var $temp$digits = A2(
					elm$core$List$cons,
					rtfeldman$elm_hex$Hex$unsafeToDigit(
						A2(elm$core$Basics$modBy, 16, num)),
					digits),
					$temp$num = (num / 16) | 0;
				digits = $temp$digits;
				num = $temp$num;
				continue unsafePositiveToDigits;
			}
		}
	});
var rtfeldman$elm_hex$Hex$toString = function (num) {
	return elm$core$String$fromList(
		(num < 0) ? A2(
			elm$core$List$cons,
			_Utils_chr('-'),
			A2(rtfeldman$elm_hex$Hex$unsafePositiveToDigits, _List_Nil, -num)) : A2(rtfeldman$elm_hex$Hex$unsafePositiveToDigits, _List_Nil, num));
};
var rtfeldman$elm_css$Hash$fromString = function (str) {
	return A2(
		elm$core$String$cons,
		_Utils_chr('_'),
		rtfeldman$elm_hex$Hex$toString(
			A2(Skinney$murmur3$Murmur3$hashString, rtfeldman$elm_css$Hash$murmurSeed, str)));
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$applyNestedStylesToLast = F4(
	function (nestedStyles, rest, f, declarations) {
		var withoutParent = function (decls) {
			return A2(
				elm$core$Maybe$withDefault,
				_List_Nil,
				elm$core$List$tail(decls));
		};
		var nextResult = A2(
			rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles,
			rest,
			A2(
				elm$core$Maybe$withDefault,
				_List_Nil,
				rtfeldman$elm_css$Css$Preprocess$Resolve$lastDeclaration(declarations)));
		var newDeclarations = function () {
			var _n14 = _Utils_Tuple2(
				elm$core$List$head(nextResult),
				rtfeldman$elm_css$Css$Preprocess$Resolve$last(declarations));
			if ((_n14.a.$ === 'Just') && (_n14.b.$ === 'Just')) {
				var nextResultParent = _n14.a.a;
				var originalParent = _n14.b.a;
				return _Utils_ap(
					A2(
						elm$core$List$take,
						elm$core$List$length(declarations) - 1,
						declarations),
					_List_fromArray(
						[
							(!_Utils_eq(originalParent, nextResultParent)) ? nextResultParent : originalParent
						]));
			} else {
				return declarations;
			}
		}();
		var insertStylesToNestedDecl = function (lastDecl) {
			return elm$core$List$concat(
				A2(
					rtfeldman$elm_css$Css$Structure$mapLast,
					rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles(nestedStyles),
					A2(
						elm$core$List$map,
						elm$core$List$singleton,
						A2(rtfeldman$elm_css$Css$Structure$concatMapLastStyleBlock, f, lastDecl))));
		};
		var initialResult = A2(
			elm$core$Maybe$withDefault,
			_List_Nil,
			A2(
				elm$core$Maybe$map,
				insertStylesToNestedDecl,
				rtfeldman$elm_css$Css$Preprocess$Resolve$lastDeclaration(declarations)));
		return _Utils_ap(
			newDeclarations,
			_Utils_ap(
				withoutParent(initialResult),
				withoutParent(nextResult)));
	});
var rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles = F2(
	function (styles, declarations) {
		if (!styles.b) {
			return declarations;
		} else {
			switch (styles.a.$) {
				case 'AppendProperty':
					var property = styles.a.a;
					var rest = styles.b;
					return A2(
						rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles,
						rest,
						A2(rtfeldman$elm_css$Css$Structure$appendProperty, property, declarations));
				case 'ExtendSelector':
					var _n4 = styles.a;
					var selector = _n4.a;
					var nestedStyles = _n4.b;
					var rest = styles.b;
					return A4(
						rtfeldman$elm_css$Css$Preprocess$Resolve$applyNestedStylesToLast,
						nestedStyles,
						rest,
						rtfeldman$elm_css$Css$Structure$appendRepeatableToLastSelector(selector),
						declarations);
				case 'NestSnippet':
					var _n5 = styles.a;
					var selectorCombinator = _n5.a;
					var snippets = _n5.b;
					var rest = styles.b;
					var chain = F2(
						function (_n9, _n10) {
							var originalSequence = _n9.a;
							var originalTuples = _n9.b;
							var originalPseudoElement = _n9.c;
							var newSequence = _n10.a;
							var newTuples = _n10.b;
							var newPseudoElement = _n10.c;
							return A3(
								rtfeldman$elm_css$Css$Structure$Selector,
								originalSequence,
								_Utils_ap(
									originalTuples,
									A2(
										elm$core$List$cons,
										_Utils_Tuple2(selectorCombinator, newSequence),
										newTuples)),
								rtfeldman$elm_css$Css$Preprocess$Resolve$oneOf(
									_List_fromArray(
										[newPseudoElement, originalPseudoElement])));
						});
					var expandDeclaration = function (declaration) {
						switch (declaration.$) {
							case 'StyleBlockDeclaration':
								var _n7 = declaration.a;
								var firstSelector = _n7.a;
								var otherSelectors = _n7.b;
								var nestedStyles = _n7.c;
								var newSelectors = A2(
									elm$core$List$concatMap,
									function (originalSelector) {
										return A2(
											elm$core$List$map,
											chain(originalSelector),
											A2(elm$core$List$cons, firstSelector, otherSelectors));
									},
									rtfeldman$elm_css$Css$Preprocess$Resolve$collectSelectors(declarations));
								var newDeclarations = function () {
									if (!newSelectors.b) {
										return _List_Nil;
									} else {
										var first = newSelectors.a;
										var remainder = newSelectors.b;
										return _List_fromArray(
											[
												rtfeldman$elm_css$Css$Structure$StyleBlockDeclaration(
												A3(rtfeldman$elm_css$Css$Structure$StyleBlock, first, remainder, _List_Nil))
											]);
									}
								}();
								return A2(rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles, nestedStyles, newDeclarations);
							case 'MediaRule':
								var mediaQueries = declaration.a;
								var styleBlocks = declaration.b;
								return A2(rtfeldman$elm_css$Css$Preprocess$Resolve$resolveMediaRule, mediaQueries, styleBlocks);
							case 'SupportsRule':
								var str = declaration.a;
								var otherSnippets = declaration.b;
								return A2(rtfeldman$elm_css$Css$Preprocess$Resolve$resolveSupportsRule, str, otherSnippets);
							case 'DocumentRule':
								var str1 = declaration.a;
								var str2 = declaration.b;
								var str3 = declaration.c;
								var str4 = declaration.d;
								var styleBlock = declaration.e;
								return A2(
									elm$core$List$map,
									A4(rtfeldman$elm_css$Css$Preprocess$Resolve$toDocumentRule, str1, str2, str3, str4),
									rtfeldman$elm_css$Css$Preprocess$Resolve$expandStyleBlock(styleBlock));
							case 'PageRule':
								var str = declaration.a;
								var properties = declaration.b;
								return _List_fromArray(
									[
										A2(rtfeldman$elm_css$Css$Structure$PageRule, str, properties)
									]);
							case 'FontFace':
								var properties = declaration.a;
								return _List_fromArray(
									[
										rtfeldman$elm_css$Css$Structure$FontFace(properties)
									]);
							case 'Viewport':
								var properties = declaration.a;
								return _List_fromArray(
									[
										rtfeldman$elm_css$Css$Structure$Viewport(properties)
									]);
							case 'CounterStyle':
								var properties = declaration.a;
								return _List_fromArray(
									[
										rtfeldman$elm_css$Css$Structure$CounterStyle(properties)
									]);
							default:
								var tuples = declaration.a;
								return rtfeldman$elm_css$Css$Preprocess$Resolve$resolveFontFeatureValues(tuples);
						}
					};
					return elm$core$List$concat(
						_Utils_ap(
							_List_fromArray(
								[
									A2(rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles, rest, declarations)
								]),
							A2(
								elm$core$List$map,
								expandDeclaration,
								A2(elm$core$List$concatMap, rtfeldman$elm_css$Css$Preprocess$unwrapSnippet, snippets))));
				case 'WithPseudoElement':
					var _n11 = styles.a;
					var pseudoElement = _n11.a;
					var nestedStyles = _n11.b;
					var rest = styles.b;
					return A4(
						rtfeldman$elm_css$Css$Preprocess$Resolve$applyNestedStylesToLast,
						nestedStyles,
						rest,
						rtfeldman$elm_css$Css$Structure$appendPseudoElementToLastSelector(pseudoElement),
						declarations);
				case 'WithKeyframes':
					var str = styles.a.a;
					var rest = styles.b;
					var name = rtfeldman$elm_css$Hash$fromString(str);
					var newProperty = 'animation-name:' + name;
					var newDeclarations = A2(
						rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles,
						rest,
						A2(rtfeldman$elm_css$Css$Structure$appendProperty, newProperty, declarations));
					return A2(
						elm$core$List$append,
						newDeclarations,
						_List_fromArray(
							[
								rtfeldman$elm_css$Css$Structure$Keyframes(
								{declaration: str, name: name})
							]));
				case 'WithMedia':
					var _n12 = styles.a;
					var mediaQueries = _n12.a;
					var nestedStyles = _n12.b;
					var rest = styles.b;
					var extraDeclarations = function () {
						var _n13 = rtfeldman$elm_css$Css$Preprocess$Resolve$collectSelectors(declarations);
						if (!_n13.b) {
							return _List_Nil;
						} else {
							var firstSelector = _n13.a;
							var otherSelectors = _n13.b;
							return A2(
								elm$core$List$map,
								rtfeldman$elm_css$Css$Structure$styleBlockToMediaRule(mediaQueries),
								A2(
									rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles,
									nestedStyles,
									elm$core$List$singleton(
										rtfeldman$elm_css$Css$Structure$StyleBlockDeclaration(
											A3(rtfeldman$elm_css$Css$Structure$StyleBlock, firstSelector, otherSelectors, _List_Nil)))));
						}
					}();
					return _Utils_ap(
						A2(rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles, rest, declarations),
						extraDeclarations);
				default:
					var otherStyles = styles.a.a;
					var rest = styles.b;
					return A2(
						rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles,
						_Utils_ap(otherStyles, rest),
						declarations);
			}
		}
	});
var rtfeldman$elm_css$Css$Preprocess$Resolve$expandStyleBlock = function (_n2) {
	var firstSelector = _n2.a;
	var otherSelectors = _n2.b;
	var styles = _n2.c;
	return A2(
		rtfeldman$elm_css$Css$Preprocess$Resolve$applyStyles,
		styles,
		_List_fromArray(
			[
				rtfeldman$elm_css$Css$Structure$StyleBlockDeclaration(
				A3(rtfeldman$elm_css$Css$Structure$StyleBlock, firstSelector, otherSelectors, _List_Nil))
			]));
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$extract = function (snippetDeclarations) {
	if (!snippetDeclarations.b) {
		return _List_Nil;
	} else {
		var first = snippetDeclarations.a;
		var rest = snippetDeclarations.b;
		return _Utils_ap(
			rtfeldman$elm_css$Css$Preprocess$Resolve$toDeclarations(first),
			rtfeldman$elm_css$Css$Preprocess$Resolve$extract(rest));
	}
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$resolveMediaRule = F2(
	function (mediaQueries, styleBlocks) {
		var handleStyleBlock = function (styleBlock) {
			return A2(
				elm$core$List$map,
				rtfeldman$elm_css$Css$Preprocess$Resolve$toMediaRule(mediaQueries),
				rtfeldman$elm_css$Css$Preprocess$Resolve$expandStyleBlock(styleBlock));
		};
		return A2(elm$core$List$concatMap, handleStyleBlock, styleBlocks);
	});
var rtfeldman$elm_css$Css$Preprocess$Resolve$resolveSupportsRule = F2(
	function (str, snippets) {
		var declarations = rtfeldman$elm_css$Css$Preprocess$Resolve$extract(
			A2(elm$core$List$concatMap, rtfeldman$elm_css$Css$Preprocess$unwrapSnippet, snippets));
		return _List_fromArray(
			[
				A2(rtfeldman$elm_css$Css$Structure$SupportsRule, str, declarations)
			]);
	});
var rtfeldman$elm_css$Css$Preprocess$Resolve$toDeclarations = function (snippetDeclaration) {
	switch (snippetDeclaration.$) {
		case 'StyleBlockDeclaration':
			var styleBlock = snippetDeclaration.a;
			return rtfeldman$elm_css$Css$Preprocess$Resolve$expandStyleBlock(styleBlock);
		case 'MediaRule':
			var mediaQueries = snippetDeclaration.a;
			var styleBlocks = snippetDeclaration.b;
			return A2(rtfeldman$elm_css$Css$Preprocess$Resolve$resolveMediaRule, mediaQueries, styleBlocks);
		case 'SupportsRule':
			var str = snippetDeclaration.a;
			var snippets = snippetDeclaration.b;
			return A2(rtfeldman$elm_css$Css$Preprocess$Resolve$resolveSupportsRule, str, snippets);
		case 'DocumentRule':
			var str1 = snippetDeclaration.a;
			var str2 = snippetDeclaration.b;
			var str3 = snippetDeclaration.c;
			var str4 = snippetDeclaration.d;
			var styleBlock = snippetDeclaration.e;
			return A2(
				elm$core$List$map,
				A4(rtfeldman$elm_css$Css$Preprocess$Resolve$toDocumentRule, str1, str2, str3, str4),
				rtfeldman$elm_css$Css$Preprocess$Resolve$expandStyleBlock(styleBlock));
		case 'PageRule':
			var str = snippetDeclaration.a;
			var properties = snippetDeclaration.b;
			return _List_fromArray(
				[
					A2(rtfeldman$elm_css$Css$Structure$PageRule, str, properties)
				]);
		case 'FontFace':
			var properties = snippetDeclaration.a;
			return _List_fromArray(
				[
					rtfeldman$elm_css$Css$Structure$FontFace(properties)
				]);
		case 'Viewport':
			var properties = snippetDeclaration.a;
			return _List_fromArray(
				[
					rtfeldman$elm_css$Css$Structure$Viewport(properties)
				]);
		case 'CounterStyle':
			var properties = snippetDeclaration.a;
			return _List_fromArray(
				[
					rtfeldman$elm_css$Css$Structure$CounterStyle(properties)
				]);
		default:
			var tuples = snippetDeclaration.a;
			return rtfeldman$elm_css$Css$Preprocess$Resolve$resolveFontFeatureValues(tuples);
	}
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$toStructure = function (_n0) {
	var charset = _n0.charset;
	var imports = _n0.imports;
	var namespaces = _n0.namespaces;
	var snippets = _n0.snippets;
	var declarations = rtfeldman$elm_css$Css$Preprocess$Resolve$extract(
		A2(elm$core$List$concatMap, rtfeldman$elm_css$Css$Preprocess$unwrapSnippet, snippets));
	return {charset: charset, declarations: declarations, imports: imports, namespaces: namespaces};
};
var elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var elm$core$Basics$not = _Basics_not;
var elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var elm$core$List$all = F2(
	function (isOkay, list) {
		return !A2(
			elm$core$List$any,
			A2(elm$core$Basics$composeL, elm$core$Basics$not, isOkay),
			list);
	});
var rtfeldman$elm_css$Css$Structure$compactHelp = F2(
	function (declaration, _n0) {
		var keyframesByName = _n0.a;
		var declarations = _n0.b;
		switch (declaration.$) {
			case 'StyleBlockDeclaration':
				var _n2 = declaration.a;
				var properties = _n2.c;
				return elm$core$List$isEmpty(properties) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
			case 'MediaRule':
				var styleBlocks = declaration.b;
				return A2(
					elm$core$List$all,
					function (_n3) {
						var properties = _n3.c;
						return elm$core$List$isEmpty(properties);
					},
					styleBlocks) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
			case 'SupportsRule':
				var otherDeclarations = declaration.b;
				return elm$core$List$isEmpty(otherDeclarations) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
			case 'DocumentRule':
				return _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
			case 'PageRule':
				var properties = declaration.b;
				return elm$core$List$isEmpty(properties) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
			case 'FontFace':
				var properties = declaration.a;
				return elm$core$List$isEmpty(properties) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
			case 'Keyframes':
				var record = declaration.a;
				return elm$core$String$isEmpty(record.declaration) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					A3(elm$core$Dict$insert, record.name, record.declaration, keyframesByName),
					declarations);
			case 'Viewport':
				var properties = declaration.a;
				return elm$core$List$isEmpty(properties) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
			case 'CounterStyle':
				var properties = declaration.a;
				return elm$core$List$isEmpty(properties) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
			default:
				var tuples = declaration.a;
				return A2(
					elm$core$List$all,
					function (_n4) {
						var properties = _n4.b;
						return elm$core$List$isEmpty(properties);
					},
					tuples) ? _Utils_Tuple2(keyframesByName, declarations) : _Utils_Tuple2(
					keyframesByName,
					A2(elm$core$List$cons, declaration, declarations));
		}
	});
var rtfeldman$elm_css$Css$Structure$withKeyframeDeclarations = F2(
	function (keyframesByName, compactedDeclarations) {
		return A2(
			elm$core$List$append,
			A2(
				elm$core$List$map,
				function (_n0) {
					var name = _n0.a;
					var decl = _n0.b;
					return rtfeldman$elm_css$Css$Structure$Keyframes(
						{declaration: decl, name: name});
				},
				elm$core$Dict$toList(keyframesByName)),
			compactedDeclarations);
	});
var rtfeldman$elm_css$Css$Structure$compactStylesheet = function (_n0) {
	var charset = _n0.charset;
	var imports = _n0.imports;
	var namespaces = _n0.namespaces;
	var declarations = _n0.declarations;
	var _n1 = A3(
		elm$core$List$foldr,
		rtfeldman$elm_css$Css$Structure$compactHelp,
		_Utils_Tuple2(elm$core$Dict$empty, _List_Nil),
		declarations);
	var keyframesByName = _n1.a;
	var compactedDeclarations = _n1.b;
	var finalDeclarations = A2(rtfeldman$elm_css$Css$Structure$withKeyframeDeclarations, keyframesByName, compactedDeclarations);
	return {charset: charset, declarations: finalDeclarations, imports: imports, namespaces: namespaces};
};
var elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2(elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var rtfeldman$elm_css$Css$Structure$Output$charsetToString = function (charset) {
	return A2(
		elm$core$Maybe$withDefault,
		'',
		A2(
			elm$core$Maybe$map,
			function (str) {
				return '@charset \"' + (str + '\"');
			},
			charset));
};
var rtfeldman$elm_css$Css$Structure$Output$mediaExpressionToString = function (expression) {
	return '(' + (expression.feature + (A2(
		elm$core$Maybe$withDefault,
		'',
		A2(
			elm$core$Maybe$map,
			elm$core$Basics$append(': '),
			expression.value)) + ')'));
};
var rtfeldman$elm_css$Css$Structure$Output$mediaTypeToString = function (mediaType) {
	switch (mediaType.$) {
		case 'Print':
			return 'print';
		case 'Screen':
			return 'screen';
		default:
			return 'speech';
	}
};
var rtfeldman$elm_css$Css$Structure$Output$mediaQueryToString = function (mediaQuery) {
	var prefixWith = F3(
		function (str, mediaType, expressions) {
			return str + (' ' + A2(
				elm$core$String$join,
				' and ',
				A2(
					elm$core$List$cons,
					rtfeldman$elm_css$Css$Structure$Output$mediaTypeToString(mediaType),
					A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$mediaExpressionToString, expressions))));
		});
	switch (mediaQuery.$) {
		case 'AllQuery':
			var expressions = mediaQuery.a;
			return A2(
				elm$core$String$join,
				' and ',
				A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$mediaExpressionToString, expressions));
		case 'OnlyQuery':
			var mediaType = mediaQuery.a;
			var expressions = mediaQuery.b;
			return A3(prefixWith, 'only', mediaType, expressions);
		case 'NotQuery':
			var mediaType = mediaQuery.a;
			var expressions = mediaQuery.b;
			return A3(prefixWith, 'not', mediaType, expressions);
		default:
			var str = mediaQuery.a;
			return str;
	}
};
var rtfeldman$elm_css$Css$Structure$Output$importMediaQueryToString = F2(
	function (name, mediaQuery) {
		return '@import \"' + (name + (rtfeldman$elm_css$Css$Structure$Output$mediaQueryToString(mediaQuery) + '\"'));
	});
var rtfeldman$elm_css$Css$Structure$Output$importToString = function (_n0) {
	var name = _n0.a;
	var mediaQueries = _n0.b;
	return A2(
		elm$core$String$join,
		'\n',
		A2(
			elm$core$List$map,
			rtfeldman$elm_css$Css$Structure$Output$importMediaQueryToString(name),
			mediaQueries));
};
var rtfeldman$elm_css$Css$Structure$Output$namespaceToString = function (_n0) {
	var prefix = _n0.a;
	var str = _n0.b;
	return '@namespace ' + (prefix + ('\"' + (str + '\"')));
};
var rtfeldman$elm_css$Css$Structure$Output$spaceIndent = '    ';
var rtfeldman$elm_css$Css$Structure$Output$indent = function (str) {
	return _Utils_ap(rtfeldman$elm_css$Css$Structure$Output$spaceIndent, str);
};
var rtfeldman$elm_css$Css$Structure$Output$noIndent = '';
var rtfeldman$elm_css$Css$Structure$Output$emitProperty = function (str) {
	return str + ';';
};
var rtfeldman$elm_css$Css$Structure$Output$emitProperties = function (properties) {
	return A2(
		elm$core$String$join,
		'\n',
		A2(
			elm$core$List$map,
			A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$Structure$Output$indent, rtfeldman$elm_css$Css$Structure$Output$emitProperty),
			properties));
};
var elm$core$String$append = _String_append;
var rtfeldman$elm_css$Css$Structure$Output$pseudoElementToString = function (_n0) {
	var str = _n0.a;
	return '::' + str;
};
var rtfeldman$elm_css$Css$Structure$Output$combinatorToString = function (combinator) {
	switch (combinator.$) {
		case 'AdjacentSibling':
			return '+';
		case 'GeneralSibling':
			return '~';
		case 'Child':
			return '>';
		default:
			return '';
	}
};
var rtfeldman$elm_css$Css$Structure$Output$repeatableSimpleSelectorToString = function (repeatableSimpleSelector) {
	switch (repeatableSimpleSelector.$) {
		case 'ClassSelector':
			var str = repeatableSimpleSelector.a;
			return '.' + str;
		case 'IdSelector':
			var str = repeatableSimpleSelector.a;
			return '#' + str;
		case 'PseudoClassSelector':
			var str = repeatableSimpleSelector.a;
			return ':' + str;
		default:
			var str = repeatableSimpleSelector.a;
			return '[' + (str + ']');
	}
};
var rtfeldman$elm_css$Css$Structure$Output$simpleSelectorSequenceToString = function (simpleSelectorSequence) {
	switch (simpleSelectorSequence.$) {
		case 'TypeSelectorSequence':
			var str = simpleSelectorSequence.a.a;
			var repeatableSimpleSelectors = simpleSelectorSequence.b;
			return A2(
				elm$core$String$join,
				'',
				A2(
					elm$core$List$cons,
					str,
					A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$repeatableSimpleSelectorToString, repeatableSimpleSelectors)));
		case 'UniversalSelectorSequence':
			var repeatableSimpleSelectors = simpleSelectorSequence.a;
			return elm$core$List$isEmpty(repeatableSimpleSelectors) ? '*' : A2(
				elm$core$String$join,
				'',
				A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$repeatableSimpleSelectorToString, repeatableSimpleSelectors));
		default:
			var str = simpleSelectorSequence.a;
			var repeatableSimpleSelectors = simpleSelectorSequence.b;
			return A2(
				elm$core$String$join,
				'',
				A2(
					elm$core$List$cons,
					str,
					A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$repeatableSimpleSelectorToString, repeatableSimpleSelectors)));
	}
};
var rtfeldman$elm_css$Css$Structure$Output$selectorChainToString = function (_n0) {
	var combinator = _n0.a;
	var sequence = _n0.b;
	return A2(
		elm$core$String$join,
		' ',
		_List_fromArray(
			[
				rtfeldman$elm_css$Css$Structure$Output$combinatorToString(combinator),
				rtfeldman$elm_css$Css$Structure$Output$simpleSelectorSequenceToString(sequence)
			]));
};
var rtfeldman$elm_css$Css$Structure$Output$selectorToString = function (_n0) {
	var simpleSelectorSequence = _n0.a;
	var chain = _n0.b;
	var pseudoElement = _n0.c;
	var segments = A2(
		elm$core$List$cons,
		rtfeldman$elm_css$Css$Structure$Output$simpleSelectorSequenceToString(simpleSelectorSequence),
		A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$selectorChainToString, chain));
	var pseudoElementsString = A2(
		elm$core$String$join,
		'',
		_List_fromArray(
			[
				A2(
				elm$core$Maybe$withDefault,
				'',
				A2(elm$core$Maybe$map, rtfeldman$elm_css$Css$Structure$Output$pseudoElementToString, pseudoElement))
			]));
	return A2(
		elm$core$String$append,
		A2(
			elm$core$String$join,
			' ',
			A2(
				elm$core$List$filter,
				A2(elm$core$Basics$composeL, elm$core$Basics$not, elm$core$String$isEmpty),
				segments)),
		pseudoElementsString);
};
var rtfeldman$elm_css$Css$Structure$Output$prettyPrintStyleBlock = F2(
	function (indentLevel, _n0) {
		var firstSelector = _n0.a;
		var otherSelectors = _n0.b;
		var properties = _n0.c;
		var selectorStr = A2(
			elm$core$String$join,
			', ',
			A2(
				elm$core$List$map,
				rtfeldman$elm_css$Css$Structure$Output$selectorToString,
				A2(elm$core$List$cons, firstSelector, otherSelectors)));
		return A2(
			elm$core$String$join,
			'',
			_List_fromArray(
				[
					selectorStr,
					' {\n',
					indentLevel,
					rtfeldman$elm_css$Css$Structure$Output$emitProperties(properties),
					'\n',
					indentLevel,
					'}'
				]));
	});
var rtfeldman$elm_css$Css$Structure$Output$prettyPrintDeclaration = function (decl) {
	switch (decl.$) {
		case 'StyleBlockDeclaration':
			var styleBlock = decl.a;
			return A2(rtfeldman$elm_css$Css$Structure$Output$prettyPrintStyleBlock, rtfeldman$elm_css$Css$Structure$Output$noIndent, styleBlock);
		case 'MediaRule':
			var mediaQueries = decl.a;
			var styleBlocks = decl.b;
			var query = A2(
				elm$core$String$join,
				',\n',
				A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$mediaQueryToString, mediaQueries));
			var blocks = A2(
				elm$core$String$join,
				'\n\n',
				A2(
					elm$core$List$map,
					A2(
						elm$core$Basics$composeL,
						rtfeldman$elm_css$Css$Structure$Output$indent,
						rtfeldman$elm_css$Css$Structure$Output$prettyPrintStyleBlock(rtfeldman$elm_css$Css$Structure$Output$spaceIndent)),
					styleBlocks));
			return '@media ' + (query + (' {\n' + (blocks + '\n}')));
		case 'SupportsRule':
			return 'TODO';
		case 'DocumentRule':
			return 'TODO';
		case 'PageRule':
			return 'TODO';
		case 'FontFace':
			return 'TODO';
		case 'Keyframes':
			var name = decl.a.name;
			var declaration = decl.a.declaration;
			return '@keyframes ' + (name + (' {\n' + (declaration + '\n}')));
		case 'Viewport':
			return 'TODO';
		case 'CounterStyle':
			return 'TODO';
		default:
			return 'TODO';
	}
};
var rtfeldman$elm_css$Css$Structure$Output$prettyPrint = function (_n0) {
	var charset = _n0.charset;
	var imports = _n0.imports;
	var namespaces = _n0.namespaces;
	var declarations = _n0.declarations;
	return A2(
		elm$core$String$join,
		'\n\n',
		A2(
			elm$core$List$filter,
			A2(elm$core$Basics$composeL, elm$core$Basics$not, elm$core$String$isEmpty),
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$Structure$Output$charsetToString(charset),
					A2(
					elm$core$String$join,
					'\n',
					A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$importToString, imports)),
					A2(
					elm$core$String$join,
					'\n',
					A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$namespaceToString, namespaces)),
					A2(
					elm$core$String$join,
					'\n\n',
					A2(elm$core$List$map, rtfeldman$elm_css$Css$Structure$Output$prettyPrintDeclaration, declarations))
				])));
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$compileHelp = function (sheet) {
	return rtfeldman$elm_css$Css$Structure$Output$prettyPrint(
		rtfeldman$elm_css$Css$Structure$compactStylesheet(
			rtfeldman$elm_css$Css$Preprocess$Resolve$toStructure(sheet)));
};
var rtfeldman$elm_css$Css$Preprocess$Resolve$compile = function (styles) {
	return A2(
		elm$core$String$join,
		'\n\n',
		A2(elm$core$List$map, rtfeldman$elm_css$Css$Preprocess$Resolve$compileHelp, styles));
};
var rtfeldman$elm_css$Css$Structure$ClassSelector = function (a) {
	return {$: 'ClassSelector', a: a};
};
var rtfeldman$elm_css$Css$Preprocess$Snippet = function (a) {
	return {$: 'Snippet', a: a};
};
var rtfeldman$elm_css$Css$Preprocess$StyleBlock = F3(
	function (a, b, c) {
		return {$: 'StyleBlock', a: a, b: b, c: c};
	});
var rtfeldman$elm_css$Css$Preprocess$StyleBlockDeclaration = function (a) {
	return {$: 'StyleBlockDeclaration', a: a};
};
var rtfeldman$elm_css$VirtualDom$Styled$makeSnippet = F2(
	function (styles, sequence) {
		var selector = A3(rtfeldman$elm_css$Css$Structure$Selector, sequence, _List_Nil, elm$core$Maybe$Nothing);
		return rtfeldman$elm_css$Css$Preprocess$Snippet(
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$Preprocess$StyleBlockDeclaration(
					A3(rtfeldman$elm_css$Css$Preprocess$StyleBlock, selector, _List_Nil, styles))
				]));
	});
var rtfeldman$elm_css$VirtualDom$Styled$snippetFromPair = function (_n0) {
	var classname = _n0.a;
	var styles = _n0.b;
	return A2(
		rtfeldman$elm_css$VirtualDom$Styled$makeSnippet,
		styles,
		rtfeldman$elm_css$Css$Structure$UniversalSelectorSequence(
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$Structure$ClassSelector(classname)
				])));
};
var rtfeldman$elm_css$VirtualDom$Styled$toDeclaration = function (dict) {
	return rtfeldman$elm_css$Css$Preprocess$Resolve$compile(
		elm$core$List$singleton(
			rtfeldman$elm_css$Css$Preprocess$stylesheet(
				A2(
					elm$core$List$map,
					rtfeldman$elm_css$VirtualDom$Styled$snippetFromPair,
					elm$core$Dict$toList(dict)))));
};
var rtfeldman$elm_css$VirtualDom$Styled$toStyleNode = function (styles) {
	return A3(
		elm$virtual_dom$VirtualDom$node,
		'style',
		_List_Nil,
		elm$core$List$singleton(
			elm$virtual_dom$VirtualDom$text(
				rtfeldman$elm_css$VirtualDom$Styled$toDeclaration(styles))));
};
var rtfeldman$elm_css$VirtualDom$Styled$unstyle = F3(
	function (elemType, properties, children) {
		var unstyledProperties = A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties);
		var initialStyles = rtfeldman$elm_css$VirtualDom$Styled$stylesFromProperties(properties);
		var _n0 = A3(
			elm$core$List$foldl,
			rtfeldman$elm_css$VirtualDom$Styled$accumulateStyledHtml,
			_Utils_Tuple2(_List_Nil, initialStyles),
			children);
		var childNodes = _n0.a;
		var styles = _n0.b;
		var styleNode = rtfeldman$elm_css$VirtualDom$Styled$toStyleNode(styles);
		return A3(
			elm$virtual_dom$VirtualDom$node,
			elemType,
			unstyledProperties,
			A2(
				elm$core$List$cons,
				styleNode,
				elm$core$List$reverse(childNodes)));
	});
var rtfeldman$elm_css$VirtualDom$Styled$containsKey = F2(
	function (key, pairs) {
		containsKey:
		while (true) {
			if (!pairs.b) {
				return false;
			} else {
				var _n1 = pairs.a;
				var str = _n1.a;
				var rest = pairs.b;
				if (_Utils_eq(key, str)) {
					return true;
				} else {
					var $temp$key = key,
						$temp$pairs = rest;
					key = $temp$key;
					pairs = $temp$pairs;
					continue containsKey;
				}
			}
		}
	});
var rtfeldman$elm_css$VirtualDom$Styled$getUnusedKey = F2(
	function (_default, pairs) {
		getUnusedKey:
		while (true) {
			if (!pairs.b) {
				return _default;
			} else {
				var _n1 = pairs.a;
				var firstKey = _n1.a;
				var rest = pairs.b;
				var newKey = '_' + firstKey;
				if (A2(rtfeldman$elm_css$VirtualDom$Styled$containsKey, newKey, rest)) {
					var $temp$default = newKey,
						$temp$pairs = rest;
					_default = $temp$default;
					pairs = $temp$pairs;
					continue getUnusedKey;
				} else {
					return newKey;
				}
			}
		}
	});
var rtfeldman$elm_css$VirtualDom$Styled$toKeyedStyleNode = F2(
	function (allStyles, keyedChildNodes) {
		var styleNodeKey = A2(rtfeldman$elm_css$VirtualDom$Styled$getUnusedKey, '_', keyedChildNodes);
		var finalNode = rtfeldman$elm_css$VirtualDom$Styled$toStyleNode(allStyles);
		return _Utils_Tuple2(styleNodeKey, finalNode);
	});
var rtfeldman$elm_css$VirtualDom$Styled$unstyleKeyed = F3(
	function (elemType, properties, keyedChildren) {
		var unstyledProperties = A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties);
		var initialStyles = rtfeldman$elm_css$VirtualDom$Styled$stylesFromProperties(properties);
		var _n0 = A3(
			elm$core$List$foldl,
			rtfeldman$elm_css$VirtualDom$Styled$accumulateKeyedStyledHtml,
			_Utils_Tuple2(_List_Nil, initialStyles),
			keyedChildren);
		var keyedChildNodes = _n0.a;
		var styles = _n0.b;
		var keyedStyleNode = A2(rtfeldman$elm_css$VirtualDom$Styled$toKeyedStyleNode, styles, keyedChildNodes);
		return A3(
			elm$virtual_dom$VirtualDom$keyedNode,
			elemType,
			unstyledProperties,
			A2(
				elm$core$List$cons,
				keyedStyleNode,
				elm$core$List$reverse(keyedChildNodes)));
	});
var rtfeldman$elm_css$VirtualDom$Styled$unstyleKeyedNS = F4(
	function (ns, elemType, properties, keyedChildren) {
		var unstyledProperties = A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties);
		var initialStyles = rtfeldman$elm_css$VirtualDom$Styled$stylesFromProperties(properties);
		var _n0 = A3(
			elm$core$List$foldl,
			rtfeldman$elm_css$VirtualDom$Styled$accumulateKeyedStyledHtml,
			_Utils_Tuple2(_List_Nil, initialStyles),
			keyedChildren);
		var keyedChildNodes = _n0.a;
		var styles = _n0.b;
		var keyedStyleNode = A2(rtfeldman$elm_css$VirtualDom$Styled$toKeyedStyleNode, styles, keyedChildNodes);
		return A4(
			elm$virtual_dom$VirtualDom$keyedNodeNS,
			ns,
			elemType,
			unstyledProperties,
			A2(
				elm$core$List$cons,
				keyedStyleNode,
				elm$core$List$reverse(keyedChildNodes)));
	});
var rtfeldman$elm_css$VirtualDom$Styled$unstyleNS = F4(
	function (ns, elemType, properties, children) {
		var unstyledProperties = A2(elm$core$List$map, rtfeldman$elm_css$VirtualDom$Styled$extractUnstyledAttribute, properties);
		var initialStyles = rtfeldman$elm_css$VirtualDom$Styled$stylesFromProperties(properties);
		var _n0 = A3(
			elm$core$List$foldl,
			rtfeldman$elm_css$VirtualDom$Styled$accumulateStyledHtml,
			_Utils_Tuple2(_List_Nil, initialStyles),
			children);
		var childNodes = _n0.a;
		var styles = _n0.b;
		var styleNode = rtfeldman$elm_css$VirtualDom$Styled$toStyleNode(styles);
		return A4(
			elm$virtual_dom$VirtualDom$nodeNS,
			ns,
			elemType,
			unstyledProperties,
			A2(
				elm$core$List$cons,
				styleNode,
				elm$core$List$reverse(childNodes)));
	});
var rtfeldman$elm_css$VirtualDom$Styled$toUnstyled = function (vdom) {
	switch (vdom.$) {
		case 'Unstyled':
			var plainNode = vdom.a;
			return plainNode;
		case 'Node':
			var elemType = vdom.a;
			var properties = vdom.b;
			var children = vdom.c;
			return A3(rtfeldman$elm_css$VirtualDom$Styled$unstyle, elemType, properties, children);
		case 'NodeNS':
			var ns = vdom.a;
			var elemType = vdom.b;
			var properties = vdom.c;
			var children = vdom.d;
			return A4(rtfeldman$elm_css$VirtualDom$Styled$unstyleNS, ns, elemType, properties, children);
		case 'KeyedNode':
			var elemType = vdom.a;
			var properties = vdom.b;
			var children = vdom.c;
			return A3(rtfeldman$elm_css$VirtualDom$Styled$unstyleKeyed, elemType, properties, children);
		default:
			var ns = vdom.a;
			var elemType = vdom.b;
			var properties = vdom.c;
			var children = vdom.d;
			return A4(rtfeldman$elm_css$VirtualDom$Styled$unstyleKeyedNS, ns, elemType, properties, children);
	}
};
var rtfeldman$elm_css$Html$Styled$toUnstyled = rtfeldman$elm_css$VirtualDom$Styled$toUnstyled;
var author$project$Data$Document$toBrowserDocument = function (_n0) {
	var title = _n0.title;
	var body = _n0.body;
	return {
		body: A2(elm$core$List$map, rtfeldman$elm_css$Html$Styled$toUnstyled, body),
		title: function () {
			if (title.$ === 'Nothing') {
				return author$project$Data$Document$titleRoot;
			} else {
				var title_ = title.a;
				return A2(
					elm$core$String$join,
					' ',
					_List_fromArray(
						[author$project$Data$Document$titleRoot, '|', title_]));
			}
		}()
	};
};
var author$project$Main$UrlRequested = function (a) {
	return {$: 'UrlRequested', a: a};
};
var author$project$Data$NavKey$NavKey = function (a) {
	return {$: 'NavKey', a: a};
};
var author$project$Data$NavKey$fromNativeKey = author$project$Data$NavKey$NavKey;
var author$project$Data$Tracking$event = function (name) {
	return elm$core$Maybe$Just(
		{name: name, props: _List_Nil});
};
var elm$core$String$replace = F3(
	function (before, after, string) {
		return A2(
			elm$core$String$join,
			after,
			A2(elm$core$String$split, before, string));
	});
var author$project$Data$Tracking$encodeString = A2(elm$core$String$replace, ' ', '_');
var author$project$Ports$withProp = F3(
	function (propName, value, _n0) {
		var name = _n0.name;
		var props = _n0.props;
		return {
			name: name,
			props: A2(
				elm$core$List$cons,
				_Utils_Tuple2(propName, value),
				props)
		};
	});
var elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var author$project$Data$Tracking$encodeProps = function (remainingProps) {
	if (!remainingProps.b) {
		return elm$core$Basics$identity;
	} else {
		var _n1 = remainingProps.a;
		var propName = _n1.a;
		var propValue = _n1.b;
		var rest = remainingProps.b;
		return A2(
			elm$core$Basics$composeR,
			A2(
				author$project$Ports$withProp,
				author$project$Data$Tracking$encodeString(propName),
				propValue),
			author$project$Data$Tracking$encodeProps(rest));
	}
};
var author$project$Ports$payload = function (name) {
	return {
		name: A3(elm$core$String$replace, ' ', '_', name),
		props: _List_Nil
	};
};
var author$project$Ports$toJs = _Platform_outgoingPort('toJs', elm$core$Basics$identity);
var elm$core$Tuple$pair = F2(
	function (a, b) {
		return _Utils_Tuple2(a, b);
	});
var elm$json$Json$Encode$null = _Json_encodeNull;
var elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			elm$core$List$foldl,
			F2(
				function (_n0, obj) {
					var k = _n0.a;
					var v = _n0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(_Utils_Tuple0),
			pairs));
};
var elm$json$Json$Encode$string = _Json_wrap;
var author$project$Ports$send = function (_n0) {
	var name = _n0.name;
	var props = _n0.props;
	var encodedProps = elm$core$List$isEmpty(props) ? elm$json$Json$Encode$null : elm$json$Json$Encode$object(props);
	return author$project$Ports$toJs(
		elm$json$Json$Encode$object(
			_List_fromArray(
				[
					A2(
					elm$core$Tuple$pair,
					'name',
					elm$json$Json$Encode$string(name)),
					A2(elm$core$Tuple$pair, 'props', encodedProps)
				])));
};
var author$project$Ports$withString = F2(
	function (propName, stringValue) {
		return A2(
			author$project$Ports$withProp,
			propName,
			elm$json$Json$Encode$string(stringValue));
	});
var elm$core$Platform$Cmd$batch = _Platform_batch;
var elm$core$Platform$Cmd$none = elm$core$Platform$Cmd$batch(_List_Nil);
var author$project$Data$Tracking$send = function (maybeEvent) {
	if (maybeEvent.$ === 'Just') {
		var name = maybeEvent.a.name;
		var props = maybeEvent.a.props;
		return author$project$Ports$send(
			A2(
				author$project$Data$Tracking$encodeProps,
				props,
				A3(
					author$project$Ports$withString,
					'name',
					name,
					author$project$Ports$payload('track'))));
	} else {
		return elm$core$Platform$Cmd$none;
	}
};
var author$project$Data$Tracking$withProp = F3(
	function (propName, value, maybeEvent) {
		if (maybeEvent.$ === 'Just') {
			var event_ = maybeEvent.a;
			return elm$core$Maybe$Just(
				_Utils_update(
					event_,
					{
						props: A2(
							elm$core$List$cons,
							_Utils_Tuple2(propName, value),
							event_.props)
					}));
		} else {
			return elm$core$Maybe$Nothing;
		}
	});
var author$project$Data$Tracking$withString = function (propName) {
	return A2(
		elm$core$Basics$composeR,
		author$project$Data$Tracking$encodeString,
		A2(
			elm$core$Basics$composeR,
			elm$json$Json$Encode$string,
			author$project$Data$Tracking$withProp(propName)));
};
var author$project$Main$UrlChanged = function (a) {
	return {$: 'UrlChanged', a: a};
};
var author$project$Route$About = {$: 'About'};
var author$project$Route$Landing = {$: 'Landing'};
var author$project$Route$Login = {$: 'Login'};
var author$project$Route$Logout = {$: 'Logout'};
var author$project$Route$PaintApp = function (a) {
	return {$: 'PaintApp', a: a};
};
var author$project$Route$ResetPassword = {$: 'ResetPassword'};
var author$project$Route$Settings = {$: 'Settings'};
var Chadtech$elm_relational_database$Id$Id = function (a) {
	return {$: 'Id', a: a};
};
var Chadtech$elm_relational_database$Id$fromString = Chadtech$elm_relational_database$Id$Id;
var author$project$Data$BackgroundColor$Black = {$: 'Black'};
var author$project$Data$BackgroundColor$black = author$project$Data$BackgroundColor$Black;
var author$project$Data$BackgroundColor$White = {$: 'White'};
var author$project$Data$BackgroundColor$white = author$project$Data$BackgroundColor$White;
var author$project$Data$BackgroundColor$queryParser = function (params) {
	queryParser:
	while (true) {
		if (!params.b) {
			return elm$core$Maybe$Nothing;
		} else {
			switch (params.a) {
				case 'black':
					return elm$core$Maybe$Just(author$project$Data$BackgroundColor$black);
				case 'white':
					return elm$core$Maybe$Just(author$project$Data$BackgroundColor$white);
				default:
					var rest = params.b;
					var $temp$params = rest;
					params = $temp$params;
					continue queryParser;
			}
		}
	}
};
var author$project$Route$PaintApp$FromDrawing = function (a) {
	return {$: 'FromDrawing', a: a};
};
var author$project$Route$PaintApp$FromUrl = function (a) {
	return {$: 'FromUrl', a: a};
};
var author$project$Route$PaintApp$Landing = {$: 'Landing'};
var author$project$Route$PaintApp$WithParams = function (a) {
	return {$: 'WithParams', a: a};
};
var author$project$Data$Size$Size = F2(
	function (width, height) {
		return {height: height, width: width};
	});
var elm$core$Maybe$map2 = F3(
	function (func, ma, mb) {
		if (ma.$ === 'Nothing') {
			return elm$core$Maybe$Nothing;
		} else {
			var a = ma.a;
			if (mb.$ === 'Nothing') {
				return elm$core$Maybe$Nothing;
			} else {
				var b = mb.a;
				return elm$core$Maybe$Just(
					A2(func, a, b));
			}
		}
	});
var author$project$Route$PaintApp$toParams = F4(
	function (maybeWidth, maybeHeight, maybeBackgroundColor, maybeName) {
		return {
			backgroundColor: maybeBackgroundColor,
			dimensions: A3(elm$core$Maybe$map2, author$project$Data$Size$Size, maybeWidth, maybeHeight),
			name: maybeName
		};
	});
var elm$url$Url$Parser$Parser = function (a) {
	return {$: 'Parser', a: a};
};
var elm$url$Url$Parser$State = F5(
	function (visited, unvisited, params, frag, value) {
		return {frag: frag, params: params, unvisited: unvisited, value: value, visited: visited};
	});
var elm$url$Url$Parser$mapState = F2(
	function (func, _n0) {
		var visited = _n0.visited;
		var unvisited = _n0.unvisited;
		var params = _n0.params;
		var frag = _n0.frag;
		var value = _n0.value;
		return A5(
			elm$url$Url$Parser$State,
			visited,
			unvisited,
			params,
			frag,
			func(value));
	});
var elm$url$Url$Parser$map = F2(
	function (subValue, _n0) {
		var parseArg = _n0.a;
		return elm$url$Url$Parser$Parser(
			function (_n1) {
				var visited = _n1.visited;
				var unvisited = _n1.unvisited;
				var params = _n1.params;
				var frag = _n1.frag;
				var value = _n1.value;
				return A2(
					elm$core$List$map,
					elm$url$Url$Parser$mapState(value),
					parseArg(
						A5(elm$url$Url$Parser$State, visited, unvisited, params, frag, subValue)));
			});
	});
var elm$url$Url$Parser$oneOf = function (parsers) {
	return elm$url$Url$Parser$Parser(
		function (state) {
			return A2(
				elm$core$List$concatMap,
				function (_n0) {
					var parser = _n0.a;
					return parser(state);
				},
				parsers);
		});
};
var elm$url$Url$Parser$query = function (_n0) {
	var queryParser = _n0.a;
	return elm$url$Url$Parser$Parser(
		function (_n1) {
			var visited = _n1.visited;
			var unvisited = _n1.unvisited;
			var params = _n1.params;
			var frag = _n1.frag;
			var value = _n1.value;
			return _List_fromArray(
				[
					A5(
					elm$url$Url$Parser$State,
					visited,
					unvisited,
					params,
					frag,
					value(
						queryParser(params)))
				]);
		});
};
var elm$url$Url$Parser$slash = F2(
	function (_n0, _n1) {
		var parseBefore = _n0.a;
		var parseAfter = _n1.a;
		return elm$url$Url$Parser$Parser(
			function (state) {
				return A2(
					elm$core$List$concatMap,
					parseAfter,
					parseBefore(state));
			});
	});
var elm$url$Url$Parser$questionMark = F2(
	function (parser, queryParser) {
		return A2(
			elm$url$Url$Parser$slash,
			parser,
			elm$url$Url$Parser$query(queryParser));
	});
var elm$url$Url$Parser$s = function (str) {
	return elm$url$Url$Parser$Parser(
		function (_n0) {
			var visited = _n0.visited;
			var unvisited = _n0.unvisited;
			var params = _n0.params;
			var frag = _n0.frag;
			var value = _n0.value;
			if (!unvisited.b) {
				return _List_Nil;
			} else {
				var next = unvisited.a;
				var rest = unvisited.b;
				return _Utils_eq(next, str) ? _List_fromArray(
					[
						A5(
						elm$url$Url$Parser$State,
						A2(elm$core$List$cons, next, visited),
						rest,
						params,
						frag,
						value)
					]) : _List_Nil;
			}
		});
};
var elm$url$Url$Parser$custom = F2(
	function (tipe, stringToSomething) {
		return elm$url$Url$Parser$Parser(
			function (_n0) {
				var visited = _n0.visited;
				var unvisited = _n0.unvisited;
				var params = _n0.params;
				var frag = _n0.frag;
				var value = _n0.value;
				if (!unvisited.b) {
					return _List_Nil;
				} else {
					var next = unvisited.a;
					var rest = unvisited.b;
					var _n2 = stringToSomething(next);
					if (_n2.$ === 'Just') {
						var nextValue = _n2.a;
						return _List_fromArray(
							[
								A5(
								elm$url$Url$Parser$State,
								A2(elm$core$List$cons, next, visited),
								rest,
								params,
								frag,
								value(nextValue))
							]);
					} else {
						return _List_Nil;
					}
				}
			});
	});
var elm$url$Url$Parser$string = A2(elm$url$Url$Parser$custom, 'STRING', elm$core$Maybe$Just);
var elm$url$Url$Parser$top = elm$url$Url$Parser$Parser(
	function (state) {
		return _List_fromArray(
			[state]);
	});
var elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _n1 = A2(elm$core$Basics$compare, targetKey, key);
				switch (_n1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var elm$url$Url$Parser$Internal$Parser = function (a) {
	return {$: 'Parser', a: a};
};
var elm$url$Url$Parser$Query$custom = F2(
	function (key, func) {
		return elm$url$Url$Parser$Internal$Parser(
			function (dict) {
				return func(
					A2(
						elm$core$Maybe$withDefault,
						_List_Nil,
						A2(elm$core$Dict$get, key, dict)));
			});
	});
var elm$core$String$toInt = _String_toInt;
var elm$url$Url$Parser$Query$int = function (key) {
	return A2(
		elm$url$Url$Parser$Query$custom,
		key,
		function (stringList) {
			if (stringList.b && (!stringList.b.b)) {
				var str = stringList.a;
				return elm$core$String$toInt(str);
			} else {
				return elm$core$Maybe$Nothing;
			}
		});
};
var elm$url$Url$Parser$Query$string = function (key) {
	return A2(
		elm$url$Url$Parser$Query$custom,
		key,
		function (stringList) {
			if (stringList.b && (!stringList.b.b)) {
				var str = stringList.a;
				return elm$core$Maybe$Just(str);
			} else {
				return elm$core$Maybe$Nothing;
			}
		});
};
var author$project$Route$PaintApp$parser = elm$url$Url$Parser$oneOf(
	_List_fromArray(
		[
			A2(elm$url$Url$Parser$map, author$project$Route$PaintApp$Landing, elm$url$Url$Parser$top),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$PaintApp$WithParams,
			A2(
				elm$url$Url$Parser$map,
				author$project$Route$PaintApp$toParams,
				A2(
					elm$url$Url$Parser$questionMark,
					A2(
						elm$url$Url$Parser$questionMark,
						A2(
							elm$url$Url$Parser$questionMark,
							A2(
								elm$url$Url$Parser$questionMark,
								elm$url$Url$Parser$top,
								elm$url$Url$Parser$Query$int('width')),
							elm$url$Url$Parser$Query$int('height')),
						A2(elm$url$Url$Parser$Query$custom, 'background_color', author$project$Data$BackgroundColor$queryParser)),
					elm$url$Url$Parser$Query$string('name')))),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$PaintApp$FromUrl,
			A2(
				elm$url$Url$Parser$slash,
				elm$url$Url$Parser$s('url'),
				elm$url$Url$Parser$string)),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$PaintApp$FromDrawing,
			A2(
				elm$url$Url$Parser$slash,
				elm$url$Url$Parser$s('id'),
				A2(elm$url$Url$Parser$map, Chadtech$elm_relational_database$Id$fromString, elm$url$Url$Parser$string)))
		]));
var author$project$Route$parser = elm$url$Url$Parser$oneOf(
	_List_fromArray(
		[
			A2(elm$url$Url$Parser$map, author$project$Route$Landing, elm$url$Url$Parser$top),
			A2(elm$url$Url$Parser$map, author$project$Route$PaintApp, author$project$Route$PaintApp$parser),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$About,
			elm$url$Url$Parser$s('about')),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$Login,
			elm$url$Url$Parser$s('login')),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$ResetPassword,
			elm$url$Url$Parser$s('resetpassword')),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$Logout,
			elm$url$Url$Parser$s('logout')),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$Settings,
			elm$url$Url$Parser$s('settings'))
		]));
var elm$url$Url$Parser$getFirstMatch = function (states) {
	getFirstMatch:
	while (true) {
		if (!states.b) {
			return elm$core$Maybe$Nothing;
		} else {
			var state = states.a;
			var rest = states.b;
			var _n1 = state.unvisited;
			if (!_n1.b) {
				return elm$core$Maybe$Just(state.value);
			} else {
				if ((_n1.a === '') && (!_n1.b.b)) {
					return elm$core$Maybe$Just(state.value);
				} else {
					var $temp$states = rest;
					states = $temp$states;
					continue getFirstMatch;
				}
			}
		}
	}
};
var elm$url$Url$Parser$removeFinalEmpty = function (segments) {
	if (!segments.b) {
		return _List_Nil;
	} else {
		if ((segments.a === '') && (!segments.b.b)) {
			return _List_Nil;
		} else {
			var segment = segments.a;
			var rest = segments.b;
			return A2(
				elm$core$List$cons,
				segment,
				elm$url$Url$Parser$removeFinalEmpty(rest));
		}
	}
};
var elm$url$Url$Parser$preparePath = function (path) {
	var _n0 = A2(elm$core$String$split, '/', path);
	if (_n0.b && (_n0.a === '')) {
		var segments = _n0.b;
		return elm$url$Url$Parser$removeFinalEmpty(segments);
	} else {
		var segments = _n0;
		return elm$url$Url$Parser$removeFinalEmpty(segments);
	}
};
var elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n1 = dict.d;
			var lClr = _n1.a;
			var lK = _n1.b;
			var lV = _n1.c;
			var lLeft = _n1.d;
			var lRight = _n1.e;
			var _n2 = dict.e;
			var rClr = _n2.a;
			var rK = _n2.b;
			var rV = _n2.c;
			var rLeft = _n2.d;
			var _n3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _n2.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n4 = dict.d;
			var lClr = _n4.a;
			var lK = _n4.b;
			var lV = _n4.c;
			var lLeft = _n4.d;
			var lRight = _n4.e;
			var _n5 = dict.e;
			var rClr = _n5.a;
			var rK = _n5.b;
			var rV = _n5.c;
			var rLeft = _n5.d;
			var rRight = _n5.e;
			if (clr.$ === 'Black') {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n1 = dict.d;
			var lClr = _n1.a;
			var lK = _n1.b;
			var lV = _n1.c;
			var _n2 = _n1.d;
			var _n3 = _n2.a;
			var llK = _n2.b;
			var llV = _n2.c;
			var llLeft = _n2.d;
			var llRight = _n2.e;
			var lRight = _n1.e;
			var _n4 = dict.e;
			var rClr = _n4.a;
			var rK = _n4.b;
			var rV = _n4.c;
			var rLeft = _n4.d;
			var rRight = _n4.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				elm$core$Dict$Red,
				lK,
				lV,
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n5 = dict.d;
			var lClr = _n5.a;
			var lK = _n5.b;
			var lV = _n5.c;
			var lLeft = _n5.d;
			var lRight = _n5.e;
			var _n6 = dict.e;
			var rClr = _n6.a;
			var rK = _n6.b;
			var rV = _n6.c;
			var rLeft = _n6.d;
			var rRight = _n6.e;
			if (clr.$ === 'Black') {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _n1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_n2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _n3 = right.a;
							var _n4 = right.d;
							var _n5 = _n4.a;
							return elm$core$Dict$moveRedRight(dict);
						} else {
							break _n2$2;
						}
					} else {
						var _n6 = right.a;
						var _n7 = right.d;
						return elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _n2$2;
				}
			}
			return dict;
		}
	});
var elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _n3 = lLeft.a;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					elm$core$Dict$removeMin(left),
					right);
			} else {
				var _n4 = elm$core$Dict$moveRedLeft(dict);
				if (_n4.$ === 'RBNode_elm_builtin') {
					var nColor = _n4.a;
					var nKey = _n4.b;
					var nValue = _n4.c;
					var nLeft = _n4.d;
					var nRight = _n4.e;
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _n4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _n6 = lLeft.a;
						return A5(
							elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2(elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _n7 = elm$core$Dict$moveRedLeft(dict);
						if (_n7.$ === 'RBNode_elm_builtin') {
							var nColor = _n7.a;
							var nKey = _n7.b;
							var nValue = _n7.c;
							var nLeft = _n7.d;
							var nRight = _n7.e;
							return A5(
								elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2(elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2(elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7(elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _n1 = elm$core$Dict$getMin(right);
				if (_n1.$ === 'RBNode_elm_builtin') {
					var minKey = _n1.b;
					var minValue = _n1.c;
					return A5(
						elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						elm$core$Dict$removeMin(right));
				} else {
					return elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2(elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var elm$core$Dict$remove = F2(
	function (key, dict) {
		var _n0 = A2(elm$core$Dict$removeHelp, key, dict);
		if ((_n0.$ === 'RBNode_elm_builtin') && (_n0.a.$ === 'Red')) {
			var _n1 = _n0.a;
			var k = _n0.b;
			var v = _n0.c;
			var l = _n0.d;
			var r = _n0.e;
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _n0;
			return x;
		}
	});
var elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _n0 = alter(
			A2(elm$core$Dict$get, targetKey, dictionary));
		if (_n0.$ === 'Just') {
			var value = _n0.a;
			return A3(elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2(elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var elm$url$Url$percentDecode = _Url_percentDecode;
var elm$url$Url$Parser$addToParametersHelp = F2(
	function (value, maybeList) {
		if (maybeList.$ === 'Nothing') {
			return elm$core$Maybe$Just(
				_List_fromArray(
					[value]));
		} else {
			var list = maybeList.a;
			return elm$core$Maybe$Just(
				A2(elm$core$List$cons, value, list));
		}
	});
var elm$url$Url$Parser$addParam = F2(
	function (segment, dict) {
		var _n0 = A2(elm$core$String$split, '=', segment);
		if ((_n0.b && _n0.b.b) && (!_n0.b.b.b)) {
			var rawKey = _n0.a;
			var _n1 = _n0.b;
			var rawValue = _n1.a;
			var _n2 = elm$url$Url$percentDecode(rawKey);
			if (_n2.$ === 'Nothing') {
				return dict;
			} else {
				var key = _n2.a;
				var _n3 = elm$url$Url$percentDecode(rawValue);
				if (_n3.$ === 'Nothing') {
					return dict;
				} else {
					var value = _n3.a;
					return A3(
						elm$core$Dict$update,
						key,
						elm$url$Url$Parser$addToParametersHelp(value),
						dict);
				}
			}
		} else {
			return dict;
		}
	});
var elm$url$Url$Parser$prepareQuery = function (maybeQuery) {
	if (maybeQuery.$ === 'Nothing') {
		return elm$core$Dict$empty;
	} else {
		var qry = maybeQuery.a;
		return A3(
			elm$core$List$foldr,
			elm$url$Url$Parser$addParam,
			elm$core$Dict$empty,
			A2(elm$core$String$split, '&', qry));
	}
};
var elm$url$Url$Parser$parse = F2(
	function (_n0, url) {
		var parser = _n0.a;
		return elm$url$Url$Parser$getFirstMatch(
			parser(
				A5(
					elm$url$Url$Parser$State,
					_List_Nil,
					elm$url$Url$Parser$preparePath(url.path),
					elm$url$Url$Parser$prepareQuery(url.query),
					url.fragment,
					elm$core$Basics$identity)));
	});
var author$project$Route$fromUrl = function (url) {
	var _n0 = A2(elm$url$Url$Parser$parse, author$project$Route$parser, url);
	if (_n0.$ === 'Just') {
		var route = _n0.a;
		return elm$core$Result$Ok(route);
	} else {
		return elm$core$Result$Err(url.path);
	}
};
var author$project$Main$onNavigation = A2(elm$core$Basics$composeR, author$project$Route$fromUrl, author$project$Main$UrlChanged);
var author$project$Data$BuildNumber$toString = function (_n0) {
	var _int = _n0.a;
	return elm$core$String$fromInt(_int);
};
var Chadtech$elm_relational_database$Id$encode = function (_n0) {
	var str = _n0.a;
	return elm$json$Json$Encode$string(str);
};
var author$project$Data$SessionId$encode = function (_n0) {
	var sessionId = _n0.a;
	return Chadtech$elm_relational_database$Id$encode(sessionId);
};
var author$project$Page$Contact$track = function (msg) {
	if (msg.$ === 'SendClicked') {
		return author$project$Data$Tracking$event('submit click');
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var author$project$Util$Json$Decode$errorToSanitizedString = function (error) {
	switch (error.$) {
		case 'Field':
			var string = error.a;
			var fieldError = error.b;
			return A2(
				elm$core$String$join,
				' ',
				_List_fromArray(
					[
						'error at field',
						string,
						'->',
						author$project$Util$Json$Decode$errorToSanitizedString(fieldError)
					]));
		case 'Index':
			var index = error.a;
			var indexError = error.b;
			return A2(
				elm$core$String$join,
				' ',
				_List_fromArray(
					[
						'error at index',
						elm$core$String$fromInt(index),
						'->',
						author$project$Util$Json$Decode$errorToSanitizedString(indexError)
					]));
		case 'OneOf':
			var errors = error.a;
			return A2(
				elm$core$String$join,
				' ',
				_List_fromArray(
					[
						'error in these attempts ->',
						A2(
						elm$core$String$join,
						', ',
						A2(elm$core$List$map, author$project$Util$Json$Decode$errorToSanitizedString, errors))
					]));
		default:
			var string = error.a;
			return string;
	}
};
var author$project$Data$Listener$errorToString = F2(
	function (customToString, error) {
		if (error.$ === 'DecodeError') {
			var decodeError = error.a;
			return author$project$Util$Json$Decode$errorToSanitizedString(decodeError);
		} else {
			var customError = error.a;
			return customToString(customError);
		}
	});
var author$project$Data$Tracking$withResult = F2(
	function (encodeError, result) {
		if (result.$ === 'Ok') {
			return A2(author$project$Data$Tracking$withString, 'response', 'Ok');
		} else {
			var error = result.a;
			return A2(
				elm$core$Basics$composeR,
				A2(author$project$Data$Tracking$withString, 'response', 'Error'),
				A2(
					author$project$Data$Tracking$withString,
					'error',
					encodeError(error)));
		}
	});
var author$project$Data$Tracking$withListenerResponse = author$project$Data$Tracking$withResult(
	author$project$Data$Listener$errorToString(elm$core$Basics$identity));
var author$project$Data$BackgroundColor$toString = function (color) {
	if (color.$ === 'Black') {
		return 'black';
	} else {
		return 'white';
	}
};
var elm$json$Json$Encode$bool = _Json_wrap;
var author$project$Data$Tracking$withBool = function (propName) {
	return A2(
		elm$core$Basics$composeR,
		elm$json$Json$Encode$bool,
		author$project$Data$Tracking$withProp(propName));
};
var author$project$Ui$InitDrawing$track = function (msg) {
	switch (msg.$) {
		case 'FromUrlClicked':
			var disabled = msg.a;
			return A3(
				author$project$Data$Tracking$withBool,
				'disabled',
				disabled,
				author$project$Data$Tracking$event('from-url click'));
		case 'ColorClicked':
			var bgColor = msg.a;
			return A3(
				author$project$Data$Tracking$withString,
				'color',
				author$project$Data$BackgroundColor$toString(bgColor),
				author$project$Data$Tracking$event('color click'));
		case 'StartNewDrawingClicked':
			return author$project$Data$Tracking$event('submit click');
		case 'UrlUpdated':
			return elm$core$Maybe$Nothing;
		case 'WidthUpdated':
			return elm$core$Maybe$Nothing;
		case 'HeightUpdated':
			return elm$core$Maybe$Nothing;
		default:
			return elm$core$Maybe$Nothing;
	}
};
var author$project$Page$Home$track = function (msg) {
	switch (msg.$) {
		case 'DrawingClicked':
			return author$project$Data$Tracking$event('drawing clicked');
		case 'NewDrawingClicked':
			return author$project$Data$Tracking$event('new drawing clicked');
		case 'CloseDrawingClicked':
			return author$project$Data$Tracking$event('close drawing clicked');
		case 'CloseNewDrawingClicked':
			return author$project$Data$Tracking$event('close new drawing clicked');
		case 'InitDrawingMsg':
			var subMsg = msg.a;
			return author$project$Ui$InitDrawing$track(subMsg);
		case 'OpenDrawingInPaintAppClicked':
			return author$project$Data$Tracking$event('open drawing in paint app clicked');
		case 'OpenDrawingLinkClicked':
			return author$project$Data$Tracking$event('open drawing link clicked');
		case 'DeleteDrawingClicked':
			return author$project$Data$Tracking$event('delete drawing clicked');
		case 'DeleteYesClicked':
			return author$project$Data$Tracking$event('delete yes clicked');
		case 'DeleteNoClicked':
			return author$project$Data$Tracking$event('delete no clicked');
		case 'MakeADrawingClicked':
			return author$project$Data$Tracking$event('make a drawing clicked');
		case 'RefreshClicked':
			return author$project$Data$Tracking$event('refresh clicked');
		case 'BackToDrawingsClicked':
			return author$project$Data$Tracking$event('back to drawings clicked');
		case 'TryAgainClicked':
			return author$project$Data$Tracking$event('try again clicked');
		default:
			var response = msg.a;
			return A2(
				author$project$Data$Tracking$withListenerResponse,
				response,
				author$project$Data$Tracking$event('got all drawings'));
	}
};
var author$project$Data$Tracking$tag = function (propName) {
	return A2(author$project$Data$Tracking$withProp, propName, elm$json$Json$Encode$null);
};
var author$project$Data$Listener$DecodeError = function (a) {
	return {$: 'DecodeError', a: a};
};
var author$project$Data$Listener$Error = function (a) {
	return {$: 'Error', a: a};
};
var author$project$Data$Listener$mapError = F2(
	function (f, response) {
		if (response.$ === 'Ok') {
			var value = response.a;
			return elm$core$Result$Ok(value);
		} else {
			var error = response.a;
			if (error.$ === 'DecodeError') {
				var decodeError = error.a;
				return elm$core$Result$Err(
					author$project$Data$Listener$DecodeError(decodeError));
			} else {
				var customError = error.a;
				return elm$core$Result$Err(
					author$project$Data$Listener$Error(
						f(customError)));
			}
		}
	});
var author$project$Ui$LoginCard$ForgotPassword$errorToId = function (error) {
	return 'user doesnt exist';
};
var author$project$Ui$LoginCard$ForgotPassword$trackReady = function (msg) {
	switch (msg.$) {
		case 'EmailUpdated':
			return elm$core$Maybe$Nothing;
		case 'ResetPasswordClicked':
			return author$project$Data$Tracking$event('reset password clicked');
		default:
			return author$project$Data$Tracking$event('enter pressed');
	}
};
var author$project$Ui$LoginCard$ForgotPassword$track = function (msg) {
	if (msg.$ === 'ReadyMsg') {
		var readyMsg = msg.a;
		return author$project$Ui$LoginCard$ForgotPassword$trackReady(readyMsg);
	} else {
		var response = msg.a;
		return A2(
			author$project$Data$Tracking$withListenerResponse,
			A2(author$project$Data$Listener$mapError, author$project$Ui$LoginCard$ForgotPassword$errorToId, response),
			author$project$Data$Tracking$event('got forget password response'));
	}
};
var author$project$Ui$LoginCard$Login$errorToId = function (error) {
	if (error.$ === 'IncorrectCredentials') {
		return 'incorrect credentials';
	} else {
		return 'password reset required';
	}
};
var author$project$Ui$LoginCard$Login$track = function (msg) {
	switch (msg.$) {
		case 'EmailUpdated':
			return elm$core$Maybe$Nothing;
		case 'PasswordUpdated':
			return elm$core$Maybe$Nothing;
		case 'EnterPressed':
			return author$project$Data$Tracking$event('enter press');
		case 'LoginClicked':
			return author$project$Data$Tracking$event('login click');
		case 'ForgotPasswordClicked':
			return author$project$Data$Tracking$event('forgot password click');
		case 'GotLoginResponse':
			var response = msg.a;
			return A2(
				author$project$Data$Tracking$withListenerResponse,
				A2(author$project$Data$Listener$mapError, author$project$Ui$LoginCard$Login$errorToId, response),
				author$project$Data$Tracking$event('got login response'));
		default:
			return author$project$Data$Tracking$event('try again clicked');
	}
};
var author$project$Ui$LoginCard$track = function (msg) {
	return A2(
		author$project$Data$Tracking$tag,
		'login-card',
		function () {
			if (msg.$ === 'LoginMsg') {
				var subMsg = msg.a;
				return author$project$Ui$LoginCard$Login$track(subMsg);
			} else {
				var subMsg = msg.a;
				return A2(
					author$project$Data$Tracking$tag,
					'forgot-password',
					author$project$Ui$LoginCard$ForgotPassword$track(subMsg));
			}
		}());
};
var author$project$Page$Login$track = function (msg) {
	var subMsg = msg.a;
	return author$project$Ui$LoginCard$track(subMsg);
};
var author$project$Page$PageNotFound$track = function (msg) {
	return author$project$Data$Tracking$event('go home clicked');
};
var author$project$Page$ResetPassword$errorToString = function (error) {
	if (error.$ === 'InvalidCode') {
		return 'invalid code';
	} else {
		var str = error.a;
		return str;
	}
};
var author$project$Page$ResetPassword$track = function (msg) {
	switch (msg.$) {
		case 'GotResetPasswordResponse':
			var response = msg.a;
			return A2(
				author$project$Data$Tracking$withListenerResponse,
				A2(author$project$Data$Listener$mapError, author$project$Page$ResetPassword$errorToString, response),
				author$project$Data$Tracking$event('got reset password response'));
		case 'LoginClicked':
			return author$project$Data$Tracking$event('login clicked');
		case 'TryAgainClicked':
			return author$project$Data$Tracking$event('try again clicked');
		case 'EmailUpdated':
			return elm$core$Maybe$Nothing;
		case 'CodeUpdated':
			return elm$core$Maybe$Nothing;
		case 'PasswordUpdated':
			return elm$core$Maybe$Nothing;
		case 'PasswordConfirmUpdated':
			return elm$core$Maybe$Nothing;
		case 'EnterPressed':
			return author$project$Data$Tracking$event('enter pressed');
		default:
			return author$project$Data$Tracking$event('reset password clicked');
	}
};
var author$project$Page$Settings$tabToLabel = function (tab) {
	if (tab.$ === 'Account') {
		return 'account';
	} else {
		return 'key config';
	}
};
var author$project$Page$Settings$track = function (msg) {
	switch (msg.$) {
		case 'TabClickedOn':
			var tab = msg.a;
			return A3(
				author$project$Data$Tracking$withString,
				'tab',
				author$project$Page$Settings$tabToLabel(tab),
				author$project$Data$Tracking$event('tab clicked'));
		case 'NameUpdated':
			return elm$core$Maybe$Nothing;
		case 'SaveClicked':
			return author$project$Data$Tracking$event('save clicked');
		default:
			var response = msg.a;
			return A2(
				author$project$Data$Tracking$withListenerResponse,
				response,
				author$project$Data$Tracking$event('got save response'));
	}
};
var author$project$Page$Splash$track = function (msg) {
	if (msg.$ === 'LearnMoreClicked') {
		return author$project$Data$Tracking$event('learn-more click');
	} else {
		return author$project$Data$Tracking$event('draw click');
	}
};
var author$project$Ui$Nav$Option$toLabel = function (option) {
	switch (option.$) {
		case 'Draw':
			return 'draw';
		case 'Title':
			return 'title';
		case 'About':
			return 'about';
		case 'Login':
			return 'log in';
		case 'Logout':
			return 'log out';
		default:
			return 'settings';
	}
};
var author$project$Ui$Nav$Option$encode = A2(elm$core$Basics$composeR, author$project$Ui$Nav$Option$toLabel, elm$json$Json$Encode$string);
var author$project$Ui$Nav$track = function (msg) {
	var option = msg.a;
	return A3(
		author$project$Data$Tracking$withProp,
		'option',
		author$project$Ui$Nav$Option$encode(option),
		author$project$Data$Tracking$event('nav bar option clicked'));
};
var author$project$Main$trackPage = function (msg) {
	switch (msg.$) {
		case 'UrlChanged':
			return elm$core$Maybe$Nothing;
		case 'UrlRequested':
			return elm$core$Maybe$Nothing;
		case 'ListenerNotFound':
			var listener = msg.a;
			return A3(
				author$project$Data$Tracking$withString,
				'listener',
				listener,
				author$project$Data$Tracking$event('listener not found'));
		case 'FailedToDecodeJsMsg':
			return author$project$Data$Tracking$event('failed to decode js msg');
		case 'NavMsg':
			var subMsg = msg.a;
			return author$project$Ui$Nav$track(subMsg);
		case 'SplashMsg':
			var subMsg = msg.a;
			return author$project$Page$Splash$track(subMsg);
		case 'LoginMsg':
			var subMsg = msg.a;
			return author$project$Page$Login$track(subMsg);
		case 'ResetPasswordMsg':
			var subMsg = msg.a;
			return author$project$Page$ResetPassword$track(subMsg);
		case 'PageNotFoundMsg':
			var subMsg = msg.a;
			return author$project$Page$PageNotFound$track(subMsg);
		case 'HomeMsg':
			var subMsg = msg.a;
			return author$project$Page$Home$track(subMsg);
		case 'SettingsMsg':
			var subMsg = msg.a;
			return author$project$Page$Settings$track(subMsg);
		case 'ContactMsg':
			var subMsg = msg.a;
			return author$project$Page$Contact$track(subMsg);
		case 'WindowResized':
			return elm$core$Maybe$Nothing;
		default:
			return elm$core$Maybe$Nothing;
	}
};
var author$project$Page$Contact$getSession = function ($) {
	return $.session;
};
var author$project$Page$Home$getSession = function ($) {
	return $.session;
};
var author$project$Page$Login$getSession = function ($) {
	return $.session;
};
var author$project$Page$Logout$getSession = function ($) {
	return $.session;
};
var author$project$Page$PaintApp$getSession = function ($) {
	return $.session;
};
var author$project$Page$ResetPassword$getSession = function ($) {
	return $.session;
};
var author$project$Page$Settings$getSession = function ($) {
	return $.session;
};
var author$project$Model$getSession = function (model) {
	switch (model.$) {
		case 'Blank':
			var session = model.a.session;
			return session;
		case 'PageNotFound':
			var session = model.a.session;
			return session;
		case 'PaintApp':
			var subModel = model.a;
			return author$project$Page$PaintApp$getSession(subModel);
		case 'Splash':
			var session = model.a;
			return session;
		case 'About':
			var session = model.a.session;
			return session;
		case 'Login':
			var subModel = model.a;
			return author$project$Page$Login$getSession(subModel);
		case 'ResetPassword':
			var subModel = model.a;
			return author$project$Page$ResetPassword$getSession(subModel);
		case 'Settings':
			var subModel = model.a;
			return author$project$Page$Settings$getSession(subModel);
		case 'Home':
			var subModel = model.a;
			return author$project$Page$Home$getSession(subModel);
		case 'Logout':
			var subModel = model.a;
			return author$project$Page$Logout$getSession(subModel);
		default:
			var subModel = model.a;
			return author$project$Page$Contact$getSession(subModel);
	}
};
var author$project$Model$pageId = function (model) {
	switch (model.$) {
		case 'Blank':
			return 'blank';
		case 'PageNotFound':
			return 'page-not-found';
		case 'PaintApp':
			return 'paint-app';
		case 'Splash':
			return 'splash';
		case 'About':
			return 'about';
		case 'Login':
			return 'login';
		case 'ResetPassword':
			return 'reset-password';
		case 'Settings':
			return 'settings';
		case 'Home':
			return 'home';
		case 'Logout':
			return 'logout';
		default:
			return 'contact';
	}
};
var author$project$Session$getBuildNumber = function ($) {
	return $.buildNumber;
};
var author$project$Session$getSessionId = function ($) {
	return $.sessionId;
};
var author$project$Main$track = F2(
	function (msg, model) {
		var session = author$project$Model$getSession(model);
		return author$project$Data$Tracking$send(
			A3(
				author$project$Data$Tracking$withString,
				'buildNumber',
				author$project$Data$BuildNumber$toString(
					author$project$Session$getBuildNumber(session)),
				A3(
					author$project$Data$Tracking$withProp,
					'sessionId',
					author$project$Data$SessionId$encode(
						author$project$Session$getSessionId(session)),
					A3(
						author$project$Data$Tracking$withString,
						'page',
						author$project$Model$pageId(model),
						author$project$Main$trackPage(msg)))));
	});
var author$project$Main$HomeMsg = function (a) {
	return {$: 'HomeMsg', a: a};
};
var author$project$Main$LoginMsg = function (a) {
	return {$: 'LoginMsg', a: a};
};
var author$project$Main$NavMsg = function (a) {
	return {$: 'NavMsg', a: a};
};
var author$project$Main$PageNotFoundMsg = function (a) {
	return {$: 'PageNotFoundMsg', a: a};
};
var author$project$Main$ResetPasswordMsg = function (a) {
	return {$: 'ResetPasswordMsg', a: a};
};
var author$project$Main$SettingsMsg = function (a) {
	return {$: 'SettingsMsg', a: a};
};
var author$project$Main$SplashMsg = function (a) {
	return {$: 'SplashMsg', a: a};
};
var author$project$Data$Listener$getName = function (_n0) {
	var name = _n0.a;
	return name;
};
var author$project$Data$Listener$handle = F2(
	function (_n0, json) {
		var handler = _n0.b;
		return handler(json);
	});
var author$project$Main$FailedToDecodeJsMsg = {$: 'FailedToDecodeJsMsg'};
var author$project$Main$ListenerNotFound = function (a) {
	return {$: 'ListenerNotFound', a: a};
};
var author$project$Data$Listener$Listener = F2(
	function (a, b) {
		return {$: 'Listener', a: a, b: b};
	});
var author$project$Data$Listener$map = F2(
	function (f, _n0) {
		var name = _n0.a;
		var handler = _n0.b;
		return A2(
			author$project$Data$Listener$Listener,
			name,
			A2(elm$core$Basics$composeL, f, handler));
	});
var author$project$Data$Listener$mapMany = function (f) {
	return elm$core$List$map(
		author$project$Data$Listener$map(f));
};
var Chadtech$elm_relational_database$Db$Db = function (a) {
	return {$: 'Db', a: a};
};
var Chadtech$elm_relational_database$Id$toString = function (_n0) {
	var str = _n0.a;
	return str;
};
var elm$core$Dict$fromList = function (assocs) {
	return A3(
		elm$core$List$foldl,
		F2(
			function (_n0, dict) {
				var key = _n0.a;
				var value = _n0.b;
				return A3(elm$core$Dict$insert, key, value, dict);
			}),
		elm$core$Dict$empty,
		assocs);
};
var elm$core$Tuple$mapFirst = F2(
	function (func, _n0) {
		var x = _n0.a;
		var y = _n0.b;
		return _Utils_Tuple2(
			func(x),
			y);
	});
var Chadtech$elm_relational_database$Db$fromList = function (items) {
	return Chadtech$elm_relational_database$Db$Db(
		elm$core$Dict$fromList(
			A2(
				elm$core$List$map,
				elm$core$Tuple$mapFirst(Chadtech$elm_relational_database$Id$toString),
				items)));
};
var elm$json$Json$Decode$string = _Json_decodeString;
var Chadtech$elm_relational_database$Id$decoder = A2(elm$json$Json$Decode$map, Chadtech$elm_relational_database$Id$Id, elm$json$Json$Decode$string);
var author$project$Data$Drawing$Drawing = F5(
	function (publicId, data, name, createdAt, updatedAt) {
		return {createdAt: createdAt, data: data, name: name, publicId: publicId, updatedAt: updatedAt};
	});
var author$project$Data$Drawing$PublicId = function (a) {
	return {$: 'PublicId', a: a};
};
var author$project$Util$Json$Decode$apply = function () {
	var applyHelp = F2(
		function (v, f) {
			return f(v);
		});
	return elm$json$Json$Decode$map2(applyHelp);
}();
var elm$json$Json$Decode$field = _Json_decodeField;
var author$project$Util$Json$Decode$applyField = F2(
	function (fieldName, decoder) {
		return author$project$Util$Json$Decode$apply(
			A2(elm$json$Json$Decode$field, fieldName, decoder));
	});
var elm$json$Json$Decode$int = _Json_decodeInt;
var elm$time$Time$Posix = function (a) {
	return {$: 'Posix', a: a};
};
var elm$time$Time$millisToPosix = elm$time$Time$Posix;
var author$project$Util$Posix$decoder = A2(elm$json$Json$Decode$map, elm$time$Time$millisToPosix, elm$json$Json$Decode$int);
var author$project$Data$Drawing$decoder = function () {
	var contentDecoder = A3(
		author$project$Util$Json$Decode$applyField,
		'updatedAt',
		author$project$Util$Posix$decoder,
		A3(
			author$project$Util$Json$Decode$applyField,
			'createdAt',
			author$project$Util$Posix$decoder,
			A3(
				author$project$Util$Json$Decode$applyField,
				'name',
				elm$json$Json$Decode$string,
				A3(
					author$project$Util$Json$Decode$applyField,
					'canvas',
					elm$json$Json$Decode$string,
					A3(
						author$project$Util$Json$Decode$applyField,
						'publicId',
						A2(elm$json$Json$Decode$map, author$project$Data$Drawing$PublicId, elm$json$Json$Decode$string),
						elm$json$Json$Decode$succeed(author$project$Data$Drawing$Drawing))))));
	return A3(
		elm$json$Json$Decode$map2,
		elm$core$Tuple$pair,
		A2(elm$json$Json$Decode$field, 'drawingId', Chadtech$elm_relational_database$Id$decoder),
		contentDecoder);
}();
var elm$core$Result$mapError = F2(
	function (f, result) {
		if (result.$ === 'Ok') {
			var v = result.a;
			return elm$core$Result$Ok(v);
		} else {
			var e = result.a;
			return elm$core$Result$Err(
				f(e));
		}
	});
var elm$json$Json$Decode$decodeValue = _Json_run;
var author$project$Data$Listener$for = function (_n0) {
	var name = _n0.name;
	var decoder = _n0.decoder;
	var handler = _n0.handler;
	var fromJson = function (json) {
		var _n1 = A2(elm$json$Json$Decode$decodeValue, decoder, json);
		if (_n1.$ === 'Ok') {
			var v = _n1.a;
			return A2(elm$core$Result$mapError, author$project$Data$Listener$Error, v);
		} else {
			var decodeError = _n1.a;
			return elm$core$Result$Err(
				author$project$Data$Listener$DecodeError(decodeError));
		}
	};
	return A2(
		author$project$Data$Listener$Listener,
		name,
		A2(elm$core$Basics$composeR, fromJson, handler));
};
var author$project$Page$Home$GotAllDrawings = function (a) {
	return {$: 'GotAllDrawings', a: a};
};
var elm$json$Json$Decode$list = _Json_decodeList;
var elm$json$Json$Decode$oneOf = _Json_oneOf;
var author$project$Page$Home$listeners = _List_fromArray(
	[
		author$project$Data$Listener$for(
		{
			decoder: elm$json$Json$Decode$oneOf(
				_List_fromArray(
					[
						A2(
						elm$json$Json$Decode$map,
						elm$core$Result$Ok,
						A2(
							elm$json$Json$Decode$map,
							Chadtech$elm_relational_database$Db$fromList,
							elm$json$Json$Decode$list(author$project$Data$Drawing$decoder))),
						A2(
						elm$json$Json$Decode$map,
						elm$core$Result$Err,
						A2(elm$json$Json$Decode$field, 'name', elm$json$Json$Decode$string))
					])),
			handler: author$project$Page$Home$GotAllDrawings,
			name: 'drawings'
		})
	]);
var author$project$Page$Login$LoginCardMsg = function (a) {
	return {$: 'LoginCardMsg', a: a};
};
var author$project$Ui$LoginCard$ForgotPasswordMsg = function (a) {
	return {$: 'ForgotPasswordMsg', a: a};
};
var author$project$Ui$LoginCard$LoginMsg = function (a) {
	return {$: 'LoginMsg', a: a};
};
var author$project$Ui$LoginCard$ForgotPassword$GotForgetPasswordResponse = function (a) {
	return {$: 'GotForgetPasswordResponse', a: a};
};
var author$project$Ui$LoginCard$ForgotPassword$UserDoesntExist = {$: 'UserDoesntExist'};
var elm$json$Json$Decode$andThen = _Json_andThen;
var elm$json$Json$Decode$fail = _Json_fail;
var author$project$Util$Json$Decode$matchString = F2(
	function (str, value) {
		var fromString = function (decodedStr) {
			return _Utils_eq(decodedStr, str) ? elm$json$Json$Decode$succeed(value) : elm$json$Json$Decode$fail('String is not ' + str);
		};
		return A2(elm$json$Json$Decode$andThen, fromString, elm$json$Json$Decode$string);
	});
var author$project$Util$Json$Decode$matchStringMany = function () {
	var matchThis = function (_n0) {
		var str = _n0.a;
		var value = _n0.b;
		return A2(author$project$Util$Json$Decode$matchString, str, value);
	};
	return A2(
		elm$core$Basics$composeR,
		elm$core$List$map(matchThis),
		elm$json$Json$Decode$oneOf);
}();
var elm$json$Json$Decode$null = _Json_decodeNull;
var author$project$Ui$LoginCard$ForgotPassword$listener = author$project$Data$Listener$for(
	{
		decoder: elm$json$Json$Decode$oneOf(
			_List_fromArray(
				[
					A2(
					elm$json$Json$Decode$map,
					elm$core$Result$Ok,
					elm$json$Json$Decode$null(_Utils_Tuple0)),
					A2(
					elm$json$Json$Decode$map,
					elm$core$Result$Err,
					A2(
						elm$json$Json$Decode$field,
						'name',
						author$project$Util$Json$Decode$matchStringMany(
							_List_fromArray(
								[
									_Utils_Tuple2('UserNotFoundException', author$project$Ui$LoginCard$ForgotPassword$UserDoesntExist)
								]))))
				])),
		handler: author$project$Ui$LoginCard$ForgotPassword$GotForgetPasswordResponse,
		name: 'forgot password'
	});
var author$project$Data$Account$Account = F2(
	function (email, name) {
		return {email: email, name: name};
	});
var author$project$Data$Account$decoder = A2(
	author$project$Util$Json$Decode$apply,
	A2(elm$json$Json$Decode$field, 'name', elm$json$Json$Decode$string),
	A2(
		author$project$Util$Json$Decode$apply,
		A2(elm$json$Json$Decode$field, 'email', elm$json$Json$Decode$string),
		elm$json$Json$Decode$succeed(author$project$Data$Account$Account)));
var author$project$Ui$LoginCard$Login$GotLoginResponse = function (a) {
	return {$: 'GotLoginResponse', a: a};
};
var author$project$Ui$LoginCard$Login$IncorrectCredentials = {$: 'IncorrectCredentials'};
var author$project$Ui$LoginCard$Login$PasswordResetRequired = {$: 'PasswordResetRequired'};
var author$project$Ui$LoginCard$Login$listener = author$project$Data$Listener$for(
	{
		decoder: elm$json$Json$Decode$oneOf(
			_List_fromArray(
				[
					A2(elm$json$Json$Decode$map, elm$core$Result$Ok, author$project$Data$Account$decoder),
					A2(
					elm$json$Json$Decode$map,
					elm$core$Result$Err,
					A2(
						elm$json$Json$Decode$field,
						'name',
						author$project$Util$Json$Decode$matchStringMany(
							_List_fromArray(
								[
									_Utils_Tuple2('UserNotFoundException', author$project$Ui$LoginCard$Login$IncorrectCredentials),
									_Utils_Tuple2('NotAuthorizedException', author$project$Ui$LoginCard$Login$IncorrectCredentials),
									_Utils_Tuple2('PasswordResetRequiredException', author$project$Ui$LoginCard$Login$PasswordResetRequired)
								]))))
				])),
		handler: author$project$Ui$LoginCard$Login$GotLoginResponse,
		name: 'login'
	});
var author$project$Ui$LoginCard$listeners = _List_fromArray(
	[
		A2(author$project$Data$Listener$map, author$project$Ui$LoginCard$LoginMsg, author$project$Ui$LoginCard$Login$listener),
		A2(author$project$Data$Listener$map, author$project$Ui$LoginCard$ForgotPasswordMsg, author$project$Ui$LoginCard$ForgotPassword$listener)
	]);
var author$project$Page$Login$listeners = A2(author$project$Data$Listener$mapMany, author$project$Page$Login$LoginCardMsg, author$project$Ui$LoginCard$listeners);
var author$project$Page$ResetPassword$GotResetPasswordResponse = function (a) {
	return {$: 'GotResetPasswordResponse', a: a};
};
var author$project$Page$ResetPassword$InvalidCode = {$: 'InvalidCode'};
var author$project$Page$ResetPassword$listener = author$project$Data$Listener$for(
	{
		decoder: elm$json$Json$Decode$oneOf(
			_List_fromArray(
				[
					A2(
					elm$json$Json$Decode$map,
					elm$core$Result$Ok,
					elm$json$Json$Decode$null(_Utils_Tuple0)),
					A2(
					elm$json$Json$Decode$map,
					elm$core$Result$Err,
					A2(
						elm$json$Json$Decode$field,
						'name',
						A2(author$project$Util$Json$Decode$matchString, 'ExpiredCodeException', author$project$Page$ResetPassword$InvalidCode)))
				])),
		handler: author$project$Page$ResetPassword$GotResetPasswordResponse,
		name: 'reset password'
	});
var elm$core$Debug$log = _Debug_log;
var author$project$Main$listeners = function (model) {
	switch (model.$) {
		case 'Login':
			return A2(author$project$Data$Listener$mapMany, author$project$Main$LoginMsg, author$project$Page$Login$listeners);
		case 'ResetPassword':
			return _List_fromArray(
				[
					A2(author$project$Data$Listener$map, author$project$Main$ResetPasswordMsg, author$project$Page$ResetPassword$listener)
				]);
		case 'Home':
			var _n1 = A2(elm$core$Debug$log, 'SET HOME', _Utils_Tuple0);
			return A2(author$project$Data$Listener$mapMany, author$project$Main$HomeMsg, author$project$Page$Home$listeners);
		default:
			return _List_Nil;
	}
};
var elm$json$Json$Decode$value = _Json_decodeValue;
var author$project$Main$decodeMsg = F2(
	function (model, json) {
		var incomingMsgDecoder = A3(
			elm$json$Json$Decode$map2,
			elm$core$Tuple$pair,
			A2(elm$json$Json$Decode$field, 'name', elm$json$Json$Decode$string),
			A2(elm$json$Json$Decode$field, 'props', elm$json$Json$Decode$value));
		var _n0 = A2(elm$json$Json$Decode$decodeValue, incomingMsgDecoder, json);
		if (_n0.$ === 'Ok') {
			var _n1 = _n0.a;
			var name = _n1.a;
			var props = _n1.b;
			var checkListeners = function (remainingListeners) {
				checkListeners:
				while (true) {
					if (!remainingListeners.b) {
						return author$project$Main$ListenerNotFound(name);
					} else {
						var first = remainingListeners.a;
						var rest = remainingListeners.b;
						if (_Utils_eq(
							author$project$Data$Listener$getName(first),
							name)) {
							return A2(author$project$Data$Listener$handle, first, props);
						} else {
							var $temp$remainingListeners = rest;
							remainingListeners = $temp$remainingListeners;
							continue checkListeners;
						}
					}
				}
			};
			return checkListeners(
				author$project$Main$listeners(model));
		} else {
			return author$project$Main$FailedToDecodeJsMsg;
		}
	});
var author$project$Model$About = function (a) {
	return {$: 'About', a: a};
};
var author$project$Model$Home = function (a) {
	return {$: 'Home', a: a};
};
var author$project$Model$Login = function (a) {
	return {$: 'Login', a: a};
};
var author$project$Model$Logout = function (a) {
	return {$: 'Logout', a: a};
};
var author$project$Model$PageNotFound = function (a) {
	return {$: 'PageNotFound', a: a};
};
var author$project$Model$PaintApp = function (a) {
	return {$: 'PaintApp', a: a};
};
var author$project$Model$ResetPassword = function (a) {
	return {$: 'ResetPassword', a: a};
};
var author$project$Model$Settings = function (a) {
	return {$: 'Settings', a: a};
};
var author$project$Model$Splash = function (a) {
	return {$: 'Splash', a: a};
};
var Chadtech$elm_relational_database$Db$empty = Chadtech$elm_relational_database$Db$Db(elm$core$Dict$empty);
var author$project$Page$Home$LoadingAllDrawings = {$: 'LoadingAllDrawings'};
var author$project$Page$Home$allDrawingsRequest = author$project$Ports$send(
	author$project$Ports$payload('get drawings'));
var author$project$Page$Home$init = F2(
	function (session, account) {
		return _Utils_Tuple2(
			{account: account, drawings: Chadtech$elm_relational_database$Db$empty, session: session, state: author$project$Page$Home$LoadingAllDrawings},
			author$project$Page$Home$allDrawingsRequest);
	});
var author$project$Data$User$User = {$: 'User'};
var author$project$Data$User$noAccount = author$project$Data$User$User;
var author$project$Ports$withNoProps = A2(elm$core$Basics$composeR, author$project$Ports$payload, author$project$Ports$send);
var author$project$Ports$logout = author$project$Ports$withNoProps('log out');
var author$project$Ui$LoginCard$Login = function (a) {
	return {$: 'Login', a: a};
};
var author$project$Data$Field$initWithValue = function (str) {
	return {error: elm$core$Maybe$Nothing, value: str};
};
var author$project$Data$Field$init = author$project$Data$Field$initWithValue('');
var author$project$Ui$LoginCard$Login$Ready = {$: 'Ready'};
var author$project$Ui$LoginCard$Login$init = {email: author$project$Data$Field$init, httpStatus: author$project$Ui$LoginCard$Login$Ready, password: author$project$Data$Field$init};
var author$project$Ui$LoginCard$init = author$project$Ui$LoginCard$Login(author$project$Ui$LoginCard$Login$init);
var author$project$Page$Login$init = function (session) {
	return _Utils_Tuple2(
		{loginCard: author$project$Ui$LoginCard$init, session: session, user: author$project$Data$User$noAccount},
		author$project$Ports$logout);
};
var author$project$Page$Logout$Waiting = {$: 'Waiting'};
var author$project$Page$Logout$init = function (session) {
	return _Utils_Tuple2(
		{session: session, status: author$project$Page$Logout$Waiting},
		author$project$Ports$logout);
};
var author$project$Page$PaintApp$init = F2(
	function (session, user) {
		return {pendingNavigation: elm$core$Maybe$Nothing, session: session, user: user};
	});
var author$project$Page$ResetPassword$Ready = {$: 'Ready'};
var author$project$Page$ResetPassword$init = function (session) {
	return _Utils_Tuple2(
		{code: author$project$Data$Field$init, email: author$project$Data$Field$init, password: author$project$Data$Field$init, passwordConfirm: author$project$Data$Field$init, session: session, status: author$project$Page$ResetPassword$Ready},
		author$project$Ports$logout);
};
var author$project$Data$Account$getName = function ($) {
	return $.name;
};
var author$project$Page$Settings$Account = {$: 'Account'};
var author$project$Page$Settings$Ready = {$: 'Ready'};
var author$project$Page$Settings$init = F2(
	function (session, account) {
		return {
			account: account,
			nameField: author$project$Data$Field$initWithValue(
				author$project$Data$Account$getName(account)),
			session: session,
			status: author$project$Page$Settings$Ready,
			tab: author$project$Page$Settings$Account
		};
	});
var elm$core$Platform$Cmd$map = _Platform_map;
var author$project$Util$Cmd$mapCmd = F2(
	function (f, _n0) {
		var model = _n0.a;
		var cmd = _n0.b;
		return _Utils_Tuple2(
			model,
			A2(elm$core$Platform$Cmd$map, f, cmd));
	});
var author$project$Util$Cmd$withNoCmd = function (model) {
	return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
};
var author$project$Main$handleRouteFromOk = F3(
	function (session, user, route) {
		switch (route.$) {
			case 'PaintApp':
				var subRoute = route.a;
				return author$project$Util$Cmd$withNoCmd(
					author$project$Model$PaintApp(
						A2(author$project$Page$PaintApp$init, session, user)));
			case 'Landing':
				if (user.$ === 'User') {
					return author$project$Util$Cmd$withNoCmd(
						author$project$Model$Splash(session));
				} else {
					var account = user.a;
					return A2(
						author$project$Util$Cmd$mapCmd,
						author$project$Main$HomeMsg,
						A2(
							elm$core$Tuple$mapFirst,
							author$project$Model$Home,
							A2(author$project$Page$Home$init, session, account)));
				}
			case 'About':
				return author$project$Util$Cmd$withNoCmd(
					author$project$Model$About(
						{session: session, user: user}));
			case 'Login':
				return A2(
					elm$core$Tuple$mapFirst,
					author$project$Model$Login,
					author$project$Page$Login$init(session));
			case 'ResetPassword':
				return A2(
					elm$core$Tuple$mapFirst,
					author$project$Model$ResetPassword,
					author$project$Page$ResetPassword$init(session));
			case 'Logout':
				return A2(
					elm$core$Tuple$mapFirst,
					author$project$Model$Logout,
					author$project$Page$Logout$init(session));
			default:
				if (user.$ === 'User') {
					return author$project$Util$Cmd$withNoCmd(
						author$project$Model$PageNotFound(
							{session: session, user: user}));
				} else {
					var account = user.a;
					return author$project$Util$Cmd$withNoCmd(
						author$project$Model$Settings(
							A2(author$project$Page$Settings$init, session, account)));
				}
		}
	});
var author$project$Main$handleRoute = F3(
	function (session, user, routeResult) {
		if (routeResult.$ === 'Ok') {
			var route = routeResult.a;
			return A3(author$project$Main$handleRouteFromOk, session, user, route);
		} else {
			return author$project$Util$Cmd$withNoCmd(
				author$project$Model$PageNotFound(
					{session: session, user: user}));
		}
	});
var author$project$Model$Contact = function (a) {
	return {$: 'Contact', a: a};
};
var author$project$Data$User$Account = function (a) {
	return {$: 'Account', a: a};
};
var author$project$Data$User$account = author$project$Data$User$Account;
var author$project$Page$Contact$getUser = function ($) {
	return $.user;
};
var author$project$Page$Home$getAccount = function ($) {
	return $.account;
};
var author$project$Page$Login$getUser = function ($) {
	return $.user;
};
var author$project$Page$PaintApp$getUser = function ($) {
	return $.user;
};
var author$project$Page$Settings$getAccount = function ($) {
	return $.account;
};
var author$project$Model$getUser = function (model) {
	switch (model.$) {
		case 'Blank':
			var user = model.a.user;
			return user;
		case 'PageNotFound':
			var user = model.a.user;
			return user;
		case 'PaintApp':
			var subModel = model.a;
			return author$project$Page$PaintApp$getUser(subModel);
		case 'Splash':
			return author$project$Data$User$noAccount;
		case 'About':
			var user = model.a.user;
			return user;
		case 'Login':
			var subModel = model.a;
			return author$project$Page$Login$getUser(subModel);
		case 'ResetPassword':
			return author$project$Data$User$noAccount;
		case 'Settings':
			var subModel = model.a;
			return author$project$Data$User$account(
				author$project$Page$Settings$getAccount(subModel));
		case 'Home':
			var subModel = model.a;
			return author$project$Data$User$account(
				author$project$Page$Home$getAccount(subModel));
		case 'Logout':
			return author$project$Data$User$noAccount;
		default:
			var subModel = model.a;
			return author$project$Page$Contact$getUser(subModel);
	}
};
var author$project$Model$Blank = function (a) {
	return {$: 'Blank', a: a};
};
var author$project$Page$Contact$mapSession = F2(
	function (f, model) {
		return _Utils_update(
			model,
			{
				session: f(model.session)
			});
	});
var author$project$Page$Home$mapSession = F2(
	function (f, model) {
		return _Utils_update(
			model,
			{
				session: f(model.session)
			});
	});
var author$project$Page$Login$mapSession = F2(
	function (f, model) {
		return _Utils_update(
			model,
			{
				session: f(model.session)
			});
	});
var author$project$Page$Logout$mapSession = F2(
	function (f, model) {
		return _Utils_update(
			model,
			{
				session: f(model.session)
			});
	});
var author$project$Page$PaintApp$mapSession = F2(
	function (f, model) {
		return _Utils_update(
			model,
			{
				session: f(model.session)
			});
	});
var author$project$Page$ResetPassword$mapSession = F2(
	function (f, model) {
		return _Utils_update(
			model,
			{
				session: f(model.session)
			});
	});
var author$project$Page$Settings$mapSession = F2(
	function (f, model) {
		return _Utils_update(
			model,
			{
				session: f(model.session)
			});
	});
var author$project$Model$mapSession = F2(
	function (f, model) {
		switch (model.$) {
			case 'Blank':
				var user = model.a.user;
				var session = model.a.session;
				return author$project$Model$Blank(
					{
						session: f(session),
						user: user
					});
			case 'PageNotFound':
				var user = model.a.user;
				var session = model.a.session;
				return author$project$Model$PageNotFound(
					{
						session: f(session),
						user: user
					});
			case 'PaintApp':
				var subModel = model.a;
				return author$project$Model$PaintApp(
					A2(author$project$Page$PaintApp$mapSession, f, subModel));
			case 'Splash':
				var session = model.a;
				return author$project$Model$Splash(
					f(session));
			case 'About':
				var user = model.a.user;
				var session = model.a.session;
				return author$project$Model$About(
					{
						session: f(session),
						user: user
					});
			case 'Login':
				var subModel = model.a;
				return author$project$Model$Login(
					A2(author$project$Page$Login$mapSession, f, subModel));
			case 'ResetPassword':
				var subModel = model.a;
				return author$project$Model$ResetPassword(
					A2(author$project$Page$ResetPassword$mapSession, f, subModel));
			case 'Settings':
				var subModel = model.a;
				return author$project$Model$Settings(
					A2(author$project$Page$Settings$mapSession, f, subModel));
			case 'Home':
				var subModel = model.a;
				return author$project$Model$Home(
					A2(author$project$Page$Home$mapSession, f, subModel));
			case 'Logout':
				var subModel = model.a;
				return author$project$Model$Logout(
					A2(author$project$Page$Logout$mapSession, f, subModel));
			default:
				var subModel = model.a;
				return author$project$Model$Contact(
					A2(author$project$Page$Contact$mapSession, f, subModel));
		}
	});
var author$project$Page$Contact$sent = function (model) {
	return _Utils_update(
		model,
		{sent: true});
};
var author$project$Page$Contact$setField = F2(
	function (newField, model) {
		return _Utils_update(
			model,
			{field: newField});
	});
var author$project$Util$String$isBlank = function (str) {
	isBlank:
	while (true) {
		var isWhitespaceChar = function (_char) {
			return _Utils_eq(
				_char,
				_Utils_chr(' ')) || (_Utils_eq(
				_char,
				_Utils_chr('\n')) || (_Utils_eq(
				_char,
				_Utils_chr('\t')) || _Utils_eq(
				_char,
				_Utils_chr('\u000d'))));
		};
		var _n0 = elm$core$String$uncons(str);
		if (_n0.$ === 'Just') {
			var _n1 = _n0.a;
			var _char = _n1.a;
			var rest = _n1.b;
			if (isWhitespaceChar(_char)) {
				var $temp$str = rest;
				str = $temp$str;
				continue isBlank;
			} else {
				return false;
			}
		} else {
			return true;
		}
	}
};
var author$project$Page$Contact$update = F2(
	function (msg, model) {
		if (msg.$ === 'FieldUpdated') {
			var field = msg.a;
			return model.sent ? author$project$Util$Cmd$withNoCmd(model) : author$project$Util$Cmd$withNoCmd(
				A2(author$project$Page$Contact$setField, field, model));
		} else {
			return author$project$Util$String$isBlank(model.field) ? author$project$Util$Cmd$withNoCmd(model) : _Utils_Tuple2(
				author$project$Page$Contact$sent(model),
				author$project$Data$Tracking$send(
					A3(
						author$project$Data$Tracking$withString,
						'value',
						model.field,
						author$project$Data$Tracking$event('comment'))));
		}
	});
var author$project$Data$Drawing$toUrl = function (_n0) {
	var publicId = _n0.a;
	return A2(
		elm$core$String$join,
		'/',
		_List_fromArray(
			['https://s3.us-east-2.amazonaws.com/ctpaint-drawings-uploads', publicId]));
};
var author$project$Page$Home$DeleteDrawing = function (a) {
	return {$: 'DeleteDrawing', a: a};
};
var author$project$Page$Home$Deleting = {$: 'Deleting'};
var author$project$Page$Home$Drawings = {$: 'Drawings'};
var author$project$Page$Home$LoadingDrawing = {$: 'LoadingDrawing'};
var author$project$Page$Home$NewDrawing = function (a) {
	return {$: 'NewDrawing', a: a};
};
var author$project$Page$Home$SpecificDrawing = function (a) {
	return {$: 'SpecificDrawing', a: a};
};
var author$project$Ports$withId = F2(
	function (propName, id) {
		return A2(
			author$project$Ports$withProp,
			propName,
			Chadtech$elm_relational_database$Id$encode(id));
	});
var author$project$Page$Home$deleteDrawing = function (id) {
	return author$project$Ports$send(
		A3(
			author$project$Ports$withId,
			'drawingId',
			id,
			author$project$Ports$payload('delete drawing')));
};
var author$project$Page$Home$setState = F2(
	function (newState, model) {
		return _Utils_update(
			model,
			{state: newState});
	});
var author$project$Page$Home$goToDrawings = A2(
	elm$core$Basics$composeR,
	author$project$Page$Home$setState(author$project$Page$Home$Drawings),
	author$project$Util$Cmd$withNoCmd);
var author$project$Ui$InitDrawing$init = {backgroundColor: author$project$Data$BackgroundColor$black, height: elm$core$Maybe$Nothing, name: '', url: '', width: elm$core$Maybe$Nothing};
var author$project$Page$Home$initNewDrawing = A2(
	elm$core$Basics$composeR,
	author$project$Page$Home$setState(
		author$project$Page$Home$NewDrawing(author$project$Ui$InitDrawing$init)),
	author$project$Util$Cmd$withNoCmd);
var author$project$Page$Home$LoadingFailed = function (a) {
	return {$: 'LoadingFailed', a: a};
};
var author$project$Page$Home$loadingFailed = F2(
	function (error, model) {
		return _Utils_update(
			model,
			{
				state: author$project$Page$Home$LoadingFailed(error)
			});
	});
var author$project$Page$Home$receiveDrawings = F2(
	function (drawings, model) {
		return _Utils_update(
			model,
			{drawings: drawings, state: author$project$Page$Home$Drawings});
	});
var elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var elm$core$Basics$never = function (_n0) {
	never:
	while (true) {
		var nvr = _n0.a;
		var $temp$_n0 = nvr;
		_n0 = $temp$_n0;
		continue never;
	}
};
var elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var elm$core$Task$succeed = _Scheduler_succeed;
var elm$core$Task$init = elm$core$Task$succeed(_Utils_Tuple0);
var elm$core$Task$andThen = _Scheduler_andThen;
var elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return A2(
					elm$core$Task$andThen,
					function (b) {
						return elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var elm$core$Task$sequence = function (tasks) {
	return A3(
		elm$core$List$foldr,
		elm$core$Task$map2(elm$core$List$cons),
		elm$core$Task$succeed(_List_Nil),
		tasks);
};
var elm$core$Platform$sendToApp = _Platform_sendToApp;
var elm$core$Task$spawnCmd = F2(
	function (router, _n0) {
		var task = _n0.a;
		return _Scheduler_spawn(
			A2(
				elm$core$Task$andThen,
				elm$core$Platform$sendToApp(router),
				task));
	});
var elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			elm$core$Task$map,
			function (_n0) {
				return _Utils_Tuple0;
			},
			elm$core$Task$sequence(
				A2(
					elm$core$List$map,
					elm$core$Task$spawnCmd(router),
					commands)));
	});
var elm$core$Task$onSelfMsg = F3(
	function (_n0, _n1, _n2) {
		return elm$core$Task$succeed(_Utils_Tuple0);
	});
var elm$core$Task$cmdMap = F2(
	function (tagger, _n0) {
		var task = _n0.a;
		return elm$core$Task$Perform(
			A2(elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager(elm$core$Task$init, elm$core$Task$onEffects, elm$core$Task$onSelfMsg, elm$core$Task$cmdMap);
var elm$core$Task$command = _Platform_leaf('Task');
var elm$core$Task$perform = F2(
	function (toMessage, task) {
		return elm$core$Task$command(
			elm$core$Task$Perform(
				A2(elm$core$Task$map, toMessage, task)));
	});
var elm$core$String$length = _String_length;
var elm$core$String$slice = _String_slice;
var elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			elm$core$String$slice,
			n,
			elm$core$String$length(string),
			string);
	});
var elm$core$String$startsWith = _String_startsWith;
var elm$url$Url$Http = {$: 'Http'};
var elm$url$Url$Https = {$: 'Https'};
var elm$core$String$indexes = _String_indexes;
var elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3(elm$core$String$slice, 0, n, string);
	});
var elm$core$String$contains = _String_contains;
var elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if (elm$core$String$isEmpty(str) || A2(elm$core$String$contains, '@', str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, ':', str);
			if (!_n0.b) {
				return elm$core$Maybe$Just(
					A6(elm$url$Url$Url, protocol, str, elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_n0.b.b) {
					var i = _n0.a;
					var _n1 = elm$core$String$toInt(
						A2(elm$core$String$dropLeft, i + 1, str));
					if (_n1.$ === 'Nothing') {
						return elm$core$Maybe$Nothing;
					} else {
						var port_ = _n1;
						return elm$core$Maybe$Just(
							A6(
								elm$url$Url$Url,
								protocol,
								A2(elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return elm$core$Maybe$Nothing;
				}
			}
		}
	});
var elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '/', str);
			if (!_n0.b) {
				return A5(elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _n0.a;
				return A5(
					elm$url$Url$chompBeforePath,
					protocol,
					A2(elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '?', str);
			if (!_n0.b) {
				return A4(elm$url$Url$chompBeforeQuery, protocol, elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _n0.a;
				return A4(
					elm$url$Url$chompBeforeQuery,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '#', str);
			if (!_n0.b) {
				return A3(elm$url$Url$chompBeforeFragment, protocol, elm$core$Maybe$Nothing, str);
			} else {
				var i = _n0.a;
				return A3(
					elm$url$Url$chompBeforeFragment,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$fromString = function (str) {
	return A2(elm$core$String$startsWith, 'http://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		elm$url$Url$Http,
		A2(elm$core$String$dropLeft, 7, str)) : (A2(elm$core$String$startsWith, 'https://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		elm$url$Url$Https,
		A2(elm$core$String$dropLeft, 8, str)) : elm$core$Maybe$Nothing);
};
var elm$browser$Browser$Navigation$pushUrl = _Browser_pushUrl;
var author$project$Data$NavKey$goTo = F2(
	function (key, url) {
		if (key.$ === 'NavKey') {
			var nativeKey = key.a;
			return A2(elm$browser$Browser$Navigation$pushUrl, nativeKey, url);
		} else {
			return elm$core$Platform$Cmd$none;
		}
	});
var elm$core$String$concat = function (strings) {
	return A2(elm$core$String$join, '', strings);
};
var author$project$Data$Size$toString = function (_n0) {
	var width = _n0.width;
	var height = _n0.height;
	return elm$core$String$concat(
		_List_fromArray(
			[
				'w',
				elm$core$String$fromInt(width),
				'h',
				elm$core$String$fromInt(height)
			]));
};
var elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _n0 = f(mx);
		if (_n0.$ === 'Just') {
			var x = _n0.a;
			return A2(elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			elm$core$List$foldr,
			elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var elm$url$Url$percentEncode = _Url_percentEncode;
var author$project$Route$PaintApp$toUrl = function (route) {
	switch (route.$) {
		case 'Landing':
			return '';
		case 'WithParams':
			var backgroundColor = route.a.backgroundColor;
			var name = route.a.name;
			var dimensions = route.a.dimensions;
			var encodePair = function (_n1) {
				var key = _n1.a;
				var value = _n1.b;
				return key + ('=' + value);
			};
			return '?' + A2(
				elm$core$String$join,
				'&',
				A2(
					elm$core$List$map,
					encodePair,
					A2(
						elm$core$List$filterMap,
						elm$core$Basics$identity,
						_List_fromArray(
							[
								A2(
								elm$core$Maybe$map,
								A2(
									elm$core$Basics$composeL,
									elm$core$Tuple$pair('background_color'),
									author$project$Data$BackgroundColor$toString),
								backgroundColor),
								A2(
								elm$core$Maybe$map,
								elm$core$Tuple$pair('name'),
								name),
								A2(
								elm$core$Maybe$map,
								A2(
									elm$core$Basics$composeL,
									elm$core$Tuple$pair('size'),
									author$project$Data$Size$toString),
								dimensions)
							]))));
		case 'FromUrl':
			var url = route.a;
			return 'url/' + elm$url$Url$percentEncode(url);
		default:
			var id = route.a;
			return 'id/' + Chadtech$elm_relational_database$Id$toString(id);
	}
};
var author$project$Route$toPieces = function (route) {
	switch (route.$) {
		case 'Landing':
			return _List_Nil;
		case 'PaintApp':
			var subRoute = route.a;
			return _List_fromArray(
				[
					'app',
					author$project$Route$PaintApp$toUrl(subRoute)
				]);
		case 'About':
			return _List_fromArray(
				['about']);
		case 'Login':
			return _List_fromArray(
				['login']);
		case 'ResetPassword':
			return _List_fromArray(
				['resetpassword']);
		case 'Logout':
			return _List_fromArray(
				['logout']);
		default:
			return _List_fromArray(
				['settings']);
	}
};
var author$project$Route$toUrl = function (route) {
	return '/' + A2(
		elm$core$String$join,
		'/',
		author$project$Route$toPieces(route));
};
var author$project$Route$goTo = function (key) {
	return A2(
		elm$core$Basics$composeL,
		author$project$Data$NavKey$goTo(key),
		author$project$Route$toUrl);
};
var author$project$Route$paintAppFromDrawing = A2(elm$core$Basics$composeL, author$project$Route$PaintApp, author$project$Route$PaintApp$FromDrawing);
var author$project$Session$getNavKey = function ($) {
	return $.navKey;
};
var author$project$Route$paintAppWithParams = A2(elm$core$Basics$composeL, author$project$Route$PaintApp, author$project$Route$PaintApp$WithParams);
var author$project$Route$paintAppFromUrl = A2(
	elm$core$Basics$composeL,
	A2(elm$core$Basics$composeL, author$project$Route$PaintApp, author$project$Route$PaintApp$FromUrl),
	elm$url$Url$percentEncode);
var author$project$Ui$InitDrawing$fromUrlDisabled = A2(
	elm$core$Basics$composeR,
	function ($) {
		return $.url;
	},
	author$project$Util$String$isBlank);
var author$project$Ui$InitDrawing$fromUrl = F2(
	function (navKey, model) {
		return author$project$Ui$InitDrawing$fromUrlDisabled(model) ? author$project$Util$Cmd$withNoCmd(model) : _Utils_Tuple2(
			model,
			A2(
				author$project$Route$goTo,
				navKey,
				author$project$Route$paintAppFromUrl(model.url)));
	});
var author$project$Ui$InitDrawing$setHeight = F2(
	function (newHeight, model) {
		return _Utils_update(
			model,
			{
				height: elm$core$Maybe$Just(newHeight)
			});
	});
var author$project$Ui$InitDrawing$setWidth = F2(
	function (newWidth, model) {
		return _Utils_update(
			model,
			{
				width: elm$core$Maybe$Just(newWidth)
			});
	});
var author$project$Ui$InitDrawing$initHeight = 400;
var author$project$Ui$InitDrawing$initWidth = 400;
var author$project$Util$Maybe$firstValue = function (maybes) {
	firstValue:
	while (true) {
		if (maybes.b) {
			if (maybes.a.$ === 'Just') {
				var v = maybes.a.a;
				return elm$core$Maybe$Just(v);
			} else {
				var _n1 = maybes.a;
				var rest = maybes.b;
				var $temp$maybes = rest;
				maybes = $temp$maybes;
				continue firstValue;
			}
		} else {
			return elm$core$Maybe$Nothing;
		}
	}
};
var author$project$Ui$InitDrawing$toPaintAppParams = function (model) {
	return {
		backgroundColor: elm$core$Maybe$Just(model.backgroundColor),
		dimensions: elm$core$Maybe$Just(
			{
				height: A2(
					elm$core$Maybe$withDefault,
					author$project$Ui$InitDrawing$initHeight,
					author$project$Util$Maybe$firstValue(
						_List_fromArray(
							[model.height, model.width]))),
				width: A2(
					elm$core$Maybe$withDefault,
					author$project$Ui$InitDrawing$initWidth,
					author$project$Util$Maybe$firstValue(
						_List_fromArray(
							[model.width, model.height])))
			}),
		name: author$project$Util$String$isBlank(model.name) ? elm$core$Maybe$Nothing : elm$core$Maybe$Just(model.name)
	};
};
var author$project$Ui$InitDrawing$update = F3(
	function (navKey, msg, model) {
		switch (msg.$) {
			case 'FromUrlClicked':
				return A2(author$project$Ui$InitDrawing$fromUrl, navKey, model);
			case 'NameUpdated':
				var str = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					_Utils_update(
						model,
						{name: str}));
			case 'WidthUpdated':
				if (msg.a === '') {
					return author$project$Util$Cmd$withNoCmd(
						A2(author$project$Ui$InitDrawing$setWidth, 0, model));
				} else {
					var str = msg.a;
					var _n1 = elm$core$String$toInt(str);
					if (_n1.$ === 'Just') {
						var newWidth = _n1.a;
						return author$project$Util$Cmd$withNoCmd(
							A2(author$project$Ui$InitDrawing$setWidth, newWidth, model));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				}
			case 'HeightUpdated':
				if (msg.a === '') {
					return author$project$Util$Cmd$withNoCmd(
						A2(author$project$Ui$InitDrawing$setHeight, 0, model));
				} else {
					var str = msg.a;
					var _n2 = elm$core$String$toInt(str);
					if (_n2.$ === 'Just') {
						var newHeight = _n2.a;
						return author$project$Util$Cmd$withNoCmd(
							A2(author$project$Ui$InitDrawing$setHeight, newHeight, model));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				}
			case 'UrlUpdated':
				var str = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					_Utils_update(
						model,
						{url: str}));
			case 'ColorClicked':
				var color = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					_Utils_update(
						model,
						{backgroundColor: color}));
			default:
				return _Utils_Tuple2(
					model,
					A2(
						author$project$Route$goTo,
						navKey,
						author$project$Route$paintAppWithParams(
							author$project$Ui$InitDrawing$toPaintAppParams(model))));
		}
	});
var author$project$Page$Home$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'DrawingClicked':
				var id = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					A2(
						author$project$Page$Home$setState,
						author$project$Page$Home$SpecificDrawing(id),
						model));
			case 'NewDrawingClicked':
				return author$project$Page$Home$initNewDrawing(model);
			case 'CloseDrawingClicked':
				return author$project$Page$Home$goToDrawings(model);
			case 'CloseNewDrawingClicked':
				return author$project$Page$Home$goToDrawings(model);
			case 'InitDrawingMsg':
				var subMsg = msg.a;
				var _n1 = model.state;
				if (_n1.$ === 'NewDrawing') {
					var subModel = _n1.a;
					var _n2 = A3(
						author$project$Ui$InitDrawing$update,
						author$project$Session$getNavKey(model.session),
						subMsg,
						subModel);
					var newSubModel = _n2.a;
					var cmd = _n2.b;
					return _Utils_Tuple2(
						A2(
							author$project$Page$Home$setState,
							author$project$Page$Home$NewDrawing(newSubModel),
							model),
						cmd);
				} else {
					return author$project$Util$Cmd$withNoCmd(model);
				}
			case 'OpenDrawingInPaintAppClicked':
				var id = msg.a;
				return _Utils_Tuple2(
					A2(author$project$Page$Home$setState, author$project$Page$Home$LoadingDrawing, model),
					A2(
						author$project$Route$goTo,
						author$project$Session$getNavKey(model.session),
						author$project$Route$paintAppFromDrawing(id)));
			case 'OpenDrawingLinkClicked':
				var id = msg.a;
				return _Utils_Tuple2(
					model,
					author$project$Ports$send(
						A3(
							author$project$Ports$withString,
							'url',
							author$project$Data$Drawing$toUrl(id),
							author$project$Ports$payload('open in new window'))));
			case 'DeleteDrawingClicked':
				var id = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					A2(
						author$project$Page$Home$setState,
						author$project$Page$Home$DeleteDrawing(id),
						model));
			case 'DeleteYesClicked':
				var _n3 = model.state;
				if (_n3.$ === 'DeleteDrawing') {
					var id = _n3.a;
					return _Utils_Tuple2(
						A2(author$project$Page$Home$setState, author$project$Page$Home$Deleting, model),
						author$project$Page$Home$deleteDrawing(id));
				} else {
					return author$project$Util$Cmd$withNoCmd(model);
				}
			case 'DeleteNoClicked':
				var _n4 = model.state;
				if (_n4.$ === 'DeleteDrawing') {
					var id = _n4.a;
					return author$project$Util$Cmd$withNoCmd(
						A2(
							author$project$Page$Home$setState,
							author$project$Page$Home$SpecificDrawing(id),
							model));
				} else {
					return author$project$Util$Cmd$withNoCmd(model);
				}
			case 'MakeADrawingClicked':
				return author$project$Page$Home$initNewDrawing(model);
			case 'RefreshClicked':
				return _Utils_Tuple2(
					A2(author$project$Page$Home$setState, author$project$Page$Home$LoadingAllDrawings, model),
					author$project$Page$Home$allDrawingsRequest);
			case 'BackToDrawingsClicked':
				return author$project$Util$Cmd$withNoCmd(
					A2(author$project$Page$Home$setState, author$project$Page$Home$Drawings, model));
			case 'TryAgainClicked':
				var _n5 = model.state;
				if (_n5.$ === 'DeleteFailed') {
					var id = _n5.a;
					return _Utils_Tuple2(
						A2(author$project$Page$Home$setState, author$project$Page$Home$Deleting, model),
						author$project$Page$Home$deleteDrawing(id));
				} else {
					return author$project$Util$Cmd$withNoCmd(model);
				}
			default:
				var response = msg.a;
				if (response.$ === 'Ok') {
					var drawings = response.a;
					return author$project$Util$Cmd$withNoCmd(
						A2(author$project$Page$Home$receiveDrawings, drawings, model));
				} else {
					var err = response.a;
					return author$project$Util$Cmd$withNoCmd(
						A2(author$project$Page$Home$loadingFailed, err, model));
				}
		}
	});
var author$project$Page$Login$loggedIn = F2(
	function (account, model) {
		return _Utils_update(
			model,
			{
				user: author$project$Data$User$account(account)
			});
	});
var author$project$Page$Login$setLoginCard = F2(
	function (newLoginCard, model) {
		return _Utils_update(
			model,
			{loginCard: newLoginCard});
	});
var author$project$Ui$LoginCard$ForgotPassword = function (a) {
	return {$: 'ForgotPassword', a: a};
};
var author$project$Ui$LoginCard$Login$LoggingIn = {$: 'LoggingIn'};
var author$project$Ui$LoginCard$Login$loggingIn = function (model) {
	return _Utils_update(
		model,
		{httpStatus: author$project$Ui$LoginCard$Login$LoggingIn});
};
var author$project$Data$Field$getError = function ($) {
	return $.error;
};
var author$project$Data$Field$getValue = function ($) {
	return $.value;
};
var author$project$Data$Field$batchValidations = F2(
	function (checks, field) {
		batchValidations:
		while (true) {
			if (checks.b) {
				var first = checks.a;
				var rest = checks.b;
				var checkedField = first(field);
				if (_Utils_eq(checkedField.error, elm$core$Maybe$Nothing)) {
					var $temp$checks = rest,
						$temp$field = field;
					checks = $temp$checks;
					field = $temp$field;
					continue batchValidations;
				} else {
					return checkedField;
				}
			} else {
				return field;
			}
		}
	});
var author$project$Data$Field$clearError = function (field) {
	return _Utils_update(
		field,
		{error: elm$core$Maybe$Nothing});
};
var author$project$Data$Field$setError = F2(
	function (error, field) {
		return _Utils_update(
			field,
			{
				error: elm$core$Maybe$Just(error)
			});
	});
var author$project$Data$Field$validate = F2(
	function (_n0, field) {
		var valid = _n0.valid;
		var errorMessage = _n0.errorMessage;
		return valid(field.value) ? author$project$Data$Field$clearError(field) : A2(author$project$Data$Field$setError, errorMessage, field);
	});
var elm$regex$Regex$Match = F4(
	function (match, index, number, submatches) {
		return {index: index, match: match, number: number, submatches: submatches};
	});
var elm$regex$Regex$fromStringWith = _Regex_fromStringWith;
var elm$regex$Regex$never = _Regex_never;
var author$project$Util$String$validEmail = A2(
	elm$core$Maybe$withDefault,
	elm$regex$Regex$never,
	A2(
		elm$regex$Regex$fromStringWith,
		{caseInsensitive: true, multiline: false},
		'^[a-zA-Z0-9.!#$%&\'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'));
var elm$regex$Regex$contains = _Regex_contains;
var author$project$Util$String$isValidEmail = function (email) {
	return A2(elm$regex$Regex$contains, author$project$Util$String$validEmail, email);
};
var author$project$Data$Field$validateEmail = author$project$Data$Field$batchValidations(
	_List_fromArray(
		[
			author$project$Data$Field$validate(
			{
				errorMessage: 'you must enter your email',
				valid: A2(elm$core$Basics$composeL, elm$core$Basics$not, author$project$Util$String$isBlank)
			}),
			author$project$Data$Field$validate(
			{errorMessage: 'this is not a valid email address', valid: author$project$Util$String$isValidEmail})
		]));
var elm$core$String$toUpper = _String_toUpper;
var author$project$Util$String$containsLowercase = function (str) {
	return !_Utils_eq(
		str,
		elm$core$String$toUpper(str));
};
var elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var elm$core$String$foldr = _String_foldr;
var elm$core$String$toList = function (string) {
	return A3(elm$core$String$foldr, elm$core$List$cons, _List_Nil, string);
};
var author$project$Util$String$containsSpecialCharacter = function (str) {
	var specialCharacters = elm$core$String$toList('^$*.[]{}()?-\"!@#%&/\\,><\':;|_~`');
	var isSpecialCharacter = function (_char) {
		return A2(elm$core$List$member, _char, specialCharacters);
	};
	return A3(
		elm$core$List$foldr,
		elm$core$Basics$or,
		false,
		A2(
			elm$core$List$map,
			isSpecialCharacter,
			elm$core$String$toList(str)));
};
var elm$core$String$toLower = _String_toLower;
var author$project$Util$String$containsUppercase = function (str) {
	return !_Utils_eq(
		str,
		elm$core$String$toLower(str));
};
var elm$core$Basics$ge = _Utils_ge;
var author$project$Util$String$lengthIsAtLeast = F2(
	function (length, str) {
		return _Utils_cmp(
			elm$core$String$length(str),
			length) > -1;
	});
var author$project$Data$Field$validatePassword = author$project$Data$Field$batchValidations(
	_List_fromArray(
		[
			author$project$Data$Field$validate(
			{
				errorMessage: 'you must enter your password',
				valid: A2(elm$core$Basics$composeL, elm$core$Basics$not, author$project$Util$String$isBlank)
			}),
			author$project$Data$Field$validate(
			{errorMessage: 'password must contain at least one upper case character', valid: author$project$Util$String$containsUppercase}),
			author$project$Data$Field$validate(
			{errorMessage: 'password must contain at least one lower case character', valid: author$project$Util$String$containsLowercase}),
			author$project$Data$Field$validate(
			{
				errorMessage: 'password must be at least 8 characters',
				valid: author$project$Util$String$lengthIsAtLeast(8)
			}),
			author$project$Data$Field$validate(
			{errorMessage: 'password must contain at least one special character', valid: author$project$Util$String$containsSpecialCharacter})
		]));
var author$project$Ui$LoginCard$Login$validate = function (model) {
	var validatedModel = _Utils_update(
		model,
		{
			email: author$project$Data$Field$validateEmail(model.email),
			password: author$project$Data$Field$validatePassword(model.password)
		});
	var _n0 = _Utils_Tuple2(
		author$project$Data$Field$getError(validatedModel.email),
		author$project$Data$Field$getError(validatedModel.password));
	if ((_n0.a.$ === 'Nothing') && (_n0.b.$ === 'Nothing')) {
		var _n1 = _n0.a;
		var _n2 = _n0.b;
		return elm$core$Result$Ok(
			{
				email: author$project$Data$Field$getValue(validatedModel.email),
				password: author$project$Data$Field$getValue(validatedModel.password)
			});
	} else {
		return elm$core$Result$Err(validatedModel);
	}
};
var author$project$Util$Cmd$justModel = function (model) {
	return _Utils_Tuple3(model, elm$core$Platform$Cmd$none, elm$core$Maybe$Nothing);
};
var author$project$Util$Tuple3$mapFirst = F2(
	function (f, _n0) {
		var a = _n0.a;
		var b = _n0.b;
		var c = _n0.c;
		return _Utils_Tuple3(
			f(a),
			b,
			c);
	});
var author$project$Ui$LoginCard$attemptLogin = function (model) {
	return A2(
		author$project$Util$Tuple3$mapFirst,
		author$project$Ui$LoginCard$Login,
		function () {
			var _n0 = author$project$Ui$LoginCard$Login$validate(model);
			if (_n0.$ === 'Ok') {
				var email = _n0.a.email;
				var password = _n0.a.password;
				return _Utils_Tuple3(
					author$project$Ui$LoginCard$Login$loggingIn(model),
					author$project$Ports$send(
						A3(
							author$project$Ports$withString,
							'password',
							password,
							A3(
								author$project$Ports$withString,
								'email',
								email,
								author$project$Ports$payload('log in')))),
					elm$core$Maybe$Nothing);
			} else {
				var newModel = _n0.a;
				return author$project$Util$Cmd$justModel(newModel);
			}
		}());
};
var author$project$Ui$LoginCard$ForgotPassword$Ready = function (a) {
	return {$: 'Ready', a: a};
};
var author$project$Ui$LoginCard$ForgotPassword$init = author$project$Ui$LoginCard$ForgotPassword$Ready(author$project$Data$Field$init);
var author$project$Ui$LoginCard$Login$Failed = function (a) {
	return {$: 'Failed', a: a};
};
var author$project$Ui$LoginCard$Login$fail = F2(
	function (error, model) {
		return _Utils_update(
			model,
			{
				httpStatus: author$project$Ui$LoginCard$Login$Failed(error)
			});
	});
var author$project$Data$Field$setValue = F2(
	function (newValue, field) {
		return _Utils_update(
			field,
			{value: newValue});
	});
var author$project$Ui$LoginCard$Login$setEmail = F2(
	function (str, model) {
		return _Utils_update(
			model,
			{
				email: A2(author$project$Data$Field$setValue, str, model.email)
			});
	});
var author$project$Ui$LoginCard$Login$setPassword = F2(
	function (str, model) {
		return _Utils_update(
			model,
			{
				password: A2(author$project$Data$Field$setValue, str, model.password)
			});
	});
var author$project$Ui$LoginCard$updateLogin = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'EmailUpdated':
				var str = msg.a;
				return author$project$Util$Cmd$justModel(
					author$project$Ui$LoginCard$Login(
						A2(author$project$Ui$LoginCard$Login$setEmail, str, model)));
			case 'PasswordUpdated':
				var str = msg.a;
				return author$project$Util$Cmd$justModel(
					author$project$Ui$LoginCard$Login(
						A2(author$project$Ui$LoginCard$Login$setPassword, str, model)));
			case 'LoginClicked':
				return author$project$Ui$LoginCard$attemptLogin(model);
			case 'EnterPressed':
				return author$project$Ui$LoginCard$attemptLogin(model);
			case 'ForgotPasswordClicked':
				return author$project$Util$Cmd$justModel(
					author$project$Ui$LoginCard$ForgotPassword(author$project$Ui$LoginCard$ForgotPassword$init));
			case 'GotLoginResponse':
				var response = msg.a;
				if (response.$ === 'Ok') {
					var user = response.a;
					return _Utils_Tuple3(
						author$project$Ui$LoginCard$Login(model),
						elm$core$Platform$Cmd$none,
						elm$core$Maybe$Just(user));
				} else {
					var error = response.a;
					return author$project$Util$Cmd$justModel(
						author$project$Ui$LoginCard$Login(
							A2(author$project$Ui$LoginCard$Login$fail, error, model)));
				}
			default:
				return author$project$Util$Cmd$justModel(
					author$project$Ui$LoginCard$Login(author$project$Ui$LoginCard$Login$init));
		}
	});
var author$project$Ui$LoginCard$ForgotPassword$Fail = function (a) {
	return {$: 'Fail', a: a};
};
var author$project$Ui$LoginCard$ForgotPassword$Success = function (a) {
	return {$: 'Success', a: a};
};
var author$project$Ui$LoginCard$ForgotPassword$Waiting = function (a) {
	return {$: 'Waiting', a: a};
};
var author$project$Ui$LoginCard$ForgotPassword$requestReset = function (_n0) {
	var email = _n0.email;
	return author$project$Ports$send(
		A3(
			author$project$Ports$withString,
			'email',
			email,
			author$project$Ports$payload('forgot password')));
};
var author$project$Ui$LoginCard$ForgotPassword$validate = function (model) {
	var validatedField = author$project$Data$Field$validateEmail(model);
	var _n0 = author$project$Data$Field$getError(validatedField);
	if (_n0.$ === 'Just') {
		return elm$core$Result$Err(validatedField);
	} else {
		return elm$core$Result$Ok(
			{
				email: author$project$Data$Field$getValue(validatedField)
			});
	}
};
var author$project$Ui$LoginCard$ForgotPassword$attemptReset = function (field) {
	var _n0 = author$project$Ui$LoginCard$ForgotPassword$validate(field);
	if (_n0.$ === 'Ok') {
		var email = _n0.a;
		return _Utils_Tuple2(
			author$project$Ui$LoginCard$ForgotPassword$Waiting(email),
			author$project$Ui$LoginCard$ForgotPassword$requestReset(email));
	} else {
		var newField = _n0.a;
		return author$project$Util$Cmd$withNoCmd(
			author$project$Ui$LoginCard$ForgotPassword$Ready(newField));
	}
};
var author$project$Ui$LoginCard$ForgotPassword$updateReady = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'EmailUpdated':
				var newEmail = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					author$project$Ui$LoginCard$ForgotPassword$Ready(
						A2(author$project$Data$Field$setValue, newEmail, model)));
			case 'ResetPasswordClicked':
				return author$project$Ui$LoginCard$ForgotPassword$attemptReset(model);
			default:
				return author$project$Ui$LoginCard$ForgotPassword$attemptReset(model);
		}
	});
var author$project$Ui$LoginCard$ForgotPassword$update = F2(
	function (msg, model) {
		if (msg.$ === 'ReadyMsg') {
			var subMsg = msg.a;
			if (model.$ === 'Ready') {
				var subModel = model.a;
				return A2(author$project$Ui$LoginCard$ForgotPassword$updateReady, subMsg, subModel);
			} else {
				return author$project$Util$Cmd$withNoCmd(model);
			}
		} else {
			var result = msg.a;
			if (model.$ === 'Waiting') {
				var email = model.a;
				if (result.$ === 'Ok') {
					return author$project$Util$Cmd$withNoCmd(
						author$project$Ui$LoginCard$ForgotPassword$Success(email));
				} else {
					var error = result.a;
					return author$project$Util$Cmd$withNoCmd(
						author$project$Ui$LoginCard$ForgotPassword$Fail(
							{error: error}));
				}
			} else {
				return author$project$Util$Cmd$withNoCmd(model);
			}
		}
	});
var author$project$Util$Cmd$mapModel = elm$core$Tuple$mapFirst;
var author$project$Util$Tuple$append = F2(
	function (c, _n0) {
		var a = _n0.a;
		var b = _n0.b;
		return _Utils_Tuple3(a, b, c);
	});
var author$project$Ui$LoginCard$update = F2(
	function (msg, model) {
		if (msg.$ === 'LoginMsg') {
			var subMsg = msg.a;
			if (model.$ === 'Login') {
				var subModel = model.a;
				return A2(author$project$Ui$LoginCard$updateLogin, subMsg, subModel);
			} else {
				return author$project$Util$Cmd$justModel(model);
			}
		} else {
			var subMsg = msg.a;
			if (model.$ === 'ForgotPassword') {
				var subModel = model.a;
				return A2(
					author$project$Util$Tuple$append,
					elm$core$Maybe$Nothing,
					A2(
						author$project$Util$Cmd$mapCmd,
						author$project$Ui$LoginCard$ForgotPasswordMsg,
						A2(
							author$project$Util$Cmd$mapModel,
							author$project$Ui$LoginCard$ForgotPassword,
							A2(author$project$Ui$LoginCard$ForgotPassword$update, subMsg, subModel))));
			} else {
				return author$project$Util$Cmd$justModel(model);
			}
		}
	});
var author$project$Util$Tuple3$mapSecond = F2(
	function (f, _n0) {
		var a = _n0.a;
		var b = _n0.b;
		var c = _n0.c;
		return _Utils_Tuple3(
			a,
			f(b),
			c);
	});
var author$project$Page$Login$update = F2(
	function (msg, model) {
		var subMsg = msg.a;
		var _n1 = A2(
			author$project$Util$Tuple3$mapSecond,
			elm$core$Platform$Cmd$map(author$project$Page$Login$LoginCardMsg),
			A2(author$project$Ui$LoginCard$update, subMsg, model.loginCard));
		var newLoginCardModel = _n1.a;
		var cmd = _n1.b;
		var maybeUser = _n1.c;
		var modelWithCard = A2(author$project$Page$Login$setLoginCard, newLoginCardModel, model);
		if (maybeUser.$ === 'Just') {
			var newUser = maybeUser.a;
			return _Utils_Tuple2(
				A2(author$project$Page$Login$loggedIn, newUser, modelWithCard),
				elm$core$Platform$Cmd$batch(
					_List_fromArray(
						[
							A2(
							author$project$Route$goTo,
							author$project$Session$getNavKey(model.session),
							author$project$Route$Landing),
							cmd
						])));
		} else {
			return _Utils_Tuple2(modelWithCard, cmd);
		}
	});
var author$project$Page$PageNotFound$update = F2(
	function (navKey, msg) {
		return A2(author$project$Route$goTo, navKey, author$project$Route$Landing);
	});
var author$project$Page$ResetPassword$Fail = function (a) {
	return {$: 'Fail', a: a};
};
var author$project$Page$ResetPassword$Success = {$: 'Success'};
var author$project$Page$ResetPassword$Waiting = {$: 'Waiting'};
var author$project$Page$ResetPassword$setStatus = F2(
	function (status, model) {
		return _Utils_update(
			model,
			{status: status});
	});
var author$project$Page$ResetPassword$validate = function (model) {
	var validatedModel = _Utils_update(
		model,
		{
			code: A2(
				author$project$Data$Field$validate,
				{
					errorMessage: 'you must enter your reset code',
					valid: A2(elm$core$Basics$composeL, elm$core$Basics$not, author$project$Util$String$isBlank)
				},
				model.code),
			email: author$project$Data$Field$validateEmail(model.email),
			password: author$project$Data$Field$validatePassword(model.password),
			passwordConfirm: A2(
				author$project$Data$Field$validate,
				{
					errorMessage: 'the passwords you entered do not match',
					valid: elm$core$Basics$eq(
						author$project$Data$Field$getValue(model.password))
				},
				model.passwordConfirm)
		});
	var _n0 = author$project$Util$Maybe$firstValue(
		_List_fromArray(
			[
				author$project$Data$Field$getError(validatedModel.email),
				author$project$Data$Field$getError(validatedModel.code),
				author$project$Data$Field$getError(validatedModel.password),
				author$project$Data$Field$getError(validatedModel.passwordConfirm)
			]));
	if (_n0.$ === 'Just') {
		return elm$core$Result$Err(validatedModel);
	} else {
		return elm$core$Result$Ok(
			{
				code: author$project$Data$Field$getValue(validatedModel.code),
				email: author$project$Data$Field$getValue(validatedModel.email),
				newPassword: author$project$Data$Field$getValue(validatedModel.password)
			});
	}
};
var author$project$Page$ResetPassword$attemptSubmission = function (model) {
	var _n0 = model.status;
	if (_n0.$ === 'Ready') {
		var _n1 = author$project$Page$ResetPassword$validate(model);
		if (_n1.$ === 'Ok') {
			var newPassword = _n1.a.newPassword;
			var email = _n1.a.email;
			var code = _n1.a.code;
			return _Utils_Tuple2(
				A2(author$project$Page$ResetPassword$setStatus, author$project$Page$ResetPassword$Waiting, model),
				author$project$Ports$send(
					A3(
						author$project$Ports$withString,
						'password',
						newPassword,
						A3(
							author$project$Ports$withString,
							'code',
							code,
							A3(
								author$project$Ports$withString,
								'email',
								email,
								author$project$Ports$payload('reset password'))))));
		} else {
			var validatedModel = _n1.a;
			return author$project$Util$Cmd$withNoCmd(validatedModel);
		}
	} else {
		return author$project$Util$Cmd$withNoCmd(model);
	}
};
var author$project$Page$ResetPassword$setCode = F2(
	function (newCode, model) {
		return _Utils_update(
			model,
			{
				code: A2(author$project$Data$Field$setValue, newCode, model.code)
			});
	});
var author$project$Page$ResetPassword$setEmail = F2(
	function (newEmail, model) {
		return _Utils_update(
			model,
			{
				email: A2(author$project$Data$Field$setValue, newEmail, model.email)
			});
	});
var author$project$Page$ResetPassword$setPassword = F2(
	function (newPassword, model) {
		return _Utils_update(
			model,
			{
				password: A2(author$project$Data$Field$setValue, newPassword, model.password)
			});
	});
var author$project$Page$ResetPassword$setPasswordConfirm = F2(
	function (newPasswordConfirm, model) {
		return _Utils_update(
			model,
			{
				passwordConfirm: A2(author$project$Data$Field$setValue, newPasswordConfirm, model.passwordConfirm)
			});
	});
var author$project$Page$ResetPassword$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'GotResetPasswordResponse':
				var result = msg.a;
				var _n1 = model.status;
				if (_n1.$ === 'Waiting') {
					if (result.$ === 'Ok') {
						return author$project$Util$Cmd$withNoCmd(
							A2(author$project$Page$ResetPassword$setStatus, author$project$Page$ResetPassword$Success, model));
					} else {
						var error = result.a;
						return author$project$Util$Cmd$withNoCmd(
							A2(
								author$project$Page$ResetPassword$setStatus,
								author$project$Page$ResetPassword$Fail(error),
								model));
					}
				} else {
					return author$project$Util$Cmd$withNoCmd(model);
				}
			case 'LoginClicked':
				return _Utils_Tuple2(
					model,
					A2(
						author$project$Route$goTo,
						author$project$Session$getNavKey(model.session),
						author$project$Route$Login));
			case 'TryAgainClicked':
				return author$project$Page$ResetPassword$init(model.session);
			case 'EmailUpdated':
				var newEmail = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					A2(author$project$Page$ResetPassword$setEmail, newEmail, model));
			case 'CodeUpdated':
				var newCode = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					A2(author$project$Page$ResetPassword$setCode, newCode, model));
			case 'PasswordUpdated':
				var newPassword = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					A2(author$project$Page$ResetPassword$setPassword, newPassword, model));
			case 'PasswordConfirmUpdated':
				var newPasswordConfirm = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					A2(author$project$Page$ResetPassword$setPasswordConfirm, newPasswordConfirm, model));
			case 'ResetPasswordClicked':
				return author$project$Page$ResetPassword$attemptSubmission(model);
			default:
				return author$project$Page$ResetPassword$attemptSubmission(model);
		}
	});
var author$project$Page$Settings$becomeReady = function (model) {
	return _Utils_update(
		model,
		{status: author$project$Page$Settings$Ready});
};
var author$project$Page$Settings$toAccount = function (model) {
	return {
		email: model.account.email,
		name: author$project$Data$Field$getValue(model.nameField)
	};
};
var author$project$Page$Settings$hasChanges = function (model) {
	return !_Utils_eq(
		author$project$Page$Settings$toAccount(model),
		model.account);
};
var author$project$Page$Settings$canSave = function (model) {
	return _Utils_eq(model.status, author$project$Page$Settings$Ready) && (!author$project$Page$Settings$hasChanges(model));
};
var author$project$Page$Settings$Fail = function (a) {
	return {$: 'Fail', a: a};
};
var author$project$Page$Settings$fail = F2(
	function (error, model) {
		return _Utils_update(
			model,
			{
				status: author$project$Page$Settings$Fail(error)
			});
	});
var author$project$Page$Settings$Saving = {$: 'Saving'};
var author$project$Page$Settings$saving = function (model) {
	return _Utils_update(
		model,
		{status: author$project$Page$Settings$Saving});
};
var author$project$Page$Settings$setName = F2(
	function (newName, model) {
		return _Utils_update(
			model,
			{
				nameField: A2(author$project$Data$Field$setValue, newName, model.nameField)
			});
	});
var author$project$Page$Settings$setTab = F2(
	function (tab, model) {
		return _Utils_update(
			model,
			{tab: tab});
	});
var author$project$Page$Settings$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'TabClickedOn':
				var tab = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					A2(author$project$Page$Settings$setTab, tab, model));
			case 'NameUpdated':
				var nameField = msg.a;
				return author$project$Util$Cmd$withNoCmd(
					A2(author$project$Page$Settings$setName, nameField, model));
			case 'SaveClicked':
				return author$project$Page$Settings$canSave(model) ? _Utils_Tuple2(
					author$project$Page$Settings$saving(model),
					author$project$Ports$send(
						A3(
							author$project$Ports$withString,
							'name',
							author$project$Data$Field$getValue(model.nameField),
							A3(
								author$project$Ports$withString,
								'email',
								model.account.email,
								author$project$Ports$payload('update user'))))) : author$project$Util$Cmd$withNoCmd(model);
			default:
				var response = msg.a;
				if (response.$ === 'Ok') {
					return author$project$Util$Cmd$withNoCmd(
						author$project$Page$Settings$becomeReady(model));
				} else {
					var error = response.a;
					return author$project$Util$Cmd$withNoCmd(
						A2(author$project$Page$Settings$fail, error, model));
				}
		}
	});
var author$project$Route$paintApp = author$project$Route$PaintApp(author$project$Route$PaintApp$Landing);
var author$project$Page$Splash$update = F2(
	function (key, msg) {
		if (msg.$ === 'LearnMoreClicked') {
			return A2(author$project$Route$goTo, key, author$project$Route$About);
		} else {
			return A2(author$project$Route$goTo, key, author$project$Route$paintApp);
		}
	});
var author$project$Session$setWindowSize = F2(
	function (newSize, session) {
		return _Utils_update(
			session,
			{windowSize: newSize});
	});
var author$project$Ui$Nav$Option$toRoute = function (option) {
	switch (option.$) {
		case 'Draw':
			return author$project$Route$paintApp;
		case 'Title':
			return author$project$Route$Landing;
		case 'About':
			return author$project$Route$About;
		case 'Login':
			return author$project$Route$Login;
		case 'Logout':
			return author$project$Route$Logout;
		default:
			return author$project$Route$Settings;
	}
};
var author$project$Ui$Nav$update = F2(
	function (navKey, msg) {
		var option = msg.a;
		return A2(
			author$project$Route$goTo,
			navKey,
			author$project$Ui$Nav$Option$toRoute(option));
	});
var author$project$Main$updateFromOk = F2(
	function (msg, model) {
		updateFromOk:
		while (true) {
			var user = author$project$Model$getUser(model);
			var session = author$project$Model$getSession(model);
			switch (msg.$) {
				case 'UrlChanged':
					var routeResult = msg.a;
					return A3(author$project$Main$handleRoute, session, user, routeResult);
				case 'UrlRequested':
					return author$project$Util$Cmd$withNoCmd(model);
				case 'NavMsg':
					var navMsg = msg.a;
					return _Utils_Tuple2(
						model,
						A2(
							elm$core$Platform$Cmd$map,
							author$project$Main$NavMsg,
							A2(
								author$project$Ui$Nav$update,
								author$project$Session$getNavKey(session),
								navMsg)));
				case 'SplashMsg':
					var subMsg = msg.a;
					if (model.$ === 'Splash') {
						return _Utils_Tuple2(
							model,
							A2(
								elm$core$Platform$Cmd$map,
								author$project$Main$SplashMsg,
								A2(
									author$project$Page$Splash$update,
									author$project$Session$getNavKey(session),
									subMsg)));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				case 'LoginMsg':
					var subMsg = msg.a;
					if (model.$ === 'Login') {
						var subModel = model.a;
						return A2(
							author$project$Util$Cmd$mapCmd,
							author$project$Main$LoginMsg,
							A2(
								author$project$Util$Cmd$mapModel,
								author$project$Model$Login,
								A2(author$project$Page$Login$update, subMsg, subModel)));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				case 'ResetPasswordMsg':
					var subMsg = msg.a;
					if (model.$ === 'ResetPassword') {
						var subModel = model.a;
						return A2(
							author$project$Util$Cmd$mapCmd,
							author$project$Main$ResetPasswordMsg,
							A2(
								author$project$Util$Cmd$mapModel,
								author$project$Model$ResetPassword,
								A2(author$project$Page$ResetPassword$update, subMsg, subModel)));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				case 'PageNotFoundMsg':
					var subMsg = msg.a;
					if (model.$ === 'PageNotFound') {
						return _Utils_Tuple2(
							model,
							A2(
								elm$core$Platform$Cmd$map,
								author$project$Main$PageNotFoundMsg,
								A2(
									author$project$Page$PageNotFound$update,
									author$project$Session$getNavKey(session),
									subMsg)));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				case 'ListenerNotFound':
					return author$project$Util$Cmd$withNoCmd(model);
				case 'FailedToDecodeJsMsg':
					return author$project$Util$Cmd$withNoCmd(model);
				case 'HomeMsg':
					var subMsg = msg.a;
					if (model.$ === 'Home') {
						var subModel = model.a;
						return A2(
							author$project$Util$Cmd$mapCmd,
							author$project$Main$HomeMsg,
							A2(
								elm$core$Tuple$mapFirst,
								author$project$Model$Home,
								A2(author$project$Page$Home$update, subMsg, subModel)));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				case 'SettingsMsg':
					var subMsg = msg.a;
					if (model.$ === 'Settings') {
						var subModel = model.a;
						return A2(
							author$project$Util$Cmd$mapCmd,
							author$project$Main$SettingsMsg,
							A2(
								elm$core$Tuple$mapFirst,
								author$project$Model$Settings,
								A2(author$project$Page$Settings$update, subMsg, subModel)));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				case 'ContactMsg':
					var subMsg = msg.a;
					if (model.$ === 'Contact') {
						var subModel = model.a;
						return A2(
							elm$core$Tuple$mapFirst,
							author$project$Model$Contact,
							A2(author$project$Page$Contact$update, subMsg, subModel));
					} else {
						return author$project$Util$Cmd$withNoCmd(model);
					}
				case 'WindowResized':
					var size = msg.a;
					return author$project$Util$Cmd$withNoCmd(
						A2(
							author$project$Model$mapSession,
							author$project$Session$setWindowSize(size),
							model));
				default:
					var json = msg.a;
					var $temp$msg = A2(author$project$Main$decodeMsg, model, json),
						$temp$model = model;
					msg = $temp$msg;
					model = $temp$model;
					continue updateFromOk;
			}
		}
	});
var author$project$Util$Cmd$addCmd = F2(
	function (extra, _n0) {
		var model = _n0.a;
		var cmd = _n0.b;
		return _Utils_Tuple2(
			model,
			elm$core$Platform$Cmd$batch(
				_List_fromArray(
					[extra, cmd])));
	});
var author$project$Main$update = F2(
	function (msg, result) {
		if (result.$ === 'Ok') {
			var model = result.a;
			return A2(
				author$project$Util$Cmd$addCmd,
				A2(author$project$Main$track, msg, model),
				A2(
					elm$core$Tuple$mapFirst,
					elm$core$Result$Ok,
					A2(author$project$Main$updateFromOk, msg, model)));
		} else {
			var err = result.a;
			return _Utils_Tuple2(
				elm$core$Result$Err(err),
				elm$core$Platform$Cmd$none);
		}
	});
var author$project$Data$User$decoder = elm$json$Json$Decode$oneOf(
	_List_fromArray(
		[
			elm$json$Json$Decode$null(author$project$Data$User$User),
			A2(author$project$Util$Json$Decode$matchString, 'offline', author$project$Data$User$User),
			A2(elm$json$Json$Decode$map, author$project$Data$User$Account, author$project$Data$Account$decoder)
		]));
var author$project$Data$BuildNumber$BuildNumber = function (a) {
	return {$: 'BuildNumber', a: a};
};
var author$project$Data$BuildNumber$decoder = A2(elm$json$Json$Decode$map, author$project$Data$BuildNumber$BuildNumber, elm$json$Json$Decode$int);
var author$project$Data$MountPath$MountPath = function (a) {
	return {$: 'MountPath', a: a};
};
var author$project$Data$MountPath$decoder = A2(elm$json$Json$Decode$map, author$project$Data$MountPath$MountPath, elm$json$Json$Decode$string);
var elm$core$Char$fromCode = _Char_fromCode;
var Chadtech$elm_relational_database$Id$toChar = function (_int) {
	var code = (_int < 10) ? (_int + 48) : ((_int < 36) ? (_int + 55) : (_int + 61));
	return elm$core$Char$fromCode(code);
};
var Chadtech$elm_relational_database$Id$intsToString = A2(
	elm$core$Basics$composeR,
	elm$core$List$map(Chadtech$elm_relational_database$Id$toChar),
	elm$core$String$fromList);
var elm$random$Random$Generator = function (a) {
	return {$: 'Generator', a: a};
};
var elm$random$Random$Seed = F2(
	function (a, b) {
		return {$: 'Seed', a: a, b: b};
	});
var elm$random$Random$next = function (_n0) {
	var state0 = _n0.a;
	var incr = _n0.b;
	return A2(elm$random$Random$Seed, ((state0 * 1664525) + incr) >>> 0, incr);
};
var elm$random$Random$peel = function (_n0) {
	var state = _n0.a;
	var word = (state ^ (state >>> ((state >>> 28) + 4))) * 277803737;
	return ((word >>> 22) ^ word) >>> 0;
};
var elm$random$Random$int = F2(
	function (a, b) {
		return elm$random$Random$Generator(
			function (seed0) {
				var _n0 = (_Utils_cmp(a, b) < 0) ? _Utils_Tuple2(a, b) : _Utils_Tuple2(b, a);
				var lo = _n0.a;
				var hi = _n0.b;
				var range = (hi - lo) + 1;
				if (!((range - 1) & range)) {
					return _Utils_Tuple2(
						(((range - 1) & elm$random$Random$peel(seed0)) >>> 0) + lo,
						elm$random$Random$next(seed0));
				} else {
					var threshhold = (((-range) >>> 0) % range) >>> 0;
					var accountForBias = function (seed) {
						accountForBias:
						while (true) {
							var x = elm$random$Random$peel(seed);
							var seedN = elm$random$Random$next(seed);
							if (_Utils_cmp(x, threshhold) < 0) {
								var $temp$seed = seedN;
								seed = $temp$seed;
								continue accountForBias;
							} else {
								return _Utils_Tuple2((x % range) + lo, seedN);
							}
						}
					};
					return accountForBias(seed0);
				}
			});
	});
var elm$random$Random$listHelp = F4(
	function (revList, n, gen, seed) {
		listHelp:
		while (true) {
			if (n < 1) {
				return _Utils_Tuple2(revList, seed);
			} else {
				var _n0 = gen(seed);
				var value = _n0.a;
				var newSeed = _n0.b;
				var $temp$revList = A2(elm$core$List$cons, value, revList),
					$temp$n = n - 1,
					$temp$gen = gen,
					$temp$seed = newSeed;
				revList = $temp$revList;
				n = $temp$n;
				gen = $temp$gen;
				seed = $temp$seed;
				continue listHelp;
			}
		}
	});
var elm$random$Random$list = F2(
	function (n, _n0) {
		var gen = _n0.a;
		return elm$random$Random$Generator(
			function (seed) {
				return A4(elm$random$Random$listHelp, _List_Nil, n, gen, seed);
			});
	});
var elm$random$Random$map = F2(
	function (func, _n0) {
		var genA = _n0.a;
		return elm$random$Random$Generator(
			function (seed0) {
				var _n1 = genA(seed0);
				var a = _n1.a;
				var seed1 = _n1.b;
				return _Utils_Tuple2(
					func(a),
					seed1);
			});
	});
var Chadtech$elm_relational_database$Id$generator = A2(
	elm$random$Random$map,
	A2(elm$core$Basics$composeR, Chadtech$elm_relational_database$Id$intsToString, Chadtech$elm_relational_database$Id$Id),
	A2(
		elm$random$Random$list,
		64,
		A2(elm$random$Random$int, 0, 61)));
var author$project$Data$SessionId$SessionId = function (a) {
	return {$: 'SessionId', a: a};
};
var author$project$Data$SessionId$generator = A2(elm$random$Random$map, author$project$Data$SessionId$SessionId, Chadtech$elm_relational_database$Id$generator);
var author$project$Session$Session = F6(
	function (mountPath, navKey, buildNumber, sessionId, seed, windowSize) {
		return {buildNumber: buildNumber, mountPath: mountPath, navKey: navKey, seed: seed, sessionId: sessionId, windowSize: windowSize};
	});
var author$project$Util$Json$Decode$set = function (value) {
	return author$project$Util$Json$Decode$apply(
		elm$json$Json$Decode$succeed(value));
};
var elm$random$Random$initialSeed = function (x) {
	var _n0 = elm$random$Random$next(
		A2(elm$random$Random$Seed, 0, 1013904223));
	var state1 = _n0.a;
	var incr = _n0.b;
	var state2 = (state1 + x) >>> 0;
	return elm$random$Random$next(
		A2(elm$random$Random$Seed, state2, incr));
};
var elm$random$Random$step = F2(
	function (_n0, seed) {
		var generator = _n0.a;
		return generator(seed);
	});
var author$project$Session$decoder = function (navKey) {
	var windowSizeDecoder = A3(
		author$project$Util$Json$Decode$applyField,
		'windowWidth',
		elm$json$Json$Decode$int,
		A3(
			author$project$Util$Json$Decode$applyField,
			'windowHeight',
			elm$json$Json$Decode$int,
			elm$json$Json$Decode$succeed(author$project$Data$Size$Size)));
	var fromSeed = function (seed0) {
		var _n0 = A2(elm$random$Random$step, author$project$Data$SessionId$generator, seed0);
		var sessionId = _n0.a;
		var seed1 = _n0.b;
		return A2(
			author$project$Util$Json$Decode$apply,
			windowSizeDecoder,
			A2(
				author$project$Util$Json$Decode$set,
				seed1,
				A2(
					author$project$Util$Json$Decode$set,
					sessionId,
					A3(
						author$project$Util$Json$Decode$applyField,
						'buildNumber',
						author$project$Data$BuildNumber$decoder,
						A2(
							author$project$Util$Json$Decode$set,
							navKey,
							A3(
								author$project$Util$Json$Decode$applyField,
								'mountPath',
								author$project$Data$MountPath$decoder,
								elm$json$Json$Decode$succeed(author$project$Session$Session)))))));
	};
	return A2(
		elm$json$Json$Decode$andThen,
		fromSeed,
		A2(
			elm$json$Json$Decode$field,
			'seed',
			A2(elm$json$Json$Decode$map, elm$random$Random$initialSeed, elm$json$Json$Decode$int)));
};
var author$project$Model$decoder = function (navKey) {
	return A3(
		elm$json$Json$Decode$map2,
		F2(
			function (user, session) {
				return author$project$Model$Blank(
					{session: session, user: user});
			}),
		A2(elm$json$Json$Decode$field, 'user', author$project$Data$User$decoder),
		author$project$Session$decoder(navKey));
};
var author$project$Main$init = F3(
	function (json, url, key) {
		var _n0 = A2(
			elm$json$Json$Decode$decodeValue,
			author$project$Model$decoder(
				author$project$Data$NavKey$fromNativeKey(key)),
			json);
		if (_n0.$ === 'Ok') {
			var model = _n0.a;
			return A2(
				author$project$Main$update,
				author$project$Main$onNavigation(url),
				elm$core$Result$Ok(model));
		} else {
			var decodeError = _n0.a;
			return _Utils_Tuple2(
				elm$core$Result$Err(decodeError),
				author$project$Data$Tracking$send(
					A3(
						author$project$Data$Tracking$withString,
						'error',
						elm$json$Json$Decode$errorToString(decodeError),
						author$project$Data$Tracking$event('init failed'))));
		}
	});
var author$project$Main$JsMsg = function (a) {
	return {$: 'JsMsg', a: a};
};
var author$project$Ports$fromJs = _Platform_incomingPort('fromJs', elm$json$Json$Decode$value);
var author$project$Main$subscriptionsFromOk = function (model) {
	return author$project$Ports$fromJs(author$project$Main$JsMsg);
};
var elm$core$Platform$Sub$batch = _Platform_batch;
var elm$core$Platform$Sub$none = elm$core$Platform$Sub$batch(_List_Nil);
var elm$core$Result$map = F2(
	function (func, ra) {
		if (ra.$ === 'Ok') {
			var a = ra.a;
			return elm$core$Result$Ok(
				func(a));
		} else {
			var e = ra.a;
			return elm$core$Result$Err(e);
		}
	});
var elm$core$Result$withDefault = F2(
	function (def, result) {
		if (result.$ === 'Ok') {
			var a = result.a;
			return a;
		} else {
			return def;
		}
	});
var author$project$Main$subscriptions = function (result) {
	return A2(
		elm$core$Result$withDefault,
		elm$core$Platform$Sub$none,
		A2(elm$core$Result$map, author$project$Main$subscriptionsFromOk, result));
};
var elm$core$Basics$pow = _Basics_pow;
var author$project$Style$scale = function (degree) {
	return A2(elm$core$Basics$pow, 2, degree);
};
var rtfeldman$elm_css$Css$PxUnits = {$: 'PxUnits'};
var elm$core$String$fromFloat = _String_fromNumber;
var rtfeldman$elm_css$Css$Structure$Compatible = {$: 'Compatible'};
var rtfeldman$elm_css$Css$Internal$lengthConverter = F3(
	function (units, unitLabel, numericValue) {
		return {
			absoluteLength: rtfeldman$elm_css$Css$Structure$Compatible,
			calc: rtfeldman$elm_css$Css$Structure$Compatible,
			flexBasis: rtfeldman$elm_css$Css$Structure$Compatible,
			fontSize: rtfeldman$elm_css$Css$Structure$Compatible,
			length: rtfeldman$elm_css$Css$Structure$Compatible,
			lengthOrAuto: rtfeldman$elm_css$Css$Structure$Compatible,
			lengthOrAutoOrCoverOrContain: rtfeldman$elm_css$Css$Structure$Compatible,
			lengthOrMinMaxDimension: rtfeldman$elm_css$Css$Structure$Compatible,
			lengthOrNone: rtfeldman$elm_css$Css$Structure$Compatible,
			lengthOrNoneOrMinMaxDimension: rtfeldman$elm_css$Css$Structure$Compatible,
			lengthOrNumber: rtfeldman$elm_css$Css$Structure$Compatible,
			lengthOrNumberOrAutoOrNoneOrContent: rtfeldman$elm_css$Css$Structure$Compatible,
			numericValue: numericValue,
			textIndent: rtfeldman$elm_css$Css$Structure$Compatible,
			unitLabel: unitLabel,
			units: units,
			value: _Utils_ap(
				elm$core$String$fromFloat(numericValue),
				unitLabel)
		};
	});
var rtfeldman$elm_css$Css$px = A2(rtfeldman$elm_css$Css$Internal$lengthConverter, rtfeldman$elm_css$Css$PxUnits, 'px');
var author$project$Style$sizePx = A2(
	elm$core$Basics$composeR,
	author$project$Style$scale,
	A2(elm$core$Basics$composeR, elm$core$Basics$toFloat, rtfeldman$elm_css$Css$px));
var rtfeldman$elm_css$Css$Preprocess$AppendProperty = function (a) {
	return {$: 'AppendProperty', a: a};
};
var rtfeldman$elm_css$Css$property = F2(
	function (key, value) {
		return rtfeldman$elm_css$Css$Preprocess$AppendProperty(key + (':' + value));
	});
var rtfeldman$elm_css$Css$prop1 = F2(
	function (key, arg) {
		return A2(rtfeldman$elm_css$Css$property, key, arg.value);
	});
var rtfeldman$elm_css$Css$width = rtfeldman$elm_css$Css$prop1('width');
var author$project$Style$width = A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$width, author$project$Style$sizePx);
var Chadtech$elm_css_grid$Html$Grid$Column = function (a) {
	return {$: 'Column', a: a};
};
var rtfeldman$elm_css$Css$Preprocess$ApplyStyles = function (a) {
	return {$: 'ApplyStyles', a: a};
};
var rtfeldman$elm_css$Css$batch = rtfeldman$elm_css$Css$Preprocess$ApplyStyles;
var rtfeldman$elm_css$Css$displayFlex = A2(rtfeldman$elm_css$Css$property, 'display', 'flex');
var rtfeldman$elm_css$Css$flex = rtfeldman$elm_css$Css$prop1('flex');
var rtfeldman$elm_css$Css$flexBasis = rtfeldman$elm_css$Css$prop1('flex-basis');
var rtfeldman$elm_css$Css$UnitlessInteger = {$: 'UnitlessInteger'};
var rtfeldman$elm_css$Css$int = function (val) {
	return {
		fontWeight: rtfeldman$elm_css$Css$Structure$Compatible,
		intOrAuto: rtfeldman$elm_css$Css$Structure$Compatible,
		lengthOrNumber: rtfeldman$elm_css$Css$Structure$Compatible,
		lengthOrNumberOrAutoOrNoneOrContent: rtfeldman$elm_css$Css$Structure$Compatible,
		number: rtfeldman$elm_css$Css$Structure$Compatible,
		numberOrInfinite: rtfeldman$elm_css$Css$Structure$Compatible,
		numericValue: val,
		unitLabel: '',
		units: rtfeldman$elm_css$Css$UnitlessInteger,
		value: elm$core$String$fromInt(val)
	};
};
var rtfeldman$elm_css$Css$PercentageUnits = {$: 'PercentageUnits'};
var rtfeldman$elm_css$Css$pct = A2(rtfeldman$elm_css$Css$Internal$lengthConverter, rtfeldman$elm_css$Css$PercentageUnits, '%');
var elm$virtual_dom$VirtualDom$property = F2(
	function (key, value) {
		return A2(
			_VirtualDom_property,
			_VirtualDom_noInnerHtmlOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var rtfeldman$elm_css$VirtualDom$Styled$Attribute = F3(
	function (a, b, c) {
		return {$: 'Attribute', a: a, b: b, c: c};
	});
var rtfeldman$elm_css$VirtualDom$Styled$murmurSeed = 15739;
var rtfeldman$elm_css$VirtualDom$Styled$getClassname = function (styles) {
	return elm$core$List$isEmpty(styles) ? 'unstyled' : A2(
		elm$core$String$cons,
		_Utils_chr('_'),
		rtfeldman$elm_hex$Hex$toString(
			A2(
				Skinney$murmur3$Murmur3$hashString,
				rtfeldman$elm_css$VirtualDom$Styled$murmurSeed,
				rtfeldman$elm_css$Css$Preprocess$Resolve$compile(
					elm$core$List$singleton(
						rtfeldman$elm_css$Css$Preprocess$stylesheet(
							elm$core$List$singleton(
								A2(
									rtfeldman$elm_css$VirtualDom$Styled$makeSnippet,
									styles,
									rtfeldman$elm_css$Css$Structure$UniversalSelectorSequence(_List_Nil)))))))));
};
var rtfeldman$elm_css$Html$Styled$Internal$css = function (styles) {
	var classname = rtfeldman$elm_css$VirtualDom$Styled$getClassname(styles);
	var classProperty = A2(
		elm$virtual_dom$VirtualDom$property,
		'className',
		elm$json$Json$Encode$string(classname));
	return A3(rtfeldman$elm_css$VirtualDom$Styled$Attribute, classProperty, styles, classname);
};
var rtfeldman$elm_css$Html$Styled$Attributes$css = rtfeldman$elm_css$Html$Styled$Internal$css;
var Chadtech$elm_css_grid$Html$Grid$columnStyles = function (styles) {
	return rtfeldman$elm_css$Html$Styled$Attributes$css(
		_List_fromArray(
			[
				rtfeldman$elm_css$Css$flexBasis(
				rtfeldman$elm_css$Css$pct(100)),
				rtfeldman$elm_css$Css$flex(
				rtfeldman$elm_css$Css$int(1)),
				rtfeldman$elm_css$Css$displayFlex,
				rtfeldman$elm_css$Css$batch(styles)
			]));
};
var rtfeldman$elm_css$VirtualDom$Styled$Node = F3(
	function (a, b, c) {
		return {$: 'Node', a: a, b: b, c: c};
	});
var rtfeldman$elm_css$VirtualDom$Styled$node = rtfeldman$elm_css$VirtualDom$Styled$Node;
var rtfeldman$elm_css$Html$Styled$node = rtfeldman$elm_css$VirtualDom$Styled$node;
var Chadtech$elm_css_grid$Html$Grid$column = F2(
	function (styles, children) {
		return Chadtech$elm_css_grid$Html$Grid$Column(
			A3(
				rtfeldman$elm_css$Html$Styled$node,
				'column',
				_List_fromArray(
					[
						Chadtech$elm_css_grid$Html$Grid$columnStyles(styles)
					]),
				children));
	});
var Chadtech$elm_css_grid$Html$Grid$columnToHtml = function (_n0) {
	var html = _n0.a;
	return html;
};
var rtfeldman$elm_css$Css$flexDirection = rtfeldman$elm_css$Css$prop1('flex-direction');
var rtfeldman$elm_css$Css$row = {flexDirection: rtfeldman$elm_css$Css$Structure$Compatible, flexDirectionOrWrap: rtfeldman$elm_css$Css$Structure$Compatible, value: 'row'};
var Chadtech$elm_css_grid$Html$Grid$rowStyles = function (extraStyles) {
	return rtfeldman$elm_css$Html$Styled$Attributes$css(
		_List_fromArray(
			[
				rtfeldman$elm_css$Css$displayFlex,
				rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$row),
				rtfeldman$elm_css$Css$batch(extraStyles)
			]));
};
var Chadtech$elm_css_grid$Html$Grid$row = F2(
	function (styles, columns) {
		return A3(
			rtfeldman$elm_css$Html$Styled$node,
			'row',
			_List_fromArray(
				[
					Chadtech$elm_css_grid$Html$Grid$rowStyles(styles)
				]),
			A2(elm$core$List$map, Chadtech$elm_css_grid$Html$Grid$columnToHtml, columns));
	});
var author$project$View$TextArea$TextArea = F2(
	function (a, b) {
		return {$: 'TextArea', a: a, b: b};
	});
var author$project$View$TextArea$readOnly = function (value) {
	return A2(
		author$project$View$TextArea$TextArea,
		{value: value},
		_List_Nil);
};
var rtfeldman$elm_css$Css$withPrecedingHash = function (str) {
	return A2(elm$core$String$startsWith, '#', str) ? str : A2(
		elm$core$String$cons,
		_Utils_chr('#'),
		str);
};
var rtfeldman$elm_css$Css$erroneousHex = function (str) {
	return {
		alpha: 1,
		blue: 0,
		color: rtfeldman$elm_css$Css$Structure$Compatible,
		green: 0,
		red: 0,
		value: rtfeldman$elm_css$Css$withPrecedingHash(str)
	};
};
var elm$core$String$fromChar = function (_char) {
	return A2(elm$core$String$cons, _char, '');
};
var rtfeldman$elm_hex$Hex$fromStringHelp = F3(
	function (position, chars, accumulated) {
		fromStringHelp:
		while (true) {
			if (!chars.b) {
				return elm$core$Result$Ok(accumulated);
			} else {
				var _char = chars.a;
				var rest = chars.b;
				switch (_char.valueOf()) {
					case '0':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated;
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '1':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + A2(elm$core$Basics$pow, 16, position);
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '2':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (2 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '3':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (3 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '4':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (4 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '5':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (5 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '6':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (6 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '7':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (7 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '8':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (8 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case '9':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (9 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case 'a':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (10 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case 'b':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (11 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case 'c':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (12 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case 'd':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (13 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case 'e':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (14 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					case 'f':
						var $temp$position = position - 1,
							$temp$chars = rest,
							$temp$accumulated = accumulated + (15 * A2(elm$core$Basics$pow, 16, position));
						position = $temp$position;
						chars = $temp$chars;
						accumulated = $temp$accumulated;
						continue fromStringHelp;
					default:
						var nonHex = _char;
						return elm$core$Result$Err(
							elm$core$String$fromChar(nonHex) + ' is not a valid hexadecimal character.');
				}
			}
		}
	});
var rtfeldman$elm_hex$Hex$fromString = function (str) {
	if (elm$core$String$isEmpty(str)) {
		return elm$core$Result$Err('Empty strings are not valid hexadecimal strings.');
	} else {
		var result = function () {
			if (A2(elm$core$String$startsWith, '-', str)) {
				var list = A2(
					elm$core$Maybe$withDefault,
					_List_Nil,
					elm$core$List$tail(
						elm$core$String$toList(str)));
				return A2(
					elm$core$Result$map,
					elm$core$Basics$negate,
					A3(
						rtfeldman$elm_hex$Hex$fromStringHelp,
						elm$core$List$length(list) - 1,
						list,
						0));
			} else {
				return A3(
					rtfeldman$elm_hex$Hex$fromStringHelp,
					elm$core$String$length(str) - 1,
					elm$core$String$toList(str),
					0);
			}
		}();
		var formatError = function (err) {
			return A2(
				elm$core$String$join,
				' ',
				_List_fromArray(
					['\"' + (str + '\"'), 'is not a valid hexadecimal string because', err]));
		};
		return A2(elm$core$Result$mapError, formatError, result);
	}
};
var rtfeldman$elm_css$Css$validHex = F5(
	function (str, _n0, _n1, _n2, _n3) {
		var r1 = _n0.a;
		var r2 = _n0.b;
		var g1 = _n1.a;
		var g2 = _n1.b;
		var b1 = _n2.a;
		var b2 = _n2.b;
		var a1 = _n3.a;
		var a2 = _n3.b;
		var toResult = A2(
			elm$core$Basics$composeR,
			elm$core$String$fromList,
			A2(elm$core$Basics$composeR, elm$core$String$toLower, rtfeldman$elm_hex$Hex$fromString));
		var results = _Utils_Tuple2(
			_Utils_Tuple2(
				toResult(
					_List_fromArray(
						[r1, r2])),
				toResult(
					_List_fromArray(
						[g1, g2]))),
			_Utils_Tuple2(
				toResult(
					_List_fromArray(
						[b1, b2])),
				toResult(
					_List_fromArray(
						[a1, a2]))));
		if ((((results.a.a.$ === 'Ok') && (results.a.b.$ === 'Ok')) && (results.b.a.$ === 'Ok')) && (results.b.b.$ === 'Ok')) {
			var _n5 = results.a;
			var red = _n5.a.a;
			var green = _n5.b.a;
			var _n6 = results.b;
			var blue = _n6.a.a;
			var alpha = _n6.b.a;
			return {
				alpha: alpha / 255,
				blue: blue,
				color: rtfeldman$elm_css$Css$Structure$Compatible,
				green: green,
				red: red,
				value: rtfeldman$elm_css$Css$withPrecedingHash(str)
			};
		} else {
			return rtfeldman$elm_css$Css$erroneousHex(str);
		}
	});
var rtfeldman$elm_css$Css$hex = function (str) {
	var withoutHash = A2(elm$core$String$startsWith, '#', str) ? A2(elm$core$String$dropLeft, 1, str) : str;
	var _n0 = elm$core$String$toList(withoutHash);
	_n0$4:
	while (true) {
		if ((_n0.b && _n0.b.b) && _n0.b.b.b) {
			if (!_n0.b.b.b.b) {
				var r = _n0.a;
				var _n1 = _n0.b;
				var g = _n1.a;
				var _n2 = _n1.b;
				var b = _n2.a;
				return A5(
					rtfeldman$elm_css$Css$validHex,
					str,
					_Utils_Tuple2(r, r),
					_Utils_Tuple2(g, g),
					_Utils_Tuple2(b, b),
					_Utils_Tuple2(
						_Utils_chr('f'),
						_Utils_chr('f')));
			} else {
				if (!_n0.b.b.b.b.b) {
					var r = _n0.a;
					var _n3 = _n0.b;
					var g = _n3.a;
					var _n4 = _n3.b;
					var b = _n4.a;
					var _n5 = _n4.b;
					var a = _n5.a;
					return A5(
						rtfeldman$elm_css$Css$validHex,
						str,
						_Utils_Tuple2(r, r),
						_Utils_Tuple2(g, g),
						_Utils_Tuple2(b, b),
						_Utils_Tuple2(a, a));
				} else {
					if (_n0.b.b.b.b.b.b) {
						if (!_n0.b.b.b.b.b.b.b) {
							var r1 = _n0.a;
							var _n6 = _n0.b;
							var r2 = _n6.a;
							var _n7 = _n6.b;
							var g1 = _n7.a;
							var _n8 = _n7.b;
							var g2 = _n8.a;
							var _n9 = _n8.b;
							var b1 = _n9.a;
							var _n10 = _n9.b;
							var b2 = _n10.a;
							return A5(
								rtfeldman$elm_css$Css$validHex,
								str,
								_Utils_Tuple2(r1, r2),
								_Utils_Tuple2(g1, g2),
								_Utils_Tuple2(b1, b2),
								_Utils_Tuple2(
									_Utils_chr('f'),
									_Utils_chr('f')));
						} else {
							if (_n0.b.b.b.b.b.b.b.b && (!_n0.b.b.b.b.b.b.b.b.b)) {
								var r1 = _n0.a;
								var _n11 = _n0.b;
								var r2 = _n11.a;
								var _n12 = _n11.b;
								var g1 = _n12.a;
								var _n13 = _n12.b;
								var g2 = _n13.a;
								var _n14 = _n13.b;
								var b1 = _n14.a;
								var _n15 = _n14.b;
								var b2 = _n15.a;
								var _n16 = _n15.b;
								var a1 = _n16.a;
								var _n17 = _n16.b;
								var a2 = _n17.a;
								return A5(
									rtfeldman$elm_css$Css$validHex,
									str,
									_Utils_Tuple2(r1, r2),
									_Utils_Tuple2(g1, g2),
									_Utils_Tuple2(b1, b2),
									_Utils_Tuple2(a1, a2));
							} else {
								break _n0$4;
							}
						}
					} else {
						break _n0$4;
					}
				}
			}
		} else {
			break _n0$4;
		}
	}
	return rtfeldman$elm_css$Css$erroneousHex(str);
};
var Chadtech$ct_colors$Chadtech$Colors$content4 = rtfeldman$elm_css$Css$hex('#B0A69A');
var rtfeldman$elm_css$Css$stringsToValue = function (list) {
	return elm$core$List$isEmpty(list) ? {value: 'none'} : {
		value: A2(
			elm$core$String$join,
			', ',
			A2(
				elm$core$List$map,
				function (s) {
					return s;
				},
				list))
	};
};
var rtfeldman$elm_css$Css$fontFamilies = A2(
	elm$core$Basics$composeL,
	rtfeldman$elm_css$Css$prop1('font-family'),
	rtfeldman$elm_css$Css$stringsToValue);
var rtfeldman$elm_css$Css$fontSize = rtfeldman$elm_css$Css$prop1('font-size');
var author$project$Style$hfnss = rtfeldman$elm_css$Css$batch(
	_List_fromArray(
		[
			rtfeldman$elm_css$Css$fontFamilies(
			_List_fromArray(
				['HFNSS'])),
			rtfeldman$elm_css$Css$fontSize(
			author$project$Style$sizePx(5))
		]));
var author$project$Style$font = author$project$Style$hfnss;
var author$project$Style$fontSmoothingNone = A2(rtfeldman$elm_css$Css$property, '-webkit-font-smoothing', 'none');
var author$project$Style$fullWidth = rtfeldman$elm_css$Css$width(
	rtfeldman$elm_css$Css$pct(100));
var rtfeldman$elm_css$Css$height = rtfeldman$elm_css$Css$prop1('height');
var author$project$Style$height = A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$height, author$project$Style$sizePx);
var rtfeldman$elm_css$Css$none = {backgroundImage: rtfeldman$elm_css$Css$Structure$Compatible, blockAxisOverflow: rtfeldman$elm_css$Css$Structure$Compatible, borderStyle: rtfeldman$elm_css$Css$Structure$Compatible, cursor: rtfeldman$elm_css$Css$Structure$Compatible, display: rtfeldman$elm_css$Css$Structure$Compatible, hoverCapability: rtfeldman$elm_css$Css$Structure$Compatible, inlineAxisOverflow: rtfeldman$elm_css$Css$Structure$Compatible, keyframes: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrNone: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrNoneOrMinMaxDimension: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrNumberOrAutoOrNoneOrContent: rtfeldman$elm_css$Css$Structure$Compatible, listStyleType: rtfeldman$elm_css$Css$Structure$Compatible, listStyleTypeOrPositionOrImage: rtfeldman$elm_css$Css$Structure$Compatible, none: rtfeldman$elm_css$Css$Structure$Compatible, outline: rtfeldman$elm_css$Css$Structure$Compatible, pointerDevice: rtfeldman$elm_css$Css$Structure$Compatible, pointerEvents: rtfeldman$elm_css$Css$Structure$Compatible, resize: rtfeldman$elm_css$Css$Structure$Compatible, scriptingSupport: rtfeldman$elm_css$Css$Structure$Compatible, textDecorationLine: rtfeldman$elm_css$Css$Structure$Compatible, textTransform: rtfeldman$elm_css$Css$Structure$Compatible, touchAction: rtfeldman$elm_css$Css$Structure$Compatible, transform: rtfeldman$elm_css$Css$Structure$Compatible, updateFrequency: rtfeldman$elm_css$Css$Structure$Compatible, value: 'none'};
var rtfeldman$elm_css$Css$outline = rtfeldman$elm_css$Css$prop1('outline');
var author$project$Style$noOutline = rtfeldman$elm_css$Css$outline(rtfeldman$elm_css$Css$none);
var rtfeldman$elm_css$Css$padding = rtfeldman$elm_css$Css$prop1('padding');
var author$project$Style$padding = A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$padding, author$project$Style$sizePx);
var Chadtech$ct_colors$Chadtech$Colors$background1 = rtfeldman$elm_css$Css$hex('#071D10');
var Chadtech$ct_colors$Chadtech$Colors$content0 = rtfeldman$elm_css$Css$hex('#131610');
var Chadtech$ct_colors$Chadtech$Colors$content2 = rtfeldman$elm_css$Css$hex('#57524F');
var rtfeldman$elm_css$Css$prop3 = F4(
	function (key, argA, argB, argC) {
		return A2(
			rtfeldman$elm_css$Css$property,
			key,
			A2(
				elm$core$String$join,
				' ',
				_List_fromArray(
					[argA.value, argB.value, argC.value])));
	});
var rtfeldman$elm_css$Css$borderBottom3 = rtfeldman$elm_css$Css$prop3('border-bottom');
var rtfeldman$elm_css$Css$solid = {borderStyle: rtfeldman$elm_css$Css$Structure$Compatible, textDecorationStyle: rtfeldman$elm_css$Css$Structure$Compatible, value: 'solid'};
var author$project$Style$borderBottom = A2(
	rtfeldman$elm_css$Css$borderBottom3,
	author$project$Style$sizePx(1),
	rtfeldman$elm_css$Css$solid);
var rtfeldman$elm_css$Css$borderLeft3 = rtfeldman$elm_css$Css$prop3('border-left');
var rtfeldman$elm_css$Css$borderRight3 = rtfeldman$elm_css$Css$prop3('border-right');
var rtfeldman$elm_css$Css$borderTop3 = rtfeldman$elm_css$Css$prop3('border-top');
var author$project$Style$indent = rtfeldman$elm_css$Css$batch(
	_List_fromArray(
		[
			A3(
			rtfeldman$elm_css$Css$borderTop3,
			author$project$Style$sizePx(1),
			rtfeldman$elm_css$Css$solid,
			Chadtech$ct_colors$Chadtech$Colors$content0),
			A3(
			rtfeldman$elm_css$Css$borderLeft3,
			author$project$Style$sizePx(1),
			rtfeldman$elm_css$Css$solid,
			Chadtech$ct_colors$Chadtech$Colors$content0),
			A3(
			rtfeldman$elm_css$Css$borderRight3,
			author$project$Style$sizePx(1),
			rtfeldman$elm_css$Css$solid,
			Chadtech$ct_colors$Chadtech$Colors$content2),
			author$project$Style$borderBottom(Chadtech$ct_colors$Chadtech$Colors$content2)
		]));
var rtfeldman$elm_css$Css$backgroundColor = function (c) {
	return A2(rtfeldman$elm_css$Css$property, 'background-color', c.value);
};
var author$project$Style$pit = rtfeldman$elm_css$Css$batch(
	_List_fromArray(
		[
			author$project$Style$indent,
			rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$background1)
		]));
var author$project$Util$Css$noStyle = rtfeldman$elm_css$Css$batch(_List_Nil);
var author$project$Util$Css$styleMaybe = function (f) {
	return A2(
		elm$core$Basics$composeR,
		elm$core$Maybe$map(f),
		elm$core$Maybe$withDefault(author$project$Util$Css$noStyle));
};
var author$project$View$TextArea$optionsToSummary = function () {
	var modifySummary = F2(
		function (option, summary) {
			if (option.$ === 'OnInput') {
				var msg = option.a;
				return _Utils_update(
					summary,
					{
						onInput: elm$core$Maybe$Just(msg)
					});
			} else {
				var _int = option.a;
				return _Utils_update(
					summary,
					{
						fixedHeight: elm$core$Maybe$Just(_int)
					});
			}
		});
	return A2(
		elm$core$List$foldr,
		modifySummary,
		{fixedHeight: elm$core$Maybe$Nothing, onInput: elm$core$Maybe$Nothing});
}();
var rtfeldman$elm_css$Css$color = function (c) {
	return A2(rtfeldman$elm_css$Css$property, 'color', c.value);
};
var rtfeldman$elm_css$Html$Styled$textarea = rtfeldman$elm_css$Html$Styled$node('textarea');
var rtfeldman$elm_css$VirtualDom$Styled$property = F2(
	function (key, value) {
		return A3(
			rtfeldman$elm_css$VirtualDom$Styled$Attribute,
			A2(elm$virtual_dom$VirtualDom$property, key, value),
			_List_Nil,
			'');
	});
var rtfeldman$elm_css$Html$Styled$Attributes$boolProperty = F2(
	function (key, bool) {
		return A2(
			rtfeldman$elm_css$VirtualDom$Styled$property,
			key,
			elm$json$Json$Encode$bool(bool));
	});
var rtfeldman$elm_css$Html$Styled$Attributes$spellcheck = rtfeldman$elm_css$Html$Styled$Attributes$boolProperty('spellcheck');
var rtfeldman$elm_css$Html$Styled$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			rtfeldman$elm_css$VirtualDom$Styled$property,
			key,
			elm$json$Json$Encode$string(string));
	});
var rtfeldman$elm_css$Html$Styled$Attributes$value = rtfeldman$elm_css$Html$Styled$Attributes$stringProperty('value');
var rtfeldman$elm_css$Html$Styled$Events$alwaysStop = function (x) {
	return _Utils_Tuple2(x, true);
};
var elm$virtual_dom$VirtualDom$MayStopPropagation = function (a) {
	return {$: 'MayStopPropagation', a: a};
};
var elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var rtfeldman$elm_css$VirtualDom$Styled$on = F2(
	function (eventName, handler) {
		return A3(
			rtfeldman$elm_css$VirtualDom$Styled$Attribute,
			A2(elm$virtual_dom$VirtualDom$on, eventName, handler),
			_List_Nil,
			'');
	});
var rtfeldman$elm_css$Html$Styled$Events$stopPropagationOn = F2(
	function (event, decoder) {
		return A2(
			rtfeldman$elm_css$VirtualDom$Styled$on,
			event,
			elm$virtual_dom$VirtualDom$MayStopPropagation(decoder));
	});
var elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3(elm$core$List$foldr, elm$json$Json$Decode$field, decoder, fields);
	});
var rtfeldman$elm_css$Html$Styled$Events$targetValue = A2(
	elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'value']),
	elm$json$Json$Decode$string);
var rtfeldman$elm_css$Html$Styled$Events$onInput = function (tagger) {
	return A2(
		rtfeldman$elm_css$Html$Styled$Events$stopPropagationOn,
		'input',
		A2(
			elm$json$Json$Decode$map,
			rtfeldman$elm_css$Html$Styled$Events$alwaysStop,
			A2(elm$json$Json$Decode$map, tagger, rtfeldman$elm_css$Html$Styled$Events$targetValue)));
};
var author$project$View$TextArea$toHtml = function (_n0) {
	var value = _n0.a.value;
	var options = _n0.b;
	var summary = author$project$View$TextArea$optionsToSummary(options);
	var conditionalAttributes = A2(
		elm$core$List$filterMap,
		elm$core$Basics$identity,
		_List_fromArray(
			[
				A2(elm$core$Maybe$map, rtfeldman$elm_css$Html$Styled$Events$onInput, summary.onInput)
			]));
	var attributes = _List_fromArray(
		[
			rtfeldman$elm_css$Html$Styled$Attributes$css(
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$color(Chadtech$ct_colors$Chadtech$Colors$content4),
					author$project$Style$fontSmoothingNone,
					author$project$Style$fullWidth,
					author$project$Style$font,
					author$project$Style$padding(2),
					author$project$Style$noOutline,
					author$project$Style$pit,
					A2(author$project$Util$Css$styleMaybe, author$project$Style$height, summary.fixedHeight)
				])),
			rtfeldman$elm_css$Html$Styled$Attributes$spellcheck(false),
			rtfeldman$elm_css$Html$Styled$Attributes$value(value)
		]);
	return A2(
		rtfeldman$elm_css$Html$Styled$textarea,
		_Utils_ap(attributes, conditionalAttributes),
		_List_Nil);
};
var author$project$View$TextArea$Height = function (a) {
	return {$: 'Height', a: a};
};
var author$project$View$TextArea$addOption = F2(
	function (option, _n0) {
		var model = _n0.a;
		var options = _n0.b;
		return A2(
			author$project$View$TextArea$TextArea,
			model,
			A2(elm$core$List$cons, option, options));
	});
var author$project$View$TextArea$withHeight = A2(elm$core$Basics$composeL, author$project$View$TextArea$addOption, author$project$View$TextArea$Height);
var author$project$View$Card$errorDisplay = function (error) {
	return A2(
		Chadtech$elm_css_grid$Html$Grid$row,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				Chadtech$elm_css_grid$Html$Grid$column,
				_List_Nil,
				_List_fromArray(
					[
						author$project$View$TextArea$toHtml(
						A2(
							author$project$View$TextArea$withHeight,
							8,
							author$project$View$TextArea$readOnly(error)))
					]))
			]));
};
var rtfeldman$elm_css$Html$Styled$p = rtfeldman$elm_css$Html$Styled$node('p');
var rtfeldman$elm_css$VirtualDom$Styled$Unstyled = function (a) {
	return {$: 'Unstyled', a: a};
};
var rtfeldman$elm_css$VirtualDom$Styled$text = function (str) {
	return rtfeldman$elm_css$VirtualDom$Styled$Unstyled(
		elm$virtual_dom$VirtualDom$text(str));
};
var rtfeldman$elm_css$Html$Styled$text = rtfeldman$elm_css$VirtualDom$Styled$text;
var author$project$View$Text$config = function (_n0) {
	var styles = _n0.styles;
	var value = _n0.value;
	return A2(
		rtfeldman$elm_css$Html$Styled$p,
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$Attributes$css(styles)
			]),
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$text(value)
			]));
};
var author$project$View$Text$withStyles = F2(
	function (styles, str) {
		return author$project$View$Text$config(
			{styles: styles, value: str});
	});
var author$project$View$Text$fromString = author$project$View$Text$withStyles(_List_Nil);
var author$project$View$Card$textRow = F2(
	function (styles, text) {
		return A2(
			Chadtech$elm_css_grid$Html$Grid$row,
			styles,
			_List_fromArray(
				[
					A2(
					Chadtech$elm_css_grid$Html$Grid$column,
					_List_fromArray(
						[
							author$project$Style$padding(1)
						]),
					_List_fromArray(
						[
							author$project$View$Text$fromString(text)
						]))
				]));
	});
var Chadtech$elm_css_grid$Html$Grid$box = function (styles) {
	return A2(
		rtfeldman$elm_css$Html$Styled$node,
		'box',
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$Attributes$css(styles)
			]));
};
var Chadtech$ct_colors$Chadtech$Colors$content1 = rtfeldman$elm_css$Css$hex('#2C2826');
var author$project$Style$outdent = rtfeldman$elm_css$Css$batch(
	_List_fromArray(
		[
			A3(
			rtfeldman$elm_css$Css$borderTop3,
			author$project$Style$sizePx(1),
			rtfeldman$elm_css$Css$solid,
			Chadtech$ct_colors$Chadtech$Colors$content2),
			A3(
			rtfeldman$elm_css$Css$borderLeft3,
			author$project$Style$sizePx(1),
			rtfeldman$elm_css$Css$solid,
			Chadtech$ct_colors$Chadtech$Colors$content2),
			A3(
			rtfeldman$elm_css$Css$borderRight3,
			author$project$Style$sizePx(1),
			rtfeldman$elm_css$Css$solid,
			Chadtech$ct_colors$Chadtech$Colors$content0),
			author$project$Style$borderBottom(Chadtech$ct_colors$Chadtech$Colors$content0)
		]));
var rtfeldman$elm_css$Css$Preprocess$WithKeyframes = function (a) {
	return {$: 'WithKeyframes', a: a};
};
var rtfeldman$elm_css$Css$animationName = function (arg) {
	return ((arg.value === 'none') || ((arg.value === 'inherit') || ((arg.value === 'unset') || (arg.value === 'initial')))) ? A2(rtfeldman$elm_css$Css$prop1, 'animation-name', arg) : rtfeldman$elm_css$Css$Preprocess$WithKeyframes(arg.value);
};
var rtfeldman$elm_css$Css$cssFunction = F2(
	function (funcName, args) {
		return funcName + ('(' + (A2(elm$core$String$join, ', ', args) + ')'));
	});
var rtfeldman$elm_css$Css$scale = function (x) {
	return {
		transform: rtfeldman$elm_css$Css$Structure$Compatible,
		value: A2(
			rtfeldman$elm_css$Css$cssFunction,
			'scale',
			_List_fromArray(
				[
					elm$core$String$fromFloat(x)
				]))
	};
};
var rtfeldman$elm_css$Css$Internal$printKeyframeSelector = function (_n0) {
	var percentage = _n0.a;
	var properties = _n0.b;
	var propertiesStr = A2(
		elm$core$String$join,
		'',
		A2(
			elm$core$List$map,
			function (_n1) {
				var prop = _n1.a;
				return prop + ';';
			},
			properties));
	var percentageStr = elm$core$String$fromInt(percentage) + '%';
	return percentageStr + (' {' + (propertiesStr + '}'));
};
var rtfeldman$elm_css$Css$Internal$compileKeyframes = function (tuples) {
	return A2(
		elm$core$String$join,
		'\n\n',
		A2(elm$core$List$map, rtfeldman$elm_css$Css$Internal$printKeyframeSelector, tuples));
};
var rtfeldman$elm_css$Css$Animations$keyframes = function (tuples) {
	return elm$core$List$isEmpty(tuples) ? {keyframes: rtfeldman$elm_css$Css$Structure$Compatible, none: rtfeldman$elm_css$Css$Structure$Compatible, value: 'none'} : {
		keyframes: rtfeldman$elm_css$Css$Structure$Compatible,
		none: rtfeldman$elm_css$Css$Structure$Compatible,
		value: rtfeldman$elm_css$Css$Internal$compileKeyframes(tuples)
	};
};
var rtfeldman$elm_css$Css$Internal$Property = function (a) {
	return {$: 'Property', a: a};
};
var rtfeldman$elm_css$Css$Animations$transform = function (values) {
	return rtfeldman$elm_css$Css$Internal$Property(
		elm$core$List$isEmpty(values) ? 'transform:none' : ('transform:' + A2(
			elm$core$String$join,
			' ',
			A2(
				elm$core$List$map,
				function ($) {
					return $.value;
				},
				values))));
};
var author$project$View$Card$cardStyles = rtfeldman$elm_css$Css$batch(
	_List_fromArray(
		[
			author$project$Style$outdent,
			rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$content1),
			author$project$Style$padding(1),
			A2(rtfeldman$elm_css$Css$property, 'animation-duration', '150ms'),
			rtfeldman$elm_css$Css$animationName(
			rtfeldman$elm_css$Css$Animations$keyframes(
				_List_fromArray(
					[
						_Utils_Tuple2(
						0,
						_List_fromArray(
							[
								rtfeldman$elm_css$Css$Animations$transform(
								_List_fromArray(
									[
										rtfeldman$elm_css$Css$scale(0)
									]))
							])),
						_Utils_Tuple2(
						100,
						_List_fromArray(
							[
								rtfeldman$elm_css$Css$Animations$transform(
								_List_fromArray(
									[
										rtfeldman$elm_css$Css$scale(1)
									]))
							]))
					])))
		]));
var author$project$View$Card$view = function (styles) {
	return Chadtech$elm_css_grid$Html$Grid$box(
		A2(elm$core$List$cons, author$project$View$Card$cardStyles, styles));
};
var author$project$View$CardHeader$CardHeader = F2(
	function (a, b) {
		return {$: 'CardHeader', a: a, b: b};
	});
var author$project$View$CardHeader$config = function (model) {
	return A2(author$project$View$CardHeader$CardHeader, model, _List_Nil);
};
var rtfeldman$elm_css$Css$marginBottom = rtfeldman$elm_css$Css$prop1('margin-bottom');
var author$project$Style$marginBottom = A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$marginBottom, author$project$Style$sizePx);
var author$project$View$CardHeader$optionsToSummary = function () {
	var modifySummary = F2(
		function (option, summary) {
			var msg = option.a;
			return _Utils_update(
				summary,
				{
					closeButton: elm$core$Maybe$Just(msg)
				});
		});
	return A2(
		elm$core$List$foldr,
		modifySummary,
		{closeButton: elm$core$Maybe$Nothing});
}();
var author$project$View$CardHeader$toHtml = function (_n0) {
	var model = _n0.a;
	var options = _n0.b;
	var summary = author$project$View$CardHeader$optionsToSummary(options);
	return A2(
		Chadtech$elm_css_grid$Html$Grid$row,
		_List_fromArray(
			[
				rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$content4),
				author$project$Style$marginBottom(2)
			]),
		_List_fromArray(
			[
				A2(
				Chadtech$elm_css_grid$Html$Grid$column,
				_List_fromArray(
					[
						author$project$Style$padding(2)
					]),
				_List_fromArray(
					[
						A2(
						author$project$View$Text$withStyles,
						_List_fromArray(
							[
								rtfeldman$elm_css$Css$color(Chadtech$ct_colors$Chadtech$Colors$content1)
							]),
						model.title)
					]))
			]));
};
var Chadtech$elm_css_grid$Html$Grid$columnShrink = rtfeldman$elm_css$Css$flex(
	rtfeldman$elm_css$Css$int(0));
var rtfeldman$elm_css$Css$center = rtfeldman$elm_css$Css$prop1('center');
var rtfeldman$elm_css$Css$Internal$property = F2(
	function (key, value) {
		return rtfeldman$elm_css$Css$Preprocess$AppendProperty(key + (':' + value));
	});
var rtfeldman$elm_css$Css$Internal$getOverloadedProperty = F3(
	function (functionName, desiredKey, style) {
		getOverloadedProperty:
		while (true) {
			switch (style.$) {
				case 'AppendProperty':
					var str = style.a;
					var key = A2(
						elm$core$Maybe$withDefault,
						'',
						elm$core$List$head(
							A2(elm$core$String$split, ':', str)));
					return A2(rtfeldman$elm_css$Css$Internal$property, desiredKey, key);
				case 'ExtendSelector':
					var selector = style.a;
					return A2(rtfeldman$elm_css$Css$Internal$property, desiredKey, 'elm-css-error-cannot-apply-' + (functionName + '-with-inapplicable-Style-for-selector'));
				case 'NestSnippet':
					var combinator = style.a;
					return A2(rtfeldman$elm_css$Css$Internal$property, desiredKey, 'elm-css-error-cannot-apply-' + (functionName + '-with-inapplicable-Style-for-combinator'));
				case 'WithPseudoElement':
					var pseudoElement = style.a;
					return A2(rtfeldman$elm_css$Css$Internal$property, desiredKey, 'elm-css-error-cannot-apply-' + (functionName + '-with-inapplicable-Style-for-pseudo-element setter'));
				case 'WithMedia':
					return A2(rtfeldman$elm_css$Css$Internal$property, desiredKey, 'elm-css-error-cannot-apply-' + (functionName + '-with-inapplicable-Style-for-media-query'));
				case 'WithKeyframes':
					return A2(rtfeldman$elm_css$Css$Internal$property, desiredKey, 'elm-css-error-cannot-apply-' + (functionName + '-with-inapplicable-Style-for-keyframes'));
				default:
					if (!style.a.b) {
						return A2(rtfeldman$elm_css$Css$Internal$property, desiredKey, 'elm-css-error-cannot-apply-' + (functionName + '-with-empty-Style'));
					} else {
						if (!style.a.b.b) {
							var _n1 = style.a;
							var only = _n1.a;
							var $temp$functionName = functionName,
								$temp$desiredKey = desiredKey,
								$temp$style = only;
							functionName = $temp$functionName;
							desiredKey = $temp$desiredKey;
							style = $temp$style;
							continue getOverloadedProperty;
						} else {
							var _n2 = style.a;
							var first = _n2.a;
							var rest = _n2.b;
							var $temp$functionName = functionName,
								$temp$desiredKey = desiredKey,
								$temp$style = rtfeldman$elm_css$Css$Preprocess$ApplyStyles(rest);
							functionName = $temp$functionName;
							desiredKey = $temp$desiredKey;
							style = $temp$style;
							continue getOverloadedProperty;
						}
					}
			}
		}
	});
var rtfeldman$elm_css$Css$Internal$IncompatibleUnits = {$: 'IncompatibleUnits'};
var rtfeldman$elm_css$Css$Internal$lengthForOverloadedProperty = A3(rtfeldman$elm_css$Css$Internal$lengthConverter, rtfeldman$elm_css$Css$Internal$IncompatibleUnits, '', 0);
var rtfeldman$elm_css$Css$justifyContent = function (fn) {
	return A3(
		rtfeldman$elm_css$Css$Internal$getOverloadedProperty,
		'justifyContent',
		'justify-content',
		fn(rtfeldman$elm_css$Css$Internal$lengthForOverloadedProperty));
};
var author$project$Style$centerContent = rtfeldman$elm_css$Css$justifyContent(rtfeldman$elm_css$Css$center);
var rtfeldman$elm_css$Css$column = _Utils_update(
	rtfeldman$elm_css$Css$row,
	{value: 'column'});
var author$project$View$SingleCardPage$view = function (card) {
	return _List_fromArray(
		[
			A2(
			Chadtech$elm_css_grid$Html$Grid$row,
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$flex(
					rtfeldman$elm_css$Css$int(1)),
					author$project$Style$centerContent
				]),
			_List_fromArray(
				[
					A2(
					Chadtech$elm_css_grid$Html$Grid$column,
					_List_fromArray(
						[
							Chadtech$elm_css_grid$Html$Grid$columnShrink,
							author$project$Style$centerContent,
							rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$column)
						]),
					_List_fromArray(
						[card]))
				]))
		]);
};
var author$project$Main$viewError = function (decodeError) {
	var header = author$project$View$CardHeader$toHtml(
		author$project$View$CardHeader$config(
			{title: 'error'}));
	var errorBody = _List_fromArray(
		[
			A2(author$project$View$Card$textRow, _List_Nil, '\n                Something went really wrong. Sorry.\n                Please report this error if you can.\n                You can copy and paste the error below,\n                and send it to my email at\n                chadtech0@gmail.com\n                '),
			author$project$View$Card$errorDisplay(
			elm$json$Json$Decode$errorToString(decodeError))
		]);
	return {
		body: author$project$View$SingleCardPage$view(
			A2(
				author$project$View$Card$view,
				_List_fromArray(
					[
						author$project$Style$width(10)
					]),
				A2(elm$core$List$cons, header, errorBody))),
		title: elm$core$Maybe$Nothing
	};
};
var elm$virtual_dom$VirtualDom$map = _VirtualDom_map;
var rtfeldman$elm_css$VirtualDom$Styled$KeyedNode = F3(
	function (a, b, c) {
		return {$: 'KeyedNode', a: a, b: b, c: c};
	});
var rtfeldman$elm_css$VirtualDom$Styled$KeyedNodeNS = F4(
	function (a, b, c, d) {
		return {$: 'KeyedNodeNS', a: a, b: b, c: c, d: d};
	});
var rtfeldman$elm_css$VirtualDom$Styled$NodeNS = F4(
	function (a, b, c, d) {
		return {$: 'NodeNS', a: a, b: b, c: c, d: d};
	});
var elm$virtual_dom$VirtualDom$mapAttribute = _VirtualDom_mapAttribute;
var rtfeldman$elm_css$VirtualDom$Styled$mapAttribute = F2(
	function (transform, _n0) {
		var prop = _n0.a;
		var styles = _n0.b;
		var classname = _n0.c;
		return A3(
			rtfeldman$elm_css$VirtualDom$Styled$Attribute,
			A2(elm$virtual_dom$VirtualDom$mapAttribute, transform, prop),
			styles,
			classname);
	});
var rtfeldman$elm_css$VirtualDom$Styled$map = F2(
	function (transform, vdomNode) {
		switch (vdomNode.$) {
			case 'Node':
				var elemType = vdomNode.a;
				var properties = vdomNode.b;
				var children = vdomNode.c;
				return A3(
					rtfeldman$elm_css$VirtualDom$Styled$Node,
					elemType,
					A2(
						elm$core$List$map,
						rtfeldman$elm_css$VirtualDom$Styled$mapAttribute(transform),
						properties),
					A2(
						elm$core$List$map,
						rtfeldman$elm_css$VirtualDom$Styled$map(transform),
						children));
			case 'NodeNS':
				var ns = vdomNode.a;
				var elemType = vdomNode.b;
				var properties = vdomNode.c;
				var children = vdomNode.d;
				return A4(
					rtfeldman$elm_css$VirtualDom$Styled$NodeNS,
					ns,
					elemType,
					A2(
						elm$core$List$map,
						rtfeldman$elm_css$VirtualDom$Styled$mapAttribute(transform),
						properties),
					A2(
						elm$core$List$map,
						rtfeldman$elm_css$VirtualDom$Styled$map(transform),
						children));
			case 'KeyedNode':
				var elemType = vdomNode.a;
				var properties = vdomNode.b;
				var children = vdomNode.c;
				return A3(
					rtfeldman$elm_css$VirtualDom$Styled$KeyedNode,
					elemType,
					A2(
						elm$core$List$map,
						rtfeldman$elm_css$VirtualDom$Styled$mapAttribute(transform),
						properties),
					A2(
						elm$core$List$map,
						function (_n1) {
							var key = _n1.a;
							var child = _n1.b;
							return _Utils_Tuple2(
								key,
								A2(rtfeldman$elm_css$VirtualDom$Styled$map, transform, child));
						},
						children));
			case 'KeyedNodeNS':
				var ns = vdomNode.a;
				var elemType = vdomNode.b;
				var properties = vdomNode.c;
				var children = vdomNode.d;
				return A4(
					rtfeldman$elm_css$VirtualDom$Styled$KeyedNodeNS,
					ns,
					elemType,
					A2(
						elm$core$List$map,
						rtfeldman$elm_css$VirtualDom$Styled$mapAttribute(transform),
						properties),
					A2(
						elm$core$List$map,
						function (_n2) {
							var key = _n2.a;
							var child = _n2.b;
							return _Utils_Tuple2(
								key,
								A2(rtfeldman$elm_css$VirtualDom$Styled$map, transform, child));
						},
						children));
			default:
				var vdom = vdomNode.a;
				return rtfeldman$elm_css$VirtualDom$Styled$Unstyled(
					A2(elm$virtual_dom$VirtualDom$map, transform, vdom));
		}
	});
var rtfeldman$elm_css$Html$Styled$map = rtfeldman$elm_css$VirtualDom$Styled$map;
var author$project$Data$Document$map = F2(
	function (mapper, document) {
		return {
			body: A2(
				elm$core$List$map,
				rtfeldman$elm_css$Html$Styled$map(mapper),
				document.body),
			title: document.title
		};
	});
var author$project$Main$ContactMsg = function (a) {
	return {$: 'ContactMsg', a: a};
};
var rtfeldman$elm_css$Css$marginRight = rtfeldman$elm_css$Css$prop1('margin-right');
var author$project$Style$marginRight = A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$marginRight, author$project$Style$sizePx);
var rtfeldman$elm_css$Css$display = rtfeldman$elm_css$Css$prop1('display');
var rtfeldman$elm_css$Css$inline = {display: rtfeldman$elm_css$Css$Structure$Compatible, value: 'inline'};
var rtfeldman$elm_css$Css$zero = {length: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrAuto: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrAutoOrCoverOrContain: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrMinMaxDimension: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrNone: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrNoneOrMinMaxDimension: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrNumber: rtfeldman$elm_css$Css$Structure$Compatible, number: rtfeldman$elm_css$Css$Structure$Compatible, numericValue: 0, outline: rtfeldman$elm_css$Css$Structure$Compatible, unitLabel: '', units: rtfeldman$elm_css$Css$UnitlessInteger, value: '0'};
var author$project$Style$verticalDivider = rtfeldman$elm_css$Css$batch(
	_List_fromArray(
		[
			A3(
			rtfeldman$elm_css$Css$borderLeft3,
			author$project$Style$sizePx(1),
			rtfeldman$elm_css$Css$solid,
			Chadtech$ct_colors$Chadtech$Colors$content0),
			A3(
			rtfeldman$elm_css$Css$borderRight3,
			author$project$Style$sizePx(1),
			rtfeldman$elm_css$Css$solid,
			Chadtech$ct_colors$Chadtech$Colors$content2),
			rtfeldman$elm_css$Css$width(rtfeldman$elm_css$Css$zero),
			rtfeldman$elm_css$Css$display(rtfeldman$elm_css$Css$inline)
		]));
var author$project$Ui$Nav$NavBarOptionClicked = function (a) {
	return {$: 'NavBarOptionClicked', a: a};
};
var author$project$Ui$Nav$optionIsCurrentPage = F2(
	function (model, option) {
		var _n0 = _Utils_Tuple2(model, option);
		_n0$4:
		while (true) {
			switch (_n0.b.$) {
				case 'Title':
					switch (_n0.a.$) {
						case 'Splash':
							var _n1 = _n0.b;
							return true;
						case 'Home':
							var _n2 = _n0.b;
							return true;
						default:
							break _n0$4;
					}
				case 'About':
					if (_n0.a.$ === 'About') {
						var _n3 = _n0.b;
						return true;
					} else {
						break _n0$4;
					}
				case 'Login':
					if (_n0.a.$ === 'Login') {
						var _n4 = _n0.b;
						return true;
					} else {
						break _n0$4;
					}
				default:
					break _n0$4;
			}
		}
		return false;
	});
var author$project$Ui$Nav$Option$About = {$: 'About'};
var author$project$Ui$Nav$Option$Draw = {$: 'Draw'};
var author$project$Ui$Nav$Option$Login = {$: 'Login'};
var author$project$Ui$Nav$Option$Logout = {$: 'Logout'};
var author$project$Ui$Nav$Option$Settings = {$: 'Settings'};
var author$project$Ui$Nav$Option$Title = {$: 'Title'};
var author$project$View$Button$Button = F2(
	function (a, b) {
		return {$: 'Button', a: a, b: b};
	});
var author$project$View$Button$Label = function (a) {
	return {$: 'Label', a: a};
};
var author$project$View$Button$config = F2(
	function (onClick, label) {
		return A2(
			author$project$View$Button$Button,
			{onClick: onClick},
			_List_fromArray(
				[
					author$project$View$Button$Label(label)
				]));
	});
var author$project$View$Button$Indent = function (a) {
	return {$: 'Indent', a: a};
};
var author$project$View$Button$addOption = F2(
	function (option, _n0) {
		var model = _n0.a;
		var options = _n0.b;
		return A2(
			author$project$View$Button$Button,
			model,
			A2(elm$core$List$cons, option, options));
	});
var author$project$View$Button$indent = A2(elm$core$Basics$composeL, author$project$View$Button$addOption, author$project$View$Button$Indent);
var Chadtech$ct_colors$Chadtech$Colors$content5 = rtfeldman$elm_css$Css$hex('#E0D6CA');
var author$project$View$Button$buttonHeight = function (tall) {
	return tall ? author$project$Style$height(6) : author$project$Style$height(5);
};
var author$project$View$Button$buttonWidth = function (summary) {
	var _n0 = summary.width;
	switch (_n0.$) {
		case 'HalfWidth':
			return author$project$Style$width(6);
		case 'SingleWidth':
			return author$project$Style$width(7);
		case 'DoubleWidth':
			return author$project$Style$width(8);
		default:
			return author$project$Style$fullWidth;
	}
};
var rtfeldman$elm_css$Css$Preprocess$ExtendSelector = F2(
	function (a, b) {
		return {$: 'ExtendSelector', a: a, b: b};
	});
var rtfeldman$elm_css$Css$Structure$PseudoClassSelector = function (a) {
	return {$: 'PseudoClassSelector', a: a};
};
var rtfeldman$elm_css$Css$pseudoClass = function (_class) {
	return rtfeldman$elm_css$Css$Preprocess$ExtendSelector(
		rtfeldman$elm_css$Css$Structure$PseudoClassSelector(_class));
};
var rtfeldman$elm_css$Css$active = rtfeldman$elm_css$Css$pseudoClass('active');
var author$project$View$Button$disabledStyle = function (disabled) {
	return disabled ? rtfeldman$elm_css$Css$batch(
		_List_fromArray(
			[
				rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$content0),
				rtfeldman$elm_css$Css$active(
				_List_fromArray(
					[author$project$Style$outdent]))
			])) : author$project$Util$Css$noStyle;
};
var author$project$View$Button$indentStyle = function (maybeIndent) {
	if (maybeIndent.$ === 'Nothing') {
		return author$project$Style$outdent;
	} else {
		if (maybeIndent.a) {
			return author$project$Style$indent;
		} else {
			return author$project$Style$outdent;
		}
	}
};
var author$project$View$Button$SingleWidth = {$: 'SingleWidth'};
var author$project$View$Button$optionsToSummary = function () {
	var modifySummary = F2(
		function (option, summary) {
			switch (option.$) {
				case 'Width':
					var width = option.a;
					return _Utils_update(
						summary,
						{width: width});
				case 'Indent':
					var indent_ = option.a;
					return _Utils_update(
						summary,
						{
							indent: elm$core$Maybe$Just(indent_)
						});
				case 'Disabled':
					var disabled = option.a;
					return _Utils_update(
						summary,
						{disabled: disabled});
				case 'Tall':
					var tall = option.a;
					return _Utils_update(
						summary,
						{tall: tall});
				case 'Label':
					var label = option.a;
					return _Utils_update(
						summary,
						{
							label: elm$core$Maybe$Just(label)
						});
				default:
					var color = option.a;
					return _Utils_update(
						summary,
						{
							backgroundColor: elm$core$Maybe$Just(color)
						});
			}
		});
	return A2(
		elm$core$List$foldr,
		modifySummary,
		{backgroundColor: elm$core$Maybe$Nothing, disabled: false, indent: elm$core$Maybe$Nothing, label: elm$core$Maybe$Nothing, tall: false, width: author$project$View$Button$SingleWidth});
}();
var rtfeldman$elm_css$Css$hover = rtfeldman$elm_css$Css$pseudoClass('hover');
var rtfeldman$elm_css$Html$Styled$button = rtfeldman$elm_css$Html$Styled$node('button');
var elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 'Normal', a: a};
};
var rtfeldman$elm_css$Html$Styled$Events$on = F2(
	function (event, decoder) {
		return A2(
			rtfeldman$elm_css$VirtualDom$Styled$on,
			event,
			elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var rtfeldman$elm_css$Html$Styled$Events$onClick = function (msg) {
	return A2(
		rtfeldman$elm_css$Html$Styled$Events$on,
		'click',
		elm$json$Json$Decode$succeed(msg));
};
var author$project$View$Button$toHtml = function (_n0) {
	var onClick = _n0.a.onClick;
	var options = _n0.b;
	var summary = author$project$View$Button$optionsToSummary(options);
	return A2(
		rtfeldman$elm_css$Html$Styled$button,
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$Attributes$css(
				_List_fromArray(
					[
						author$project$View$Button$indentStyle(summary.indent),
						author$project$View$Button$buttonHeight(summary.tall),
						rtfeldman$elm_css$Css$backgroundColor(
						A2(elm$core$Maybe$withDefault, Chadtech$ct_colors$Chadtech$Colors$content1, summary.backgroundColor)),
						rtfeldman$elm_css$Css$color(Chadtech$ct_colors$Chadtech$Colors$content4),
						rtfeldman$elm_css$Css$active(
						_List_fromArray(
							[author$project$Style$indent])),
						rtfeldman$elm_css$Css$hover(
						_List_fromArray(
							[
								rtfeldman$elm_css$Css$color(Chadtech$ct_colors$Chadtech$Colors$content5)
							])),
						author$project$View$Button$buttonWidth(summary),
						author$project$View$Button$disabledStyle(summary.disabled)
					])),
				rtfeldman$elm_css$Html$Styled$Events$onClick(onClick)
			]),
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$text(
				A2(elm$core$Maybe$withDefault, '', summary.label))
			]));
};
var author$project$Ui$Nav$view = function (model) {
	var optionView = F2(
		function (extraStyles, option) {
			return A2(
				Chadtech$elm_css_grid$Html$Grid$column,
				_List_fromArray(
					[
						Chadtech$elm_css_grid$Html$Grid$columnShrink,
						author$project$Style$marginRight(2),
						rtfeldman$elm_css$Css$batch(extraStyles)
					]),
				_List_fromArray(
					[
						author$project$View$Button$toHtml(
						A2(
							author$project$View$Button$indent,
							A2(author$project$Ui$Nav$optionIsCurrentPage, model, option),
							A2(
								author$project$View$Button$config,
								author$project$Ui$Nav$NavBarOptionClicked(option),
								author$project$Ui$Nav$Option$toLabel(option))))
					]));
		});
	var userOptions = function () {
		var _n0 = author$project$Model$getUser(model);
		if (_n0.$ === 'User') {
			return _List_fromArray(
				[
					A2(optionView, _List_Nil, author$project$Ui$Nav$Option$Login)
				]);
		} else {
			return _List_fromArray(
				[
					A2(optionView, _List_Nil, author$project$Ui$Nav$Option$Logout),
					A2(optionView, _List_Nil, author$project$Ui$Nav$Option$Settings)
				]);
		}
	}();
	return A2(
		Chadtech$elm_css_grid$Html$Grid$row,
		_List_fromArray(
			[
				author$project$Style$fullWidth,
				rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$content1),
				author$project$Style$padding(2),
				author$project$Style$borderBottom(Chadtech$ct_colors$Chadtech$Colors$content0)
			]),
		_Utils_ap(
			_List_fromArray(
				[
					A2(
					optionView,
					_List_fromArray(
						[
							author$project$Style$marginRight(3)
						]),
					author$project$Ui$Nav$Option$Draw),
					A2(
					Chadtech$elm_css_grid$Html$Grid$column,
					_List_fromArray(
						[
							author$project$Style$verticalDivider,
							Chadtech$elm_css_grid$Html$Grid$columnShrink,
							author$project$Style$marginRight(3),
							author$project$Style$height(5)
						]),
					_List_Nil),
					A2(optionView, _List_Nil, author$project$Ui$Nav$Option$Title),
					A2(optionView, _List_Nil, author$project$Ui$Nav$Option$About),
					A2(Chadtech$elm_css_grid$Html$Grid$column, _List_Nil, _List_Nil)
				]),
			userOptions));
};
var author$project$Main$viewInFrame = F2(
	function (model, _n0) {
		var title = _n0.title;
		var body = _n0.body;
		return {
			body: A2(
				elm$core$List$cons,
				A2(
					rtfeldman$elm_css$Html$Styled$map,
					author$project$Main$NavMsg,
					author$project$Ui$Nav$view(model)),
				body),
			title: title
		};
	});
var author$project$Page$About$intro = '\n    CtPaint is good paint software that runs in your web browser.\n    Its broadly suited for drawing pixel art, drawing memes, or just\n    making a quick practical drawings like diagrams or maps. Its also\n    embedded in the internet, so its super easy to edit any image\n    already on the internet, or share your drawings via a url.\n    ';
var author$project$Page$About$personal = '\n    It was made by one guy named "Chadtech" over the course of two years\n    in his free time.\n    ';
var author$project$Page$About$tech = '\n    It was made with the following technology: Elm, Elm-Css, Elm-Canvas,\n    Browserify, Amazon Web Services, and Gulp.\n    ';
var author$project$Page$About$thanks = '\n    Ive worked on this project for a long time, and so I have worked with\n    a lot of different people during the course of this project. In chronological\n    order, here are my thank yous. Thanks to Funkytek who caused me to get into\n    JavaScript whereafter I began working on CtPaint. Thanks to Jack Hou, a contributor\n    to Chromium, who added \'image rendering : pixelated\' to Google Chromium,\n    a development I followed closely and has been essential to the technology\n    behind CtPaint. Thanks to the meet ups NodeAZ, VegasJS, QueensJS, and\n    Elm Berlin for letting me talk about CtPaint. Thanks to my friend Jacob\n    Rosenthal who was always there to talk to me about code, and initially proposed\n    the idea of doing a kickstarter. Thanks to Ethan Hartman, Taylor Alexander, and\n    Alex Rees, all of whom were marketers who had great feedback about kickstarter campaigns.\n    Thanks to Patrick Gram, Bob Laudner, and David Urbanic, who  did a really good job\n    helping me put together my kickstarter video. Thanks to everyone who contributed to\n    the original kick starter even tho it wasnt successful. Thanks Sascha Naderer,\n    Andreas Kullenberg, Jun, Bo, and Erik \'Kasumi\' from the pixelation community,\n    for either their thorough and knowledgeable opinions on pixel art software, as\n    well as their time using the CtPaint alpha to provide feedback, or the pixel art\n    they have contributed to this project.\n    ';
var author$project$Page$About$textRows = function (buildNumber) {
	var paragraphView = function (str) {
		return A2(
			Chadtech$elm_css_grid$Html$Grid$row,
			_List_fromArray(
				[
					author$project$Style$marginBottom(4)
				]),
			_List_fromArray(
				[
					A2(
					Chadtech$elm_css_grid$Html$Grid$column,
					_List_Nil,
					_List_fromArray(
						[
							author$project$View$Text$fromString(str)
						]))
				]));
	};
	return A2(
		elm$core$List$map,
		paragraphView,
		_List_fromArray(
			[
				author$project$Page$About$intro,
				author$project$Page$About$personal,
				author$project$Page$About$tech,
				author$project$Page$About$thanks,
				A2(
				elm$core$String$join,
				' ',
				_List_fromArray(
					[
						'This is build number',
						author$project$Data$BuildNumber$toString(buildNumber),
						'of this software'
					]))
			]));
};
var rtfeldman$elm_css$Css$marginTop = rtfeldman$elm_css$Css$prop1('margin-top');
var author$project$Style$marginTop = A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$marginTop, author$project$Style$sizePx);
var author$project$Style$marginVertical = function (size) {
	return rtfeldman$elm_css$Css$batch(
		_List_fromArray(
			[
				author$project$Style$marginTop(size),
				author$project$Style$marginBottom(size)
			]));
};
var author$project$View$Image$Image = F2(
	function (a, b) {
		return {$: 'Image', a: a, b: b};
	});
var author$project$View$Image$config = function (src) {
	return A2(author$project$View$Image$Image, src, _List_Nil);
};
var author$project$View$Image$Asset = F2(
	function (a, b) {
		return {$: 'Asset', a: a, b: b};
	});
var author$project$View$Image$Logo = {$: 'Logo'};
var author$project$View$Image$logo = author$project$View$Image$Asset(author$project$View$Image$Logo);
var author$project$Style$exactWidth = function (flWidth) {
	return rtfeldman$elm_css$Css$width(
		rtfeldman$elm_css$Css$px(flWidth));
};
var author$project$View$Image$optionsToSummary = function () {
	var modifySummary = F2(
		function (option, summary) {
			if (option.$ === 'Width') {
				var width = option.a;
				return _Utils_update(
					summary,
					{
						width: elm$core$Maybe$Just(width)
					});
			} else {
				var list = option.a;
				return _Utils_update(
					summary,
					{
						extraStyles: _Utils_ap(list, summary.extraStyles)
					});
			}
		});
	return A2(
		elm$core$List$foldr,
		modifySummary,
		{extraStyles: _List_Nil, width: elm$core$Maybe$Nothing});
}();
var author$project$Data$Drawing$getPublicId = function ($) {
	return $.publicId;
};
var author$project$Data$MountPath$path = F2(
	function (_n0, extra) {
		var mountpath = _n0.a;
		return A2(
			elm$core$String$join,
			'/',
			A2(elm$core$List$cons, mountpath, extra));
	});
var author$project$View$Image$sourceToString = function (source) {
	switch (source.$) {
		case 'Asset':
			var assetSource = source.a;
			var mountPath = source.b;
			var mount = function (path) {
				return A2(
					author$project$Data$MountPath$path,
					mountPath,
					_List_fromArray(
						[path]));
			};
			return mount('splash-image.png');
		case 'ThirdParty':
			var url = source.a;
			return url;
		default:
			var drawing_ = source.a;
			return author$project$Data$Drawing$toUrl(
				author$project$Data$Drawing$getPublicId(drawing_));
	}
};
var rtfeldman$elm_css$Css$auto = {alignItemsOrAuto: rtfeldman$elm_css$Css$Structure$Compatible, cursor: rtfeldman$elm_css$Css$Structure$Compatible, flexBasis: rtfeldman$elm_css$Css$Structure$Compatible, intOrAuto: rtfeldman$elm_css$Css$Structure$Compatible, justifyContentOrAuto: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrAuto: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrAutoOrCoverOrContain: rtfeldman$elm_css$Css$Structure$Compatible, lengthOrNumberOrAutoOrNoneOrContent: rtfeldman$elm_css$Css$Structure$Compatible, overflow: rtfeldman$elm_css$Css$Structure$Compatible, pointerEvents: rtfeldman$elm_css$Css$Structure$Compatible, tableLayout: rtfeldman$elm_css$Css$Structure$Compatible, textRendering: rtfeldman$elm_css$Css$Structure$Compatible, touchAction: rtfeldman$elm_css$Css$Structure$Compatible, value: 'auto'};
var rtfeldman$elm_css$Css$margin = rtfeldman$elm_css$Css$prop1('margin');
var rtfeldman$elm_css$Html$Styled$img = rtfeldman$elm_css$Html$Styled$node('img');
var rtfeldman$elm_css$Html$Styled$Attributes$src = function (url) {
	return A2(rtfeldman$elm_css$Html$Styled$Attributes$stringProperty, 'src', url);
};
var author$project$View$Image$toHtml = function (_n0) {
	var src = _n0.a;
	var options = _n0.b;
	var summary = author$project$View$Image$optionsToSummary(options);
	return A2(
		rtfeldman$elm_css$Html$Styled$img,
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$Attributes$src(
				author$project$View$Image$sourceToString(src)),
				rtfeldman$elm_css$Html$Styled$Attributes$css(
				_List_fromArray(
					[
						A2(author$project$Util$Css$styleMaybe, author$project$Style$exactWidth, summary.width),
						rtfeldman$elm_css$Css$margin(rtfeldman$elm_css$Css$auto),
						rtfeldman$elm_css$Css$batch(summary.extraStyles)
					]))
			]),
		_List_Nil);
};
var author$project$View$Image$Width = function (a) {
	return {$: 'Width', a: a};
};
var author$project$View$Image$addOption = F2(
	function (option, _n0) {
		var params = _n0.a;
		var options = _n0.b;
		return A2(
			author$project$View$Image$Image,
			params,
			A2(elm$core$List$cons, option, options));
	});
var author$project$View$Image$withWidth = function (width) {
	return author$project$View$Image$addOption(
		author$project$View$Image$Width(width));
};
var author$project$View$BannerLogo$view = function (mountPath) {
	return A2(
		Chadtech$elm_css_grid$Html$Grid$row,
		_List_fromArray(
			[
				author$project$Style$pit,
				author$project$Style$marginVertical(3)
			]),
		_List_fromArray(
			[
				A2(
				Chadtech$elm_css_grid$Html$Grid$column,
				_List_Nil,
				_List_fromArray(
					[
						author$project$View$Image$toHtml(
						A2(
							author$project$View$Image$withWidth,
							429,
							author$project$View$Image$config(
								author$project$View$Image$logo(mountPath))))
					]))
			]));
};
var author$project$View$Body$view = function (children) {
	return _List_fromArray(
		[
			A2(
			Chadtech$elm_css_grid$Html$Grid$row,
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$content1),
					author$project$Style$fullWidth,
					rtfeldman$elm_css$Css$flex(
					rtfeldman$elm_css$Css$int(1)),
					author$project$Style$centerContent
				]),
			children)
		]);
};
var author$project$View$Body$singleColumnView = function (children) {
	return author$project$View$Body$view(
		_List_fromArray(
			[
				A2(
				Chadtech$elm_css_grid$Html$Grid$column,
				_List_fromArray(
					[
						author$project$Style$width(10),
						rtfeldman$elm_css$Css$flex(rtfeldman$elm_css$Css$none),
						rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$column)
					]),
				children)
			]));
};
var author$project$Page$About$view = F2(
	function (buildNumber, mountPath) {
		return {
			body: author$project$View$Body$singleColumnView(
				A2(
					elm$core$List$cons,
					author$project$View$BannerLogo$view(mountPath),
					author$project$Page$About$textRows(buildNumber))),
			title: elm$core$Maybe$Just('about')
		};
	});
var author$project$Page$Contact$view = function (model) {
	return {
		body: _List_Nil,
		title: elm$core$Maybe$Just('contact')
	};
};
var author$project$Page$Home$MakeADrawingClicked = {$: 'MakeADrawingClicked'};
var author$project$Page$Home$NewDrawingClicked = {$: 'NewDrawingClicked'};
var author$project$Page$Home$RefreshClicked = {$: 'RefreshClicked'};
var rtfeldman$elm_css$Css$hidden = {borderStyle: rtfeldman$elm_css$Css$Structure$Compatible, overflow: rtfeldman$elm_css$Css$Structure$Compatible, value: 'hidden', visibility: rtfeldman$elm_css$Css$Structure$Compatible};
var rtfeldman$elm_css$Css$overflow = rtfeldman$elm_css$Css$prop1('overflow');
var author$project$Style$noOverflow = rtfeldman$elm_css$Css$overflow(rtfeldman$elm_css$Css$hidden);
var rtfeldman$elm_css$Css$paddingBottom = rtfeldman$elm_css$Css$prop1('padding-bottom');
var author$project$Style$paddingBottom = A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$paddingBottom, author$project$Style$sizePx);
var author$project$View$Button$DoubleWidth = {$: 'DoubleWidth'};
var author$project$View$Button$Width = function (a) {
	return {$: 'Width', a: a};
};
var author$project$View$Button$withWidth = A2(elm$core$Basics$composeL, author$project$View$Button$addOption, author$project$View$Button$Width);
var author$project$View$Button$asDoubleWidth = author$project$View$Button$withWidth(author$project$View$Button$DoubleWidth);
var author$project$View$ButtonRow$buttonColumn = function (button) {
	return A2(
		Chadtech$elm_css_grid$Html$Grid$column,
		_List_fromArray(
			[Chadtech$elm_css_grid$Html$Grid$columnShrink]),
		_List_fromArray(
			[
				author$project$View$Button$toHtml(button)
			]));
};
var author$project$View$ButtonRow$view = function (buttons) {
	return A2(
		Chadtech$elm_css_grid$Html$Grid$row,
		_List_fromArray(
			[author$project$Style$centerContent]),
		A2(elm$core$List$map, author$project$View$ButtonRow$buttonColumn, buttons));
};
var author$project$View$Image$Drawing = function (a) {
	return {$: 'Drawing', a: a};
};
var author$project$View$Image$drawing = author$project$View$Image$Drawing;
var author$project$View$Image$Styles = function (a) {
	return {$: 'Styles', a: a};
};
var author$project$View$Image$withStyles = A2(elm$core$Basics$composeL, author$project$View$Image$addOption, author$project$View$Image$Styles);
var author$project$Page$Home$drawingsView = function (drawings) {
	if (elm$core$List$isEmpty(drawings)) {
		return author$project$View$SingleCardPage$view(
			A2(
				author$project$View$Card$view,
				_List_Nil,
				_List_fromArray(
					[
						A2(author$project$View$Card$textRow, _List_Nil, 'you have no drawings'),
						author$project$View$ButtonRow$view(
						_List_fromArray(
							[
								A2(author$project$View$Button$config, author$project$Page$Home$RefreshClicked, 'reload drawings'),
								A2(author$project$View$Button$config, author$project$Page$Home$MakeADrawingClicked, 'make a drawing')
							]))
					])));
	} else {
		var drawingView = function (_n0) {
			var id = _n0.a;
			var drawing = _n0.b;
			return A2(
				Chadtech$elm_css_grid$Html$Grid$column,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						author$project$View$Card$view,
						_List_fromArray(
							[
								author$project$Style$width(8),
								author$project$Style$height(8),
								rtfeldman$elm_css$Css$displayFlex,
								rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$column)
							]),
						_List_fromArray(
							[
								author$project$View$CardHeader$toHtml(
								author$project$View$CardHeader$config(
									{title: drawing.name})),
								A2(
								Chadtech$elm_css_grid$Html$Grid$row,
								_List_fromArray(
									[
										author$project$Style$fullWidth,
										author$project$Style$pit,
										rtfeldman$elm_css$Css$flex(
										rtfeldman$elm_css$Css$int(1)),
										author$project$Style$noOverflow
									]),
								_List_fromArray(
									[
										A2(
										Chadtech$elm_css_grid$Html$Grid$column,
										_List_fromArray(
											[
												author$project$Style$fullWidth,
												rtfeldman$elm_css$Css$displayFlex,
												author$project$Style$centerContent,
												rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$column)
											]),
										_List_fromArray(
											[
												author$project$View$Image$toHtml(
												A2(
													author$project$View$Image$withStyles,
													_List_fromArray(
														[author$project$Style$fullWidth]),
													author$project$View$Image$config(
														author$project$View$Image$drawing(drawing))))
											]))
									]))
							]))
					]));
		};
		return author$project$View$Body$view(
			_List_fromArray(
				[
					A2(
					Chadtech$elm_css_grid$Html$Grid$column,
					_List_fromArray(
						[
							author$project$Style$padding(2),
							rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$column)
						]),
					_List_fromArray(
						[
							A2(
							Chadtech$elm_css_grid$Html$Grid$row,
							_List_fromArray(
								[
									author$project$Style$paddingBottom(2)
								]),
							_List_fromArray(
								[
									A2(
									Chadtech$elm_css_grid$Html$Grid$column,
									_List_Nil,
									_List_fromArray(
										[
											author$project$View$ButtonRow$view(
											_List_fromArray(
												[
													author$project$View$Button$asDoubleWidth(
													A2(author$project$View$Button$config, author$project$Page$Home$NewDrawingClicked, 'new drawing'))
												]))
										]))
								])),
							A2(
							Chadtech$elm_css_grid$Html$Grid$row,
							_List_fromArray(
								[
									author$project$Style$pit,
									author$project$Style$fullWidth,
									author$project$Style$padding(3),
									rtfeldman$elm_css$Css$flex(
									rtfeldman$elm_css$Css$int(1))
								]),
							A2(elm$core$List$map, drawingView, drawings))
						]))
				]));
	}
};
var Chadtech$elm_relational_database$Db$toList = function (_n0) {
	var dict = _n0.a;
	return A2(
		elm$core$List$map,
		elm$core$Tuple$mapFirst(Chadtech$elm_relational_database$Id$fromString),
		elm$core$Dict$toList(dict));
};
var author$project$Page$Home$getDrawings = A2(
	elm$core$Basics$composeR,
	function ($) {
		return $.drawings;
	},
	Chadtech$elm_relational_database$Db$toList);
var author$project$Style$pxStr = function (i) {
	return elm$core$String$fromInt(
		author$project$Style$scale(i)) + 'px';
};
var rtfeldman$elm_css$Css$position = rtfeldman$elm_css$Css$prop1('position');
var rtfeldman$elm_css$Css$relative = {position: rtfeldman$elm_css$Css$Structure$Compatible, value: 'relative'};
var author$project$Style$relative = rtfeldman$elm_css$Css$position(rtfeldman$elm_css$Css$relative);
var rtfeldman$elm_css$Css$Animations$property = F2(
	function (key, value) {
		return rtfeldman$elm_css$Css$Internal$Property(key + (':' + value));
	});
var author$project$View$Spinner$left = F2(
	function (percent, pxs) {
		return _Utils_Tuple2(
			percent,
			_List_fromArray(
				[
					A2(rtfeldman$elm_css$Css$Animations$property, 'left', pxs)
				]));
	});
var rtfeldman$elm_css$Css$absolute = {position: rtfeldman$elm_css$Css$Structure$Compatible, value: 'absolute'};
var rtfeldman$elm_css$Css$top = rtfeldman$elm_css$Css$prop1('top');
var author$project$View$Spinner$view = A2(
	Chadtech$elm_css_grid$Html$Grid$box,
	_List_fromArray(
		[
			author$project$Style$pit,
			author$project$Style$width(8),
			author$project$Style$height(5),
			author$project$Style$relative,
			author$project$Style$noOverflow
		]),
	_List_fromArray(
		[
			A2(
			Chadtech$elm_css_grid$Html$Grid$box,
			_List_fromArray(
				[
					A2(rtfeldman$elm_css$Css$property, 'animation-duration', '1000ms'),
					A2(rtfeldman$elm_css$Css$property, 'animation-iteration-count', 'infinite'),
					A2(rtfeldman$elm_css$Css$property, 'animation-timing-function', 'linear'),
					rtfeldman$elm_css$Css$animationName(
					rtfeldman$elm_css$Css$Animations$keyframes(
						_List_fromArray(
							[
								A2(
								author$project$View$Spinner$left,
								0,
								'-' + author$project$Style$pxStr(7)),
								A2(
								author$project$View$Spinner$left,
								100,
								author$project$Style$pxStr(8))
							]))),
					author$project$Style$width(6),
					author$project$Style$height(5),
					rtfeldman$elm_css$Css$top(
					rtfeldman$elm_css$Css$px(0)),
					rtfeldman$elm_css$Css$position(rtfeldman$elm_css$Css$absolute),
					rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$content4)
				]),
			_List_Nil)
		]));
var author$project$View$Spinner$row = A2(
	Chadtech$elm_css_grid$Html$Grid$row,
	_List_fromArray(
		[author$project$Style$centerContent]),
	_List_fromArray(
		[
			A2(
			Chadtech$elm_css_grid$Html$Grid$column,
			_List_fromArray(
				[Chadtech$elm_css_grid$Html$Grid$columnShrink]),
			_List_fromArray(
				[author$project$View$Spinner$view]))
		]));
var author$project$Page$Home$viewBody = function (model) {
	var _n0 = model.state;
	switch (_n0.$) {
		case 'SpecificDrawing':
			var id = _n0.a;
			return _List_Nil;
		case 'DeleteDrawing':
			var id = _n0.a;
			return _List_Nil;
		case 'LoadingAllDrawings':
			return author$project$View$SingleCardPage$view(
				A2(
					author$project$View$Card$view,
					_List_Nil,
					_List_fromArray(
						[
							author$project$View$CardHeader$toHtml(
							author$project$View$CardHeader$config(
								{title: 'loading drawings'})),
							author$project$View$Spinner$row
						])));
		case 'LoadingDrawing':
			return _List_Nil;
		case 'Drawings':
			return author$project$Page$Home$drawingsView(
				author$project$Page$Home$getDrawings(model));
		case 'Deleting':
			return _List_Nil;
		case 'DeleteFailed':
			var id = _n0.a;
			var string = _n0.b;
			return _List_Nil;
		case 'Deleted':
			var string = _n0.a;
			return _List_Nil;
		case 'NewDrawing':
			var initDrawingModel = _n0.a;
			return _List_Nil;
		default:
			var string = _n0.a;
			return _List_Nil;
	}
};
var author$project$Page$Home$view = function (model) {
	return {
		body: author$project$Page$Home$viewBody(model),
		title: elm$core$Maybe$Nothing
	};
};
var author$project$Ui$LoginCard$header = function (model) {
	return author$project$View$CardHeader$config(
		{
			title: function () {
				if (model.$ === 'Login') {
					return 'log in';
				} else {
					return 'forgot password';
				}
			}()
		});
};
var author$project$Ui$LoginCard$view = author$project$View$Card$view(
	_List_fromArray(
		[
			author$project$Style$width(9)
		]));
var Chadtech$ct_colors$Chadtech$Colors$problem0 = rtfeldman$elm_css$Css$hex('#651A20');
var author$project$Style$problemBackground = rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$problem0);
var author$project$Ui$LoginCard$ForgotPassword$EmailUpdated = function (a) {
	return {$: 'EmailUpdated', a: a};
};
var author$project$Ui$LoginCard$ForgotPassword$EnterPressed = {$: 'EnterPressed'};
var author$project$Ui$LoginCard$ForgotPassword$ReadyMsg = function (a) {
	return {$: 'ReadyMsg', a: a};
};
var author$project$Ui$LoginCard$ForgotPassword$ResetPasswordClicked = {$: 'ResetPasswordClicked'};
var author$project$Util$Html$mapList = function (f) {
	return elm$core$List$map(
		rtfeldman$elm_css$Html$Styled$map(f));
};
var author$project$View$Input$Input = F2(
	function (a, b) {
		return {$: 'Input', a: a, b: b};
	});
var author$project$View$Input$config = F2(
	function (msgCtor, value) {
		return A2(
			author$project$View$Input$Input,
			{onInput: msgCtor, value: value},
			_List_Nil);
	});
var author$project$View$Input$OnEnter = function (a) {
	return {$: 'OnEnter', a: a};
};
var author$project$View$Input$addOption = F2(
	function (option, _n0) {
		var model = _n0.a;
		var options = _n0.b;
		return A2(
			author$project$View$Input$Input,
			model,
			A2(elm$core$List$cons, option, options));
	});
var author$project$View$Input$onEnter = A2(elm$core$Basics$composeL, author$project$View$Input$addOption, author$project$View$Input$OnEnter);
var author$project$View$Input$Autocomplete = function (a) {
	return {$: 'Autocomplete', a: a};
};
var author$project$View$Input$withAutocomplete = A2(elm$core$Basics$composeL, author$project$View$Input$addOption, author$project$View$Input$Autocomplete);
var rtfeldman$elm_css$Html$Styled$Events$keyCode = A2(elm$json$Json$Decode$field, 'keyCode', elm$json$Json$Decode$int);
var author$project$Util$Html$onEnter = function (msg) {
	var fromCode = function (code) {
		return (code === 13) ? elm$json$Json$Decode$succeed(msg) : elm$json$Json$Decode$fail('Key is not enter');
	};
	return A2(
		rtfeldman$elm_css$Html$Styled$Events$on,
		'keydown',
		A2(elm$json$Json$Decode$andThen, fromCode, rtfeldman$elm_css$Html$Styled$Events$keyCode));
};
var author$project$Util$Maybe$fromBool = F2(
	function (bool, value) {
		return bool ? elm$core$Maybe$Just(value) : elm$core$Maybe$Nothing;
	});
var author$project$View$Input$optionsToSummary = function () {
	var modifySummary = F2(
		function (option, summary) {
			switch (option.$) {
				case 'Password':
					return _Utils_update(
						summary,
						{password: true});
				case 'OnEnter':
					var msg = option.a;
					return _Utils_update(
						summary,
						{
							onEnter: elm$core$Maybe$Just(msg)
						});
				case 'Autocomplete':
					var autocomplete = option.a;
					return _Utils_update(
						summary,
						{
							autocomplete: elm$core$Maybe$Just(autocomplete)
						});
				default:
					var placeholder = option.a;
					return _Utils_update(
						summary,
						{
							placeholder: elm$core$Maybe$Just(placeholder)
						});
			}
		});
	return A2(
		elm$core$List$foldr,
		modifySummary,
		{autocomplete: elm$core$Maybe$Nothing, onEnter: elm$core$Maybe$Nothing, password: false, placeholder: elm$core$Maybe$Nothing});
}();
var rtfeldman$elm_css$Html$Styled$input = rtfeldman$elm_css$Html$Styled$node('input');
var elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var rtfeldman$elm_css$VirtualDom$Styled$attribute = F2(
	function (key, value) {
		return A3(
			rtfeldman$elm_css$VirtualDom$Styled$Attribute,
			A2(elm$virtual_dom$VirtualDom$attribute, key, value),
			_List_Nil,
			'');
	});
var rtfeldman$elm_css$Html$Styled$Attributes$attribute = rtfeldman$elm_css$VirtualDom$Styled$attribute;
var rtfeldman$elm_css$Html$Styled$Attributes$placeholder = rtfeldman$elm_css$Html$Styled$Attributes$stringProperty('placeholder');
var rtfeldman$elm_css$Html$Styled$Attributes$type_ = rtfeldman$elm_css$Html$Styled$Attributes$stringProperty('type');
var author$project$View$Input$toHtml = function (_n0) {
	var value = _n0.a.value;
	var onInput = _n0.a.onInput;
	var options = _n0.b;
	var summary = author$project$View$Input$optionsToSummary(options);
	var conditionalAttrs = A2(
		elm$core$List$filterMap,
		elm$core$Basics$identity,
		_List_fromArray(
			[
				A2(
				author$project$Util$Maybe$fromBool,
				summary.password,
				rtfeldman$elm_css$Html$Styled$Attributes$type_('password')),
				A2(elm$core$Maybe$map, author$project$Util$Html$onEnter, summary.onEnter),
				A2(
				elm$core$Maybe$map,
				rtfeldman$elm_css$Html$Styled$Attributes$attribute('autocomplete'),
				summary.autocomplete),
				A2(elm$core$Maybe$map, rtfeldman$elm_css$Html$Styled$Attributes$placeholder, summary.placeholder)
			]));
	var baseAttrs = _List_fromArray(
		[
			rtfeldman$elm_css$Html$Styled$Attributes$css(
			_List_fromArray(
				[
					author$project$Style$pit,
					author$project$Style$height(5),
					author$project$Style$font,
					author$project$Style$noOutline,
					rtfeldman$elm_css$Css$color(Chadtech$ct_colors$Chadtech$Colors$content4),
					author$project$Style$fontSmoothingNone,
					author$project$Style$padding(2),
					author$project$Style$fullWidth
				])),
			rtfeldman$elm_css$Html$Styled$Attributes$value(value),
			rtfeldman$elm_css$Html$Styled$Attributes$spellcheck(false),
			rtfeldman$elm_css$Html$Styled$Events$onInput(onInput)
		]);
	return A2(
		rtfeldman$elm_css$Html$Styled$input,
		_Utils_ap(baseAttrs, conditionalAttrs),
		_List_Nil);
};
var author$project$View$InputGroup$InputGroup = F2(
	function (a, b) {
		return {$: 'InputGroup', a: a, b: b};
	});
var author$project$View$InputGroup$config = function (model) {
	return A2(author$project$View$InputGroup$InputGroup, model, _List_Nil);
};
var author$project$View$InputGroup$text = function (_n0) {
	var label = _n0.label;
	var input = _n0.input;
	return author$project$View$InputGroup$config(
		{
			input: _List_fromArray(
				[
					author$project$View$Input$toHtml(input)
				]),
			label: label
		});
};
var Chadtech$elm_css_grid$Html$Grid$exactWidthColumn = function (width_) {
	return rtfeldman$elm_css$Css$batch(
		_List_fromArray(
			[
				rtfeldman$elm_css$Css$flex(rtfeldman$elm_css$Css$none),
				rtfeldman$elm_css$Css$width(width_)
			]));
};
var rtfeldman$elm_css$Css$paddingLeft = rtfeldman$elm_css$Css$prop1('padding-left');
var author$project$Style$paddingLeft = A2(elm$core$Basics$composeL, rtfeldman$elm_css$Css$paddingLeft, author$project$Style$sizePx);
var author$project$View$InputGroup$errorView = function (maybeError) {
	if (maybeError.$ === 'Just') {
		var error = maybeError.a;
		return A2(
			Chadtech$elm_css_grid$Html$Grid$row,
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$backgroundColor(Chadtech$ct_colors$Chadtech$Colors$problem0)
				]),
			_List_fromArray(
				[
					A2(
					Chadtech$elm_css_grid$Html$Grid$column,
					_List_fromArray(
						[
							author$project$Style$centerContent,
							rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$column),
							author$project$Style$padding(1)
						]),
					_List_fromArray(
						[
							author$project$View$Text$fromString(error)
						]))
				]));
	} else {
		return rtfeldman$elm_css$Html$Styled$text('');
	}
};
var author$project$View$InputGroup$optionsToSummary = function () {
	var modifySummary = F2(
		function (option, summary) {
			switch (option.$) {
				case 'Error':
					var maybeError = option.a;
					return _Utils_update(
						summary,
						{error: maybeError});
				case 'ExtraStyles':
					var styles = option.a;
					return _Utils_update(
						summary,
						{
							styles: _Utils_ap(styles, summary.styles)
						});
				default:
					return _Utils_update(
						summary,
						{doubleWidth: true});
			}
		});
	return A2(
		elm$core$List$foldr,
		modifySummary,
		{doubleWidth: false, error: elm$core$Maybe$Nothing, styles: _List_Nil});
}();
var author$project$View$Label$view = F2(
	function (label, styles) {
		return A2(
			Chadtech$elm_css_grid$Html$Grid$column,
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$batch(styles),
					rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$column),
					author$project$Style$centerContent
				]),
			_List_fromArray(
				[
					author$project$View$Text$fromString(label)
				]));
	});
var rtfeldman$elm_css$Css$block = {display: rtfeldman$elm_css$Css$Structure$Compatible, value: 'block'};
var author$project$View$InputGroup$toHtml = function (_n0) {
	var label = _n0.a.label;
	var input = _n0.a.input;
	var options = _n0.b;
	var summary = author$project$View$InputGroup$optionsToSummary(options);
	var width = summary.doubleWidth ? 8 : 7;
	return A2(
		Chadtech$elm_css_grid$Html$Grid$box,
		_List_fromArray(
			[
				rtfeldman$elm_css$Css$display(rtfeldman$elm_css$Css$block),
				rtfeldman$elm_css$Css$batch(summary.styles)
			]),
		_List_fromArray(
			[
				A2(
				Chadtech$elm_css_grid$Html$Grid$row,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						author$project$View$Label$view,
						label,
						_List_fromArray(
							[
								author$project$Style$paddingLeft(1),
								Chadtech$elm_css_grid$Html$Grid$exactWidthColumn(
								author$project$Style$sizePx(width))
							])),
						A2(
						Chadtech$elm_css_grid$Html$Grid$column,
						_List_fromArray(
							[
								rtfeldman$elm_css$Css$flexDirection(rtfeldman$elm_css$Css$column)
							]),
						input)
					])),
				author$project$View$InputGroup$errorView(summary.error)
			]));
};
var author$project$View$InputGroup$Error = function (a) {
	return {$: 'Error', a: a};
};
var author$project$View$InputGroup$addOption = F2(
	function (option, _n0) {
		var model = _n0.a;
		var options = _n0.b;
		return A2(
			author$project$View$InputGroup$InputGroup,
			model,
			A2(elm$core$List$cons, option, options));
	});
var author$project$View$InputGroup$withError = A2(elm$core$Basics$composeL, author$project$View$InputGroup$addOption, author$project$View$InputGroup$Error);
var author$project$View$InputGroup$ExtraStyles = function (a) {
	return {$: 'ExtraStyles', a: a};
};
var author$project$View$InputGroup$withStyles = A2(elm$core$Basics$composeL, author$project$View$InputGroup$addOption, author$project$View$InputGroup$ExtraStyles);
var rtfeldman$elm_css$Html$Styled$form = rtfeldman$elm_css$Html$Styled$node('form');
var author$project$Ui$LoginCard$ForgotPassword$view = function (model) {
	switch (model.$) {
		case 'Ready':
			var email = model.a;
			return A2(
				author$project$Util$Html$mapList,
				author$project$Ui$LoginCard$ForgotPassword$ReadyMsg,
				_List_fromArray(
					[
						A2(
						rtfeldman$elm_css$Html$Styled$form,
						_List_Nil,
						_List_fromArray(
							[
								author$project$View$InputGroup$toHtml(
								A2(
									author$project$View$InputGroup$withError,
									author$project$Data$Field$getError(email),
									A2(
										author$project$View$InputGroup$withStyles,
										_List_fromArray(
											[
												author$project$Style$marginBottom(1)
											]),
										author$project$View$InputGroup$text(
											{
												input: A2(
													author$project$View$Input$onEnter,
													author$project$Ui$LoginCard$ForgotPassword$EnterPressed,
													A2(
														author$project$View$Input$withAutocomplete,
														'email',
														A2(
															author$project$View$Input$config,
															author$project$Ui$LoginCard$ForgotPassword$EmailUpdated,
															author$project$Data$Field$getValue(email)))),
												label: 'email'
											}))))
							])),
						author$project$View$ButtonRow$view(
						_List_fromArray(
							[
								author$project$View$Button$asDoubleWidth(
								A2(author$project$View$Button$config, author$project$Ui$LoginCard$ForgotPassword$ResetPasswordClicked, 'reset password'))
							]))
					]));
		case 'Waiting':
			return _List_fromArray(
				[author$project$View$Spinner$row]);
		case 'Success':
			var email = model.a.email;
			return _List_fromArray(
				[
					author$project$View$Text$fromString(
					A2(
						elm$core$String$join,
						' ',
						_List_fromArray(
							['Okay, I have sent an email to', email, 'containing a password reset link. Check your email to proceed.'])))
				]);
		default:
			return _List_fromArray(
				[
					A2(
					author$project$View$Card$textRow,
					_List_fromArray(
						[author$project$Style$problemBackground]),
					'\n                Oh no, something went wrong. Im sorry about that.\n                Try again, and if it still doesnt work, please report\n                this error to chadtech0@gmail.com .\n                ')
				]);
	}
};
var author$project$Ui$LoginCard$Login$EmailUpdated = function (a) {
	return {$: 'EmailUpdated', a: a};
};
var author$project$Ui$LoginCard$Login$ForgotPasswordClicked = {$: 'ForgotPasswordClicked'};
var author$project$Ui$LoginCard$Login$LoginClicked = {$: 'LoginClicked'};
var author$project$Ui$LoginCard$Login$PasswordUpdated = function (a) {
	return {$: 'PasswordUpdated', a: a};
};
var author$project$Ui$LoginCard$Login$TryAgainClicked = {$: 'TryAgainClicked'};
var author$project$Ui$LoginCard$Login$errorMsg = function (error) {
	if (error.$ === 'IncorrectCredentials') {
		return 'Either the user does not exist or the password you entered was incorrect';
	} else {
		return 'Please reset your password';
	}
};
var author$project$Ui$LoginCard$Login$errorView = function (listenerError) {
	var problemRow = author$project$View$Card$textRow(
		_List_fromArray(
			[
				author$project$Style$problemBackground,
				author$project$Style$marginBottom(1)
			]));
	if (listenerError.$ === 'DecodeError') {
		var decodeError = listenerError.a;
		return _List_fromArray(
			[
				problemRow('\n                Im really sorry. Something really broke.\n                Please let me know that you had this problem\n                by emailing me at chadtech0@gmail.com. Below\n                is the error that occurred:\n                '),
				author$project$View$Card$errorDisplay(
				elm$json$Json$Decode$errorToString(decodeError))
			]);
	} else {
		var error = listenerError.a;
		return _List_fromArray(
			[
				problemRow(
				author$project$Ui$LoginCard$Login$errorMsg(error))
			]);
	}
};
var author$project$Ui$LoginCard$Login$EnterPressed = {$: 'EnterPressed'};
var author$project$Util$Function$composeMany = A2(elm$core$List$foldr, elm$core$Basics$composeR, elm$core$Basics$identity);
var author$project$Ui$LoginCard$Login$inputGroupView = function (_n0) {
	var label = _n0.label;
	var options = _n0.options;
	var onInput = _n0.onInput;
	var field = _n0.field;
	return author$project$View$InputGroup$toHtml(
		A2(
			author$project$View$InputGroup$withError,
			author$project$Data$Field$getError(field),
			A2(
				author$project$View$InputGroup$withStyles,
				_List_fromArray(
					[
						author$project$Style$marginBottom(1)
					]),
				author$project$View$InputGroup$text(
					{
						input: A2(
							author$project$View$Input$onEnter,
							author$project$Ui$LoginCard$Login$EnterPressed,
							A2(
								author$project$Util$Function$composeMany,
								options,
								A2(
									author$project$View$Input$config,
									onInput,
									author$project$Data$Field$getValue(field)))),
						label: label
					}))));
};
var author$project$View$Input$Password = {$: 'Password'};
var author$project$View$Input$isPassword = author$project$View$Input$addOption(author$project$View$Input$Password);
var author$project$View$Link$Link = F2(
	function (a, b) {
		return {$: 'Link', a: a, b: b};
	});
var author$project$View$Link$config = F2(
	function (onClick, label) {
		return A2(
			author$project$View$Link$Link,
			{label: label, onClick: onClick},
			_List_Nil);
	});
var Chadtech$ct_colors$Chadtech$Colors$important0 = rtfeldman$elm_css$Css$hex('#B39F4B');
var Chadtech$ct_colors$Chadtech$Colors$important1 = rtfeldman$elm_css$Css$hex('#E3D34B');
var author$project$Style$noBackground = A2(rtfeldman$elm_css$Css$property, 'background', 'none');
var author$project$Style$noBorder = A2(rtfeldman$elm_css$Css$property, 'border', 'none');
var author$project$View$Link$optionsToSummary = function () {
	var modifySummary = F2(
		function (option, summary) {
			return summary;
		});
	return A2(
		elm$core$List$foldr,
		modifySummary,
		{});
}();
var author$project$View$Link$toHtml = function (_n0) {
	var onClick = _n0.a.onClick;
	var label = _n0.a.label;
	var options = _n0.b;
	var summary = author$project$View$Link$optionsToSummary(options);
	return A2(
		rtfeldman$elm_css$Html$Styled$button,
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$Attributes$css(
				_List_fromArray(
					[
						author$project$Style$height(5),
						rtfeldman$elm_css$Css$color(Chadtech$ct_colors$Chadtech$Colors$important0),
						rtfeldman$elm_css$Css$hover(
						_List_fromArray(
							[
								rtfeldman$elm_css$Css$color(Chadtech$ct_colors$Chadtech$Colors$important1)
							])),
						author$project$Style$noBackground,
						author$project$Style$noBorder
					])),
				rtfeldman$elm_css$Html$Styled$Events$onClick(onClick)
			]),
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$text(label)
			]));
};
var author$project$Ui$LoginCard$Login$view = function (model) {
	var _n0 = model.httpStatus;
	switch (_n0.$) {
		case 'Ready':
			return _List_fromArray(
				[
					A2(
					rtfeldman$elm_css$Html$Styled$form,
					_List_Nil,
					_List_fromArray(
						[
							author$project$Ui$LoginCard$Login$inputGroupView(
							{
								field: model.email,
								label: 'email',
								onInput: author$project$Ui$LoginCard$Login$EmailUpdated,
								options: _List_fromArray(
									[
										author$project$View$Input$withAutocomplete('email')
									])
							}),
							author$project$Ui$LoginCard$Login$inputGroupView(
							{
								field: model.password,
								label: 'password',
								onInput: author$project$Ui$LoginCard$Login$PasswordUpdated,
								options: _List_fromArray(
									[
										author$project$View$Input$isPassword,
										author$project$View$Input$withAutocomplete('current-password')
									])
							})
						])),
					author$project$View$Link$toHtml(
					A2(author$project$View$Link$config, author$project$Ui$LoginCard$Login$ForgotPasswordClicked, 'I forgot my password')),
					author$project$View$ButtonRow$view(
					_List_fromArray(
						[
							A2(author$project$View$Button$config, author$project$Ui$LoginCard$Login$LoginClicked, 'log in')
						]))
				]);
		case 'LoggingIn':
			return _List_fromArray(
				[author$project$View$Spinner$row]);
		default:
			var error = _n0.a;
			return A2(
				elm$core$List$append,
				author$project$Ui$LoginCard$Login$errorView(error),
				_List_fromArray(
					[
						author$project$View$ButtonRow$view(
						_List_fromArray(
							[
								A2(author$project$View$Button$config, author$project$Ui$LoginCard$Login$TryAgainClicked, 'try again')
							]))
					]));
	}
};
var author$project$Ui$LoginCard$viewBody = function (model) {
	if (model.$ === 'Login') {
		var subModel = model.a;
		return A2(
			author$project$Util$Html$mapList,
			author$project$Ui$LoginCard$LoginMsg,
			author$project$Ui$LoginCard$Login$view(subModel));
	} else {
		var subModel = model.a;
		return A2(
			author$project$Util$Html$mapList,
			author$project$Ui$LoginCard$ForgotPasswordMsg,
			author$project$Ui$LoginCard$ForgotPassword$view(subModel));
	}
};
var author$project$Page$Login$view = function (model) {
	var header = author$project$View$CardHeader$toHtml(
		author$project$Ui$LoginCard$header(model.loginCard));
	var body = A2(
		author$project$Util$Html$mapList,
		author$project$Page$Login$LoginCardMsg,
		author$project$Ui$LoginCard$viewBody(model.loginCard));
	return {
		body: author$project$View$SingleCardPage$view(
			author$project$Ui$LoginCard$view(
				A2(elm$core$List$cons, header, body))),
		title: elm$core$Maybe$Just('log in')
	};
};
var author$project$Page$Logout$view = function (model) {
	return {body: _List_Nil, title: elm$core$Maybe$Nothing};
};
var author$project$Page$PageNotFound$GoHomeClicked = {$: 'GoHomeClicked'};
var author$project$Page$PageNotFound$view = {
	body: author$project$View$SingleCardPage$view(
		A2(
			author$project$View$Card$view,
			_List_fromArray(
				[
					author$project$Style$width(9)
				]),
			_List_fromArray(
				[
					author$project$View$CardHeader$toHtml(
					author$project$View$CardHeader$config(
						{title: 'page not found'})),
					A2(author$project$View$Card$textRow, _List_Nil, 'Sorry, something went wrong. This page does not exist.'),
					author$project$View$ButtonRow$view(
					_List_fromArray(
						[
							A2(author$project$View$Button$config, author$project$Page$PageNotFound$GoHomeClicked, 'go home')
						]))
				]))),
	title: elm$core$Maybe$Nothing
};
var author$project$Page$PaintApp$view = function (model) {
	return {
		body: _List_fromArray(
			[
				author$project$View$Text$fromString('Paint App!!')
			]),
		title: elm$core$Maybe$Nothing
	};
};
var author$project$Page$ResetPassword$CodeUpdated = function (a) {
	return {$: 'CodeUpdated', a: a};
};
var author$project$Page$ResetPassword$EmailUpdated = function (a) {
	return {$: 'EmailUpdated', a: a};
};
var author$project$Page$ResetPassword$LoginClicked = {$: 'LoginClicked'};
var author$project$Page$ResetPassword$PasswordConfirmUpdated = function (a) {
	return {$: 'PasswordConfirmUpdated', a: a};
};
var author$project$Page$ResetPassword$PasswordUpdated = function (a) {
	return {$: 'PasswordUpdated', a: a};
};
var author$project$Page$ResetPassword$ResetPasswordClicked = {$: 'ResetPasswordClicked'};
var author$project$Page$ResetPassword$errorView = function (error) {
	var problemRow = author$project$View$Card$textRow(
		_List_fromArray(
			[author$project$Style$problemBackground]));
	if (error.$ === 'DecodeError') {
		var decodeError = error.a;
		return _List_fromArray(
			[
				problemRow('\n                Im really sorry. Something really broke.\n                Please let me know that you had this problem\n                by emailing me at chadtech0@gmail.com. Below\n                is the error that occurred:\n                '),
				author$project$View$Card$errorDisplay(
				elm$json$Json$Decode$errorToString(decodeError))
			]);
	} else {
		if (error.a.$ === 'InvalidCode') {
			var _n1 = error.a;
			return _List_fromArray(
				[
					problemRow('\n                The reset code was invalid. \n                If you requested this code a while ago, \n                then its probably expired. \n                Sorry. Please try again."\n                ')
				]);
		} else {
			var str = error.a.a;
			return _List_fromArray(
				[
					problemRow('\n                Sorry, something unexpected happened. \n                Please let me know that you had this problem\n                by emailing me at chadtech0@gmail.com. Below\n                is the error that occurred:\n                '),
					author$project$View$Card$errorDisplay(str)
				]);
		}
	}
};
var author$project$Page$ResetPassword$EnterPressed = {$: 'EnterPressed'};
var author$project$View$InputGroup$DoubleWidth = {$: 'DoubleWidth'};
var author$project$View$InputGroup$withDoubleWidth = author$project$View$InputGroup$addOption(author$project$View$InputGroup$DoubleWidth);
var author$project$Page$ResetPassword$inputGroupView = function (_n0) {
	var label = _n0.label;
	var options = _n0.options;
	var onInput = _n0.onInput;
	var field = _n0.field;
	return author$project$View$InputGroup$toHtml(
		author$project$View$InputGroup$withDoubleWidth(
			A2(
				author$project$View$InputGroup$withError,
				author$project$Data$Field$getError(field),
				A2(
					author$project$View$InputGroup$withStyles,
					_List_fromArray(
						[
							author$project$Style$marginBottom(1)
						]),
					author$project$View$InputGroup$text(
						{
							input: A2(
								author$project$View$Input$onEnter,
								author$project$Page$ResetPassword$EnterPressed,
								A2(
									author$project$Util$Function$composeMany,
									options,
									A2(
										author$project$View$Input$config,
										onInput,
										author$project$Data$Field$getValue(field)))),
							label: label
						})))));
};
var author$project$Page$ResetPassword$viewBody = function (model) {
	var _n0 = model.status;
	switch (_n0.$) {
		case 'Ready':
			return _List_fromArray(
				[
					A2(
					rtfeldman$elm_css$Html$Styled$form,
					_List_Nil,
					_List_fromArray(
						[
							author$project$Page$ResetPassword$inputGroupView(
							{
								field: model.email,
								label: 'email',
								onInput: author$project$Page$ResetPassword$EmailUpdated,
								options: _List_fromArray(
									[
										author$project$View$Input$withAutocomplete('email')
									])
							}),
							author$project$Page$ResetPassword$inputGroupView(
							{field: model.code, label: 'code', onInput: author$project$Page$ResetPassword$CodeUpdated, options: _List_Nil}),
							author$project$Page$ResetPassword$inputGroupView(
							{
								field: model.password,
								label: 'new password',
								onInput: author$project$Page$ResetPassword$PasswordUpdated,
								options: _List_fromArray(
									[
										author$project$View$Input$isPassword,
										author$project$View$Input$withAutocomplete('new-password')
									])
							}),
							author$project$Page$ResetPassword$inputGroupView(
							{
								field: model.passwordConfirm,
								label: 'confirm new password',
								onInput: author$project$Page$ResetPassword$PasswordConfirmUpdated,
								options: _List_fromArray(
									[
										author$project$View$Input$isPassword,
										author$project$View$Input$withAutocomplete('new-password')
									])
							})
						])),
					author$project$View$ButtonRow$view(
					_List_fromArray(
						[
							author$project$View$Button$asDoubleWidth(
							A2(author$project$View$Button$config, author$project$Page$ResetPassword$ResetPasswordClicked, 'reset password'))
						]))
				]);
		case 'Waiting':
			return _List_fromArray(
				[author$project$View$Spinner$row]);
		case 'Success':
			return _List_fromArray(
				[
					A2(author$project$View$Card$textRow, _List_Nil, '\n                    Great. It worked. Your password has been reset.\n                    Now go back to the login in page and use your\n                    new password.\n                    '),
					author$project$View$ButtonRow$view(
					_List_fromArray(
						[
							A2(author$project$View$Button$config, author$project$Page$ResetPassword$LoginClicked, 'go to login')
						]))
				]);
		default:
			var error = _n0.a;
			return author$project$Page$ResetPassword$errorView(error);
	}
};
var author$project$Page$ResetPassword$view = function (model) {
	var title = 'reset password';
	var header = author$project$View$CardHeader$toHtml(
		author$project$View$CardHeader$config(
			{title: title}));
	return {
		body: author$project$View$SingleCardPage$view(
			A2(
				author$project$View$Card$view,
				_List_fromArray(
					[
						author$project$Style$width(9)
					]),
				A2(
					elm$core$List$cons,
					header,
					author$project$Page$ResetPassword$viewBody(model)))),
		title: elm$core$Maybe$Just(title)
	};
};
var author$project$Page$Settings$view = function (model) {
	return {
		body: _List_Nil,
		title: elm$core$Maybe$Just('settings')
	};
};
var author$project$Page$Splash$DrawClicked = {$: 'DrawClicked'};
var author$project$Page$Splash$LearnMoreClicked = {$: 'LearnMoreClicked'};
var author$project$View$Button$Tall = function (a) {
	return {$: 'Tall', a: a};
};
var author$project$View$Button$makeTaller = A2(elm$core$Basics$composeL, author$project$View$Button$addOption, author$project$View$Button$Tall);
var author$project$Page$Splash$button = F2(
	function (msg, label) {
		return A2(
			Chadtech$elm_css_grid$Html$Grid$column,
			_List_fromArray(
				[Chadtech$elm_css_grid$Html$Grid$columnShrink]),
			_List_fromArray(
				[
					author$project$View$Button$toHtml(
					A2(
						author$project$View$Button$makeTaller,
						true,
						author$project$View$Button$asDoubleWidth(
							A2(author$project$View$Button$config, msg, label))))
				]));
	});
var author$project$Page$Splash$splashMsg = '\n    CtPaint is good pixel art software that runs in your internet browser.\n    It has all the functionality of a classic paint program with cloud storage\n    and a seamless connection to all the internets images. Its free and\n    requires no installation.\n    ';
var author$project$View$Video$FullWidth = {$: 'FullWidth'};
var author$project$View$Video$Video = F2(
	function (a, b) {
		return {$: 'Video', a: a, b: b};
	});
var author$project$View$Video$addOption = F2(
	function (option, _n0) {
		var source = _n0.a;
		var options = _n0.b;
		return A2(
			author$project$View$Video$Video,
			source,
			A2(elm$core$List$cons, option, options));
	});
var author$project$View$Video$asFullWidth = author$project$View$Video$addOption(author$project$View$Video$FullWidth);
var author$project$View$Video$config = function (source) {
	return A2(author$project$View$Video$Video, source, _List_Nil);
};
var author$project$View$Video$Splash = function (a) {
	return {$: 'Splash', a: a};
};
var author$project$View$Video$splash = author$project$View$Video$Splash;
var author$project$View$Video$sourceToString = function (source) {
	var mountPath = source.a;
	return A2(
		author$project$Data$MountPath$path,
		mountPath,
		_List_fromArray(
			['splash-video.mp4']));
};
var rtfeldman$elm_css$Html$Styled$video = rtfeldman$elm_css$Html$Styled$node('video');
var rtfeldman$elm_css$Html$Styled$Attributes$autoplay = rtfeldman$elm_css$Html$Styled$Attributes$boolProperty('autoplay');
var rtfeldman$elm_css$Html$Styled$Attributes$loop = rtfeldman$elm_css$Html$Styled$Attributes$boolProperty('loop');
var author$project$View$Video$toHtml = function (_n0) {
	var source = _n0.a;
	var options = _n0.b;
	var height = A2(elm$core$List$member, author$project$View$Video$FullWidth, options) ? author$project$Style$fullWidth : author$project$Util$Css$noStyle;
	return A2(
		rtfeldman$elm_css$Html$Styled$video,
		_List_fromArray(
			[
				rtfeldman$elm_css$Html$Styled$Attributes$src(
				author$project$View$Video$sourceToString(source)),
				rtfeldman$elm_css$Html$Styled$Attributes$autoplay(true),
				rtfeldman$elm_css$Html$Styled$Attributes$loop(true),
				rtfeldman$elm_css$Html$Styled$Attributes$css(
				_List_fromArray(
					[height]))
			]),
		_List_Nil);
};
var rtfeldman$elm_css$Css$spaceAround = rtfeldman$elm_css$Css$prop1('space-around');
var author$project$Page$Splash$viewBody = function (mountPath) {
	return author$project$View$Body$singleColumnView(
		_List_fromArray(
			[
				author$project$View$BannerLogo$view(mountPath),
				A2(
				Chadtech$elm_css_grid$Html$Grid$row,
				_List_fromArray(
					[
						author$project$Style$marginBottom(3)
					]),
				_List_fromArray(
					[
						A2(
						Chadtech$elm_css_grid$Html$Grid$column,
						_List_Nil,
						_List_fromArray(
							[
								author$project$View$Text$fromString(author$project$Page$Splash$splashMsg)
							]))
					])),
				A2(
				Chadtech$elm_css_grid$Html$Grid$row,
				_List_fromArray(
					[
						rtfeldman$elm_css$Css$justifyContent(rtfeldman$elm_css$Css$spaceAround)
					]),
				_List_fromArray(
					[
						A2(author$project$Page$Splash$button, author$project$Page$Splash$LearnMoreClicked, 'learn more'),
						A2(author$project$Page$Splash$button, author$project$Page$Splash$DrawClicked, 'start drawing')
					])),
				A2(
				Chadtech$elm_css_grid$Html$Grid$row,
				_List_fromArray(
					[
						author$project$Style$indent,
						author$project$Style$marginTop(3)
					]),
				_List_fromArray(
					[
						A2(
						Chadtech$elm_css_grid$Html$Grid$column,
						_List_Nil,
						_List_fromArray(
							[
								author$project$View$Video$toHtml(
								author$project$View$Video$asFullWidth(
									author$project$View$Video$config(
										author$project$View$Video$splash(mountPath))))
							]))
					]))
			]));
};
var author$project$Page$Splash$view = function (mountPath) {
	return {
		body: author$project$Page$Splash$viewBody(mountPath),
		title: elm$core$Maybe$Nothing
	};
};
var author$project$Session$getMountPath = function ($) {
	return $.mountPath;
};
var author$project$Main$viewPage = function (model) {
	switch (model.$) {
		case 'Blank':
			return {body: _List_Nil, title: elm$core$Maybe$Nothing};
		case 'PageNotFound':
			return A2(author$project$Data$Document$map, author$project$Main$PageNotFoundMsg, author$project$Page$PageNotFound$view);
		case 'PaintApp':
			var subModel = model.a;
			return author$project$Page$PaintApp$view(subModel);
		case 'Splash':
			var session = model.a;
			return A2(
				author$project$Main$viewInFrame,
				model,
				A2(
					author$project$Data$Document$map,
					author$project$Main$SplashMsg,
					author$project$Page$Splash$view(
						author$project$Session$getMountPath(session))));
		case 'About':
			var session = model.a.session;
			return A2(
				author$project$Main$viewInFrame,
				model,
				A2(
					author$project$Page$About$view,
					author$project$Session$getBuildNumber(session),
					author$project$Session$getMountPath(session)));
		case 'Login':
			var subModel = model.a;
			return A2(
				author$project$Data$Document$map,
				author$project$Main$LoginMsg,
				author$project$Page$Login$view(subModel));
		case 'ResetPassword':
			var subModel = model.a;
			return A2(
				author$project$Data$Document$map,
				author$project$Main$ResetPasswordMsg,
				author$project$Page$ResetPassword$view(subModel));
		case 'Settings':
			var subModel = model.a;
			return A2(
				author$project$Data$Document$map,
				author$project$Main$SettingsMsg,
				author$project$Page$Settings$view(subModel));
		case 'Home':
			var subModel = model.a;
			var _n1 = A2(elm$core$Debug$log, 'VIEW HOME', _Utils_Tuple0);
			return A2(
				author$project$Main$viewInFrame,
				model,
				A2(
					author$project$Data$Document$map,
					author$project$Main$HomeMsg,
					author$project$Page$Home$view(subModel)));
		case 'Logout':
			var subModel = model.a;
			return author$project$Page$Logout$view(subModel);
		default:
			var subModel = model.a;
			return A2(
				author$project$Data$Document$map,
				author$project$Main$ContactMsg,
				author$project$Page$Contact$view(subModel));
	}
};
var author$project$Main$view = function (result) {
	if (result.$ === 'Ok') {
		var page = result.a;
		return author$project$Main$viewPage(page);
	} else {
		var error = result.a;
		return author$project$Main$viewError(error);
	}
};
var rtfeldman$elm_css$Css$cursor = rtfeldman$elm_css$Css$prop1('cursor');
var rtfeldman$elm_css$Css$pointer = {cursor: rtfeldman$elm_css$Css$Structure$Compatible, value: 'pointer'};
var author$project$Style$pointer = rtfeldman$elm_css$Css$cursor(rtfeldman$elm_css$Css$pointer);
var rtfeldman$elm_css$Css$borderBox = {backgroundClip: rtfeldman$elm_css$Css$Structure$Compatible, boxSizing: rtfeldman$elm_css$Css$Structure$Compatible, value: 'border-box'};
var rtfeldman$elm_css$Css$boxSizing = rtfeldman$elm_css$Css$prop1('box-sizing');
var rtfeldman$elm_css$Css$Structure$TypeSelector = function (a) {
	return {$: 'TypeSelector', a: a};
};
var rtfeldman$elm_css$Css$Global$typeSelector = F2(
	function (selectorStr, styles) {
		var sequence = A2(
			rtfeldman$elm_css$Css$Structure$TypeSelectorSequence,
			rtfeldman$elm_css$Css$Structure$TypeSelector(selectorStr),
			_List_Nil);
		var sel = A3(rtfeldman$elm_css$Css$Structure$Selector, sequence, _List_Nil, elm$core$Maybe$Nothing);
		return rtfeldman$elm_css$Css$Preprocess$Snippet(
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$Preprocess$StyleBlockDeclaration(
					A3(rtfeldman$elm_css$Css$Preprocess$StyleBlock, sel, _List_Nil, styles))
				]));
	});
var rtfeldman$elm_css$Css$Global$button = rtfeldman$elm_css$Css$Global$typeSelector('button');
var rtfeldman$elm_css$Css$Global$everything = function (styles) {
	return A2(
		rtfeldman$elm_css$VirtualDom$Styled$makeSnippet,
		styles,
		rtfeldman$elm_css$Css$Structure$UniversalSelectorSequence(_List_Nil));
};
var rtfeldman$elm_css$VirtualDom$Styled$unstyledNode = rtfeldman$elm_css$VirtualDom$Styled$Unstyled;
var rtfeldman$elm_css$Css$Global$global = function (snippets) {
	return rtfeldman$elm_css$VirtualDom$Styled$unstyledNode(
		A3(
			elm$virtual_dom$VirtualDom$node,
			'style',
			_List_Nil,
			elm$core$List$singleton(
				elm$virtual_dom$VirtualDom$text(
					rtfeldman$elm_css$Css$Preprocess$Resolve$compile(
						elm$core$List$singleton(
							rtfeldman$elm_css$Css$Preprocess$stylesheet(snippets)))))));
};
var rtfeldman$elm_css$Css$Global$p = rtfeldman$elm_css$Css$Global$typeSelector('p');
var author$project$Style$globals = rtfeldman$elm_css$Css$Global$global(
	_List_fromArray(
		[
			rtfeldman$elm_css$Css$Global$p(
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$color(Chadtech$ct_colors$Chadtech$Colors$content4),
					author$project$Style$fontSmoothingNone,
					author$project$Style$font
				])),
			rtfeldman$elm_css$Css$Global$button(
			_List_fromArray(
				[author$project$Style$font, author$project$Style$noOutline, author$project$Style$pointer, author$project$Style$fontSmoothingNone])),
			rtfeldman$elm_css$Css$Global$everything(
			_List_fromArray(
				[
					rtfeldman$elm_css$Css$boxSizing(rtfeldman$elm_css$Css$borderBox),
					rtfeldman$elm_css$Css$margin(rtfeldman$elm_css$Css$zero),
					rtfeldman$elm_css$Css$padding(rtfeldman$elm_css$Css$zero)
				]))
		]));
var elm$browser$Browser$application = _Browser_application;
var author$project$Main$main = elm$browser$Browser$application(
	{
		init: author$project$Main$init,
		onUrlChange: author$project$Main$onNavigation,
		onUrlRequest: author$project$Main$UrlRequested,
		subscriptions: author$project$Main$subscriptions,
		update: author$project$Main$update,
		view: A2(
			elm$core$Basics$composeR,
			author$project$Main$view,
			A2(
				elm$core$Basics$composeR,
				author$project$Data$Document$cons(author$project$Style$globals),
				author$project$Data$Document$toBrowserDocument))
	});
_Platform_export({'Main':{'init':author$project$Main$main(elm$json$Json$Decode$value)(0)}});}(this));