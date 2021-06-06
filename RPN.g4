///**
// * Define a grammar called Hello
// */
//grammar RPN;
//r  : 'hello' ID ;         // match keyword hello followed by an identifier
//
//ID : [a-z]+ ;             // match lower-case identifiers
//
//WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines
//
grammar RPN;

@header{
	import java.util.*;
}

@members {
 	int intVal = 0;
	int a = 0;
	int b = 0;
	Object operand1 = null;
	Object operand2 = null;
	boolean c = false;
	boolean d = false;
	Stack<Object> myStack = new Stack<Object>();
	
	public void pushOperand( String val){
		myStack.push(Integer.parseInt(val));
	}

	public void pushBool (String val){
		if(val.equals("true")){
			myStack.push(true);
		}
		else{
			myStack.push(false);
		}
	}

	public void checkNumArguments(String op, int numArgs) {
        if(myStack.size() < numArgs) {
            throw new IllegalArgumentException("Not enough arguments for " + op + ", expecting " + numArgs + " arguements");
        }
    }

	public void checkIfBool(String op, Object obj) {
        if(!(obj instanceof Boolean)) {
            throw new IllegalArgumentException("Need a boolean " + op + ", got " + obj);
        }
    }

	public void checkIfInt(String op, Object obj) {
        if(!(obj instanceof Integer)) {
            throw new IllegalArgumentException("Need an integer " + op + ", got " + obj);
        }
    }

	public void numRelOp ( String op){
		checkNumArguments(op, 2);
		operand2 = myStack.pop();
		checkIfInt(op, operand2);
		operand1 = myStack.pop();
		checkIfInt(op, operand1);
		a = (int) operand2;
		b = (int) operand1;
		if(op.equals("+")){
			myStack.push(a + b);
		}
		else if(op.equals("-")){
			myStack.push(a-b);
		}
		else if(op.equals("*")){
			myStack.push(a*b);
		}
		else if(op.equals("/")){
			myStack.push(a/b);
		}
		else if(op.equals("%")){
			myStack.push(a%b);
		}
		else if(op.equals("<")){
			myStack.push(a<b);
		}
		else if(op.equals("<=")){
			myStack.push(a<=b);
		}
		else if(op.equals("==")){
			myStack.push(a==b);
		}
		else if(op.equals("!=")){
			myStack.push(a!=b);
		}
		else if(op.equals(">")){
			myStack.push(a>b);
		}
		else if(op.equals(">=")){
			myStack.push(a>=b);
		}
		else{
			throw new IllegalArgumentException("Unknown operation "+op);
		}
	}

	public void notOp(String op) {
        checkNumArguments(op, 1);
        Object boolVal = myStack.pop();
        checkIfBool(op, boolVal);
        c = (boolean) boolVal;
        if(op.equals("!")){
			myStack.push(!c);
		}
		else{
			throw new IllegalArgumentException("Unknown operation "+op);
		}
	}

	public void relOp(String op){
		checkNumArguments(op, 2);
		operand2 = myStack.pop();
		checkIfBool(op, operand2);
		operand1 = myStack.pop();
		checkIfBool(op, operand1);
		c = (boolean) operand1;
		d = (boolean) operand2;
		if(op.equals("&&")){
			myStack.push(c&&d);
		}
		else if(op.equals("||")){
			myStack.push(c||d);
		}
		else{
			throw new IllegalArgumentException("Unknown operation "+op);
		}
	}

	public void endOfExpr(){
		if(myStack.size() < 1){
			System.out.println("Operations Completed!!");
		}
		else if(myStack.size() > 1){
			System.out.println("Moving to next Operation");
		}
		System.out.println(myStack.pop());
		myStack.clear();
	}
}

// PARSER RULES 	 
start
 	: ((expr)+ STAT_END)+
	;

expr
	: operands
	| op
	;

operands
	: INT
	| BOOL
	;

op 
	: num_bool_op
	| NOT
	;

num_bool_op
	: NUM_REL_OP
	| LOG_OP
	;



// LEXER RULES	 
INT : [0-9]+{
				pushOperand(getText());
			};
NUM_REL_OP : ('+'|'-'|'*'|'/'|'%'|'<'|'<='|'=='|'!='|'>'|'>='){
																numRelOp(getText());	
															  };
LOG_OP : ('&&'|'||'){
						relOp(getText());
					};
STAT_END : ';'{
					endOfExpr();
			  };
BOOL : ('true'|'false'){
						pushBool(getText());	
						};
NOT : '!';
WS : [ \r\t\n]+ -> skip ;