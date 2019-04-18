package com.gunjan.ParserUtil;

import com.gunjan.GrammerFiles.CQLLexer;
import com.gunjan.GrammerFiles.CQLParser;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;

public class ParserFacade {
    private static String readFile(File file, Charset encoding) throws IOException {
        byte[] encoded = Files.readAllBytes(file.toPath());
        return new String(encoded, encoding);
    }
    public static CQLParser parse(File file) throws IOException {
        String code = readFile(file, Charset.forName("UTF-8"));
        CQLLexer lexer = new CQLLexer(new ANTLRInputStream(code));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        CQLParser parser = new CQLParser(tokens);
        return parser;
    }

    public static CQLParser parse(String file) throws IOException {
       File f = new File (file);
       return parse(f);
    }
}
