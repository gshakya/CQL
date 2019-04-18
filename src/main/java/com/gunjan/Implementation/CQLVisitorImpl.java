package com.gunjan.Implementation;

import com.gunjan.GrammerFiles.CQLBaseVisitor;
import com.gunjan.GrammerFiles.CQLParser;

public class CQLVisitorImpl extends CQLBaseVisitor<Object> {

    @Override
    public Object visitExpressionDefinition(CQLParser.ExpressionDefinitionContext ctx){
        System.out.println("Expression Definition Context");
        return ctx.getChild(1);
    }

    @Override
    public Object visitVersionSpecifier(CQLParser.VersionSpecifierContext ctx) {
        System.out.println("Version Specifier");
        return visitChildren(ctx);
    }


    @Override public Object visitLibrary(CQLParser.LibraryContext ctx) {
        System.out.println("Library");
        return visitChildren(ctx);
    }

    @Override
    public Object visitUsingDefinition(CQLParser.UsingDefinitionContext ctx) {
        System.out.println("In using definition");

        return super.visitUsingDefinition(ctx);
    }
}
