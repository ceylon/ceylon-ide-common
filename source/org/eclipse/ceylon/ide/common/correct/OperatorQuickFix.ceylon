/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import org.eclipse.ceylon.compiler.typechecker.parser {
    CeylonLexer
}
import org.eclipse.ceylon.compiler.typechecker.tree {
    Tree,
    Visitor,
    Node
}
import org.eclipse.ceylon.ide.common.platform {
    platformServices,
    DeleteEdit,
    InsertEdit,
    ReplaceEdit
}

import org.antlr.runtime {
    CommonToken
}
import java.lang {
    overloaded
}

shared object operatorQuickFix {
 
    shared void addSwapBinaryOperandsProposal(QuickFixData data, 
            Tree.BinaryOperatorExpression? boe) {
        if (exists boe,
            exists lt = boe.leftTerm,
            exists rt = boe.rightTerm) {
            
            value change = platformServices.document.createTextChange {
                name = "Swap Operands";
                input = data.phasedUnit;
            };
            change.initMultiEdit();
            value lto = lt.startIndex.intValue();
            value ltl = lt.distance.intValue();
            value rto = rt.startIndex.intValue();
            value rtl = rt.distance.intValue();
            value doc = change.document;
            
            change.addEdit(ReplaceEdit {
                start = lto;
                length = ltl;
                text = doc.getText(rto, rtl);
            });
            change.addEdit(ReplaceEdit {
                start = rto;
                length = rtl;
                text = doc.getText(lto, ltl);
            });
            data.addQuickFix {
                description = "Swap operands of ``boe.mainToken.text`` expression";
                change = change;
            };
        }
    }
    
    shared void addReverseOperatorProposal(QuickFixData data, 
            Tree.BinaryOperatorExpression? boe) {
        if (is Tree.ComparisonOp boe) {
            value change = platformServices.document.createTextChange {
                name = "Reverse Operator";
                input = data.phasedUnit;
            };
            change.initMultiEdit();

            if (exists lt = boe.leftTerm,
                exists rt = boe.rightTerm) {
                
                value lto = lt.startIndex.intValue();
                value ltl = lt.distance.intValue();
                value rto = rt.startIndex.intValue();
                value rtl = rt.distance.intValue();
                assert (is CommonToken op = boe.mainToken);
                value ot = op.text;
                value iot = reversed(ot);
                change.addEdit(ReplaceEdit {
                    start = op.startIndex;
                    length = ot.size;
                    text = iot;
                });

                value document = change.document;
                change.addEdit(ReplaceEdit {
                    start = lto;
                    length = ltl;
                    text = document.getText(rto, rtl);
                });
                change.addEdit(ReplaceEdit {
                    start = rto;
                    length = rtl;
                    text = document.getText(lto, ltl);
                });
                
                data.addQuickFix {
                    description = "Convert ``ot`` to ``iot``";
                    change = change;
                };
            }
        }
    }
    
    shared void addInvertOperatorProposal(QuickFixData data, 
            Tree.BinaryOperatorExpression? boe) {
        if (is Tree.ComparisonOp|Tree.LogicalOp boe) {
            value change = platformServices.document.createTextChange {
                name = "Invert Operator";
                input = data.phasedUnit;
            };
            change.initMultiEdit();

            if (exists lt = boe.leftTerm,
                exists rt = boe.rightTerm) {

                assert (is CommonToken op = boe.mainToken);
                value ot = op.text;
                value iot = inverted(ot);
                change.addEdit(ReplaceEdit {
                    start = op.startIndex;
                    length = ot.size;
                    text = iot;
                });
                change.addEdit(InsertEdit {
                    start = boe.startIndex.intValue();
                    text = "!(";
                });
                change.addEdit(InsertEdit {
                    start = boe.endIndex.intValue();
                    text = ")";
                });
                
                if (is Tree.LogicalOp boe) {
                    // TODO !!!!
                    //invertTerm(boe.leftTerm, change);
                    //invertTerm(boe.rightTerm, change);
                }
                
                data.addQuickFix {
                    description = "Convert ``ot`` to ``iot``";
                    change = change;
                };
            }
        }
    }

    String inverted(String ot) {
        switch (ot)
        case (">") {
            return "<=";
        }
        case (">=") {
            return "<";
        }
        case ("<") {
            return ">=";
        }
        case ("<=") {
            return ">";
        }
        case ("||") {
            return "&&";
        }
        case ("&&") {
            return "||";
        }
        else {
            return ot;
        }
    }

    String reversed(String ot) {
        switch (ot)
        case (">") {
            return "<";
        }
        case (">=") {
            return "<=";
        }
        case ("<") {
            return ">";
        }
        case ("<=") {
            return ">=";
        }
        else {
            return ot;
        }
    }
    
    shared void addParenthesesProposals(QuickFixData data, 
            Tree.OperatorExpression? oe) {
        Node? node;
        if (is Tree.ArgumentList argList = data.node) {
            object findInvocationVisitor extends Visitor() {
                variable Tree.InvocationExpression? current = null;
                shared variable Tree.InvocationExpression? result = null;

                overloaded
                shared actual void visit(Tree.InvocationExpression that) {
                    value old = current;
                    current = that;
                    super.visit(that);
                    current = old;
                }

                overloaded
                shared actual void visit(Tree.ArgumentList that) {
                    if (argList == that) {
                        result = current;
                    } else {
                        super.visit(that);
                    }
                }
            }
            findInvocationVisitor.visit(data.rootNode);
            node = findInvocationVisitor.result;
        }
        else {
            object ignoreLeftSideVisitor extends Visitor() {
                variable shared Node? result = null;
                shared actual void visit(Tree.SpecifierStatement that) {
                    //ignore LHSs of assignments
                    if (exists rhs = that.specifierExpression) {
                        rhs.visit(this);
                    }
                }
                shared actual void visitAny(Node node) {
                    if (node==data.node) {
                        result = node;
                    }
                    else {
                        super.visitAny(node);
                    }
                }
            }
            ignoreLeftSideVisitor.visit(data.rootNode);
            node = ignoreLeftSideVisitor.result;
        }

        switch (node)
        case (is Tree.Expression) {
            addRemoveParenthesesProposal(data, node);
        }
        else case (is Tree.Term) {
            addAddParenthesesProposal(data, node);
            if (exists oe, oe != node) {
                addAddParenthesesProposal(data, oe);
            }
        }
        else {}
    }
    
    function termDescription(Node node) {
        switch (node)
        case (is Tree.OperatorExpression) {
            return node.mainToken.text + " expression";
        }
        case (is Tree.QualifiedMemberOrTypeExpression) {
            return "member reference";
        }
        case (is Tree.BaseMemberOrTypeExpression) {
            return "base reference";
        }
        case (is Tree.Literal) {
            return "literal";
        }
        case (is Tree.InvocationExpression) {
            return "invocation";
        }
        else {
            return "expression";
        }
    }

    void addAddParenthesesProposal(QuickFixData data, Node node) {
        
        value change = platformServices.document.createTextChange {
            name = "Add Parentheses";
            input = data.phasedUnit;
        };
        change.initMultiEdit();
        change.addEdit(InsertEdit {
            start = node.startIndex.intValue();
            text = "(";
        });
        change.addEdit(InsertEdit {
            start = node.endIndex.intValue();
            text = ")";
        });
        
        data.addQuickFix {
            description = "Parenthesize " + termDescription(node);
            change = change;
        };
    }
    
    void addRemoveParenthesesProposal(QuickFixData data, Node node) {
        if (exists token = node.token,
            exists endToken = node.endToken,
            token.type == CeylonLexer.lparen,
            endToken.type == CeylonLexer.rparen) {
            
            value change = platformServices.document.createTextChange {
                name = "Remove Parentheses";
                input = data.phasedUnit;
            };
            change.initMultiEdit();
            change.addEdit(DeleteEdit {
                start = node.startIndex.intValue();
                length = 1;
            });
            change.addEdit(DeleteEdit {
                start = node.endIndex.intValue() - 1;
                length = 1;
            });
            
            data.addQuickFix {
                description = "Remove parentheses";
                change = change;
            };
        }
    }
}
