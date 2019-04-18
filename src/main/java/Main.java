
import com.gunjan.GrammerFiles.CQLParser;
import com.gunjan.Implementation.CQLVisitorImpl;
import com.gunjan.ParserUtil.ParserFacade;
import org.antlr.v4.runtime.tree.ParseTree;

import java.io.IOException;

public class Main {
    public static final String CQL = "Age.cql";

    public static void main(String[] args) throws IOException {
        CQLParser parser = ParserFacade.parse(CQL);
//        walker.walk(listener,);

        ParseTree tree = parser.library();
//        parser.addParseListener(new CQLListenerImpl());
        CQLVisitorImpl impl = new CQLVisitorImpl();

        tree = (ParseTree) impl.visit(tree);

        System.out.println("Test");
    }
}
