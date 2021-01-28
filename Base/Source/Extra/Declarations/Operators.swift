infix operator +- : AdditionPrecedence
infix operator -+ : AdditionPrecedence
infix operator ** : ExponentiationPrecedence

infix operator <<> : BitwiseShiftPrecedence
infix operator <>> : BitwiseShiftPrecedence

precedencegroup ExponentiationPrecedence {
	higherThan: MultiplicationPrecedence
	associativity: right
}
