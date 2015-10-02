// ------------------Private Functions-------------------
\d .eca
// Decimal to binary function
// Used to create rules from the binary rule number 0 - 255
// @param x decimal number of type long or int
// @example:
// q).eca.priv.dtb 90
// 1 0 1 1 0 1 0
priv.dtb:{1_reverse((div[;2]\)x) mod 2}

// Convert binary to decimal
// @param x list of 1s and 0s
// @example:
// 1).eca.priv.btd 0 1 0 1 1 0 1 0
// 90
priv.btd:{sum 2 xexp where 1=reverse x}

// Rule construction function
// Calls .eca.dtb to convert input
// @param x decimal number of type long or int
// @example:
// q).eca.priv.constructRule 90
// 0 1 0 1 1 0 1 0
priv.constructRule:{reverse #[8-count a;0],a:priv.dtb x}

// Applies rule once do a generation of an elementary cellular automaton
// @param x rule returned by .eca.priv.constructRule
// @param y dictionary with keys `i=current generation, `o=result of rule applied to first 3 cells in `i
// @example:
// q).eca.priv.appRule[.eca.priv.constructRule 90;`i`o!(-1 rotate 0 1 1 0;())]
// i| 0 1 1 0
// o| ,1
priv.appRule:{if[count[y`o]=count y`i;:y];`i`o!(1 rotate y`i;y[`o],x`int$priv.btd[3#y`i])}

// Evaluate the rule for the entire current generation
// @param x rule returned from .eca.priv.constructRule
// @param y generation to apply rule to
// @example:
// q).eca.priv.evalRule[.eca.priv.constructRule 90;0 1 1 0]
// XXXX
priv.evalRule:{r:(priv.appRule[x]/)[`i`o!(rotate[-1;y];())];-1 " X"r`o;r`o}

// ------------------Public Functions-------------------
\d .
// Apply input rule to an elementary cellular automaton for a given number of iterations
// @param x first generation
// @param y rule number
// @param z number of generations to iterate over
eca:{-1 " X" x;.eca.priv.evalRule[.eca.priv.constructRule y]/[z;x];}
