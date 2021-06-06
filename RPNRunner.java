import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
    
public class RPNRunner {
    @SuppressWarnings("deprecation")	
	public static void main( String[] args) throws Exception {
    
    		ANTLRInputStream input = new ANTLRInputStream( System.in);
    
    		RPNLexer lexer = new RPNLexer(input);
    
    		CommonTokenStream tokens = new CommonTokenStream(lexer);
    
    		RPNParser parser = new RPNParser(tokens);
    		ParseTree tree = parser.start(); // begin parsing at rule 'r'
    		System.out.println(tree.toStringTree(parser)); // print LISP-style tree
    }
}